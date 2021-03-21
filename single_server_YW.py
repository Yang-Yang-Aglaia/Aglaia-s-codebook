# %%
import os
from asyncio.tasks import sleep
from psychopy import gui, logging, core
import psychopy
from psychopy.hardware import keyboard
import asyncio
from asyncio import StreamReader, StreamWriter, gather
from collections import deque, defaultdict
from typing import Deque, DefaultDict

from wx.core import PlatformInfo
from msgproto import read_msg, send_msg, INFO_TYPE
import numpy as np
import pandas as pd
import socket
logging.console.setLevel(logging.DEBUG)
kb = keyboard.Keyboard()

# %%create network connection


prompt_box = gui.Dlg(title='实验信息，主试填写')
prompt_box.addField(label='组编号')
prompt_box.addField(label='拉丁方次序')
prompt_box.show()

group_id = prompt_box.data[0]
latin_square_type = prompt_box.data[1]
N_CLIENTS = 2

if latin_square_type == '1':
    latin_square_seq = ['2', '3', '4', '5']
elif latin_square_type == '2':
    latin_square_seq = ['5', '2', '3', '4']
elif latin_square_type == '3':
    latin_square_seq = ['4', '5', '2', '3']
elif latin_square_type == '4':
    latin_square_seq = ['3', '4', '5', '2']
else:
    raise ValueError('wrong latin square type')
run_clock = core.Clock()

clients_tuple = []
clients_reader = []
clients_writer = []
port_to_subject_id = {}

# % prepare network server setting


async def clients_connected(reader, writer):
    port_num = writer.get_extra_info('peername')  # peername socket sockname
    # subject_id=await read_msg(reader,required_round=-1)
    # port_to_subject_id[str(port_num[1])]=subject_id

    clients_tuple.append((reader, writer))
    clients_reader.append(reader)
    clients_writer.append(writer)

    print('New connection from'+str(port_num))


async def check_game_ready():
    """
    check if all clients connected
    send ready signal to all clients
    wait all clients' ready signal
    """
    while len(clients_reader) < N_CLIENTS:
        print('waiting')
        await asyncio.sleep(1)
    server_ready_signal = str(True)  # the signal
    # when all clients connected
    # send ready signal to all clients
    await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['SERVER_READY'], n_round_in_game=-1, data=server_ready_signal) for writer in clients_writer])


async def check_run_ready():
    """
    check if received signal from all clients
    """
    clients_ready_signal = await gather(*[read_msg(reader, required_round=-1) for reader in clients_reader])
    for item in clients_ready_signal:
        if item[1] != str(INFO_TYPE['CLIENT_READY']):
            raise ValueError('expected client_ready signal')


def create_trial_seq(new_patch: bool, last_reward: float):
    """
    create next round reward
    """
    if new_patch:
        reward = np.random.normal(loc=10, scale=1)
    else:
        decay_rate = np.random.normal(loc=0.88, scale=0.07)
        reward = last_reward*decay_rate
    return reward


async def run_single_person_experiment(reader: StreamReader, writer: StreamWriter):
    """

    """
    behavior_data = pd.DataFrame(columns=['round_in_game', 'group_id', 'patch_visited',
                                          'current_reward', 'total_reward', 'sub_id', 'sub_choice', 'sub_response_time'])

    n_round_in_game = 0
    run_clock.reset()
    total_reward = 0

    n_patch_visited = 0
    sub_id = 0
    try:
        # total_time:10min
        while run_clock.getTime() <= 10:
            # currently in a patch
            leave = False
            n_round_harvested = 0
            new_patch = True
            last_reward = 0
            while not leave:
                current_reward = create_trial_seq(
                    new_patch=new_patch, last_reward=last_reward)
                current_reward_text = round(current_reward, 1)
                last_reward = current_reward
                new_patch = False
                total_reward += current_reward_text
                n_round_harvested += 1
                print('sending reward:'+str(current_reward_text))
                await send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['REWARD'], n_round_in_game=n_round_in_game, data=str(current_reward_text))
                choice = await read_msg(Stream=reader, required_round=n_round_in_game)
                RT = await read_msg(Stream=reader, required_round=n_round_in_game)
                received_time=run_clock.getTime()
                sub_id = choice[0]
                choice_info_type = choice[1]
                RT_info_type = RT[1]
                if choice_info_type != INFO_TYPE['CHOICE']:
                    raise ValueError('required Choice')
                if RT_info_type != INFO_TYPE['RT']:
                    raise ValueError('required RT')
                choice_data = choice[2]
                RT_data = RT[2]
                current_data = pd.Series({'round_in_game': n_round_in_game, 'patch_visited': n_patch_visited, 'group_id': group_id, 'patch_visited': n_patch_visited,
                                          'current_reward': current_reward_text, 'total_reward': total_reward, 'sub_id': sub_id, 'sub_choice': choice_data, 'sub_response_time': RT_data,'run_time':received_time})
                behavior_data = behavior_data.append(
                    current_data, ignore_index=True)
                if choice_data == '1':
                    leave = True
                else:
                    leave = False
                n_round_in_game += 1
            n_patch_visited += 1
            # ask the clients to travel
            await send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['REWARD'], n_round_in_game=n_round_in_game, data=str('-1'))
            n_round_in_game += 1
        await send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['RUN_OVER'], n_round_in_game='-1', data=str('-1'))
    except KeyboardInterrupt:
        print('Interrupted by server')
        behavior_data_path = str(group_id)+'_' + \
            '_'+str(latin_square_type)+'_'+sub_id+'_'+'single'+'.csv'
        behavior_data.to_csv(behavior_data_path)
    behavior_data_path = str(group_id)+'_' + \
        '_'+str(latin_square_type)+'_'+sub_id+'_'+'single'+'.csv'
    behavior_data.to_csv(behavior_data_path)


async def run_multi_person_experiment(quorum):

    n_round_in_game = 0
    run_clock.reset()
    total_reward = 0
    behavior_data_path ='F:\\ShareCache\\姚旺_1801110663\\研究\\forage\\quorum实验\\data\\' +str(group_id)+'_' + \
        '_'+str(latin_square_type)+'_'+str(quorum)+'.csv'
    data_path_exists = os.path.exists(behavior_data_path)
    # if data_path_exists:
    #     sys.exit("Filename " + behavior_data_path + " already exists!")
    behavior_data = pd.DataFrame(columns=['round_in_game', 'group_id', 'quorum', 'patch_visited',
                                          'current_reward', 'total_reward', 'sub_id', 'sub_choice', 'sub_response_time'])
    n_patch_visited = 0

    # total_time:10min
    try:
        while run_clock.getTime() <= 10:
            # currently in a patch
            leave = False
            n_round_harvested = 0
            n_proposed = 0
            new_patch = True
            last_reward = 0
            while not leave:
                current_reward = create_trial_seq(
                    new_patch=new_patch, last_reward=last_reward)
                current_reward_text = round(current_reward, 1)
                last_reward = current_reward
                new_patch = False
                total_reward += current_reward_text
                n_round_harvested += 1
                print('sending reward:'+str(current_reward_text))
                send_reward = gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['REWARD'],
                                                n_round_in_game=n_round_in_game, data=str(current_reward_text)) for writer in clients_writer])
                send_n_propose = gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['N_PROPOSE'],
                                                   n_round_in_game=n_round_in_game, data=str(n_proposed)) for writer in clients_writer])
                choice = await gather(*[read_msg(Stream=reader, required_round=n_round_in_game) for reader in clients_reader])
                RT = await gather(*[read_msg(Stream=reader, required_round=n_round_in_game) for reader in clients_reader])
                received_time=run_clock.getTime()
                choice_list = dict()
                RT_list = dict()
                sub_id_list = []
                for _ in choice:
                    _id = _[0]
                    sub_id_list.append(_id)
                    _choice = _[2]
                    choice_list[_id] = _choice
                for _ in RT:
                    _id = _[0]
                    _RT = _[2]
                    RT_list[_id] = _RT

                for id in sub_id_list:
                    choice = choice_list[id]
                    RT = RT_list[id]
                    print(choice)
                    print(RT)
                    current_data = pd.Series({'round_in_game': n_round_in_game, 'patch_visited': n_patch_visited, 'group_id': group_id, 'quorum': quorum, 'patch_visited': n_patch_visited,
                                              'current_reward': current_reward_text, 'total_reward': total_reward, 'sub_id': id, 'sub_choice': choice, 'sub_response_time': RT,'run_time':received_time})
                    behavior_data = behavior_data.append(
                        current_data, ignore_index=True)
                    if choice == '1':
                        n_proposed += 1
                if n_proposed < int(quorum):
                    leave = False
                else:
                    leave = True
                n_round_in_game += 1
            n_patch_visited += 1
            # ask the clients to travel
            await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['TRAVEL'], n_round_in_game=n_round_in_game, data=str('-1')) for writer in clients_writer])
            n_round_in_game += 1
        await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['RUN_OVER'], n_round_in_game='-1', data=str('-1')) for writer in clients_writer])
    except KeyboardInterrupt:
        print('Interrupted by server')
        behavior_data.to_csv(behavior_data_path)
    behavior_data.to_csv(behavior_data_path)


async def main(client_connected_cb, host, port, group_id):
    server = await asyncio.start_server(
        client_connected_cb=client_connected_cb, host=host, port=port, family=socket.AF_INET)
    # async with server:
    asyncio.create_task(server.serve_forever())
    if int(group_id) % 2 == 0:
        # single first
        await check_game_ready()
        await check_run_ready()
        await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['START_SINGLE'], n_round_in_game=-1, data='True') for writer in clients_writer])
        await check_run_ready()
        await gather(*[run_single_person_experiment(*reader_writer) for reader_writer in clients_tuple])
        await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['START_MULTI'], n_round_in_game=-1, data='True') for writer in clients_writer])
        for quorum in latin_square_seq:
            await check_run_ready()
            await check_run_ready()
            await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['QUORUM'], n_round_in_game=-1, data=str(quorum)) for writer in clients_writer])
            await run_multi_person_experiment(quorum)
    else:
        # multi first
        await check_game_ready()
        await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['START_MULTI'], n_round_in_game=-1, data='True') for writer in clients_writer])
        for quorum in latin_square_seq:
            await check_run_ready()
            await check_run_ready()
            await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['QUORUM'], n_round_in_game=-1, data=str(quorum)) for writer in clients_writer])
            await run_multi_person_experiment(quorum)
        await check_run_ready()
        await gather(*[send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['START_SINGLE'], n_round_in_game=-1, data='True') for writer in clients_writer])
        await check_run_ready()
        await gather(*[run_single_person_experiment(*reader_writer) for reader_writer in clients_tuple])

# %%
if __name__ == '__main__':
    asyncio.run(main(clients_connected, host='127.0.0.1',
                     port=25000, group_id=group_id))

# %%
