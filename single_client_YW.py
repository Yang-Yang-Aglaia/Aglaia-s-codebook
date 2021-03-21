# %%
import pandas
import asyncio

from pandas.core.reshape.melt import wide_to_long
from msgproto import read_msg, send_msg, INFO_TYPE
from asyncio import StreamReader, StreamWriter
from psychopy import visual
from psychopy import gui, event, core
from psychopy.event import waitKeys
from psychopy.hardware import keyboard
import numpy as np
import socket
from psychopy import data, logging
from numpy import random
import pandas as pd
from psychopy.visual import text
logging.console.setLevel(logging.ERROR)
centralLog = logging.LogFile(
    "psychopyExps.log", level=logging.WARNING, filemode='a')

# Global event key (with modifier) to quit the experiment ("shutdown key").
# event.globalKeys.add(key='q', modifiers=['ctrl'], func=core.quit)
# %%create network connections and receive experiment information from server

# %%
round = 0
prompt_box = gui.Dlg(title='实验信息，主试填写')
prompt_box.addField(label='被试编号',)
# prompt_box.addField(label='port')
prompt_box.show()
sub_id = prompt_box.data[0]
if len(sub_id)==0:
    raise ValueError('no subject ID')
# local_port=prompt_box.data[1]
n_round_in_game = 0  # global round


main_window = visual.Window(size=[800, 600], color=[-1, -1, -1], fullscr=False)
prepare_text = visual.TextStim(
    win=main_window, text='', color=[1, 1, 1])
wait_for_other_text=visual.TextStim(win=main_window,text='等待其他人做好准备',color=[1,1,1])
first_start_text=visual.TextStim(win=main_window,text='做好准备，按空格键开始')
game_over_text=visual.TextStim(win=main_window,text='游戏结束，谢谢参与！',color=[1,1,1])
leave_progress_bar_text = visual.TextStim(
    win=main_window, text='正在更换投资项目，请等待', pos=(0, -0.5), color=[1, 1, 1])
_reward_text = visual.TextStim(
    win=main_window, text='本轮收益', pos=(0, 0.7), color=[1, 1, 1])
stay_progress_bar_text = visual.TextStim(
    win=main_window, text='请在进度条走完之前选择', pos=(0, -0.5), color=[1, 1, 1],height=0.05)
single_start_text=visual.TextStim(win=main_window,text='欢迎进入单人游戏阶段,按空格键开始')
multi_start_text=visual.TextStim(win=main_window,text='欢迎进入多人游戏阶段,按空格键开始')
run_over_text = visual.TextStim(
    win=main_window, text='10分钟到了，休息一下，按空格键进入新的游戏')
gold_img = visual.ImageStim(
    win=main_window, image='F:\\ShareCache\\姚旺_1801110663\\研究\\forage\\成瘾实验\\resource\\gold_coin.png', pos=(0.2, 0.52), size=[0.2, 0.2])
run_clock = core.Clock()
round_clock = core.Clock()


async def travel(n_round_in_game):
    round_clock.reset()
    while round_clock.getTime()< 9:
        time_traveled = round_clock.getTime()
        nine_second_progressbar_length = 450-time_traveled*100
        leave_progress_bar = visual.Line(win=main_window, start=(-450, -30), end=(
            nine_second_progressbar_length, -30), lineWidth=5, units='pix')
        leave_progress_bar_text.draw()
        leave_progress_bar.draw()
        main_window.flip()


async def single_harvest(current_reward, writer,n_round_in_game,leave_in_last_round):
    reward_text = visual.TextStim(win=main_window, text=str(
        current_reward), color=[1, 1, 1], pos=(0, 0.5))
    if leave_in_last_round:
        leave_text=visual.TextStim(
                win=main_window, text='更换',color=(-1.0, -1.0, -1.0))
        stay_text=visual.TextStim(
                win=main_window, text='继续', color=(-1.0, -1.0, -1.0))
    else:
        leave_text=visual.TextStim(
                win=main_window, text='更换', color=(1.0, 1.0, 1.0))
        stay_text=visual.TextStim(
                win=main_window, text='继续', color=(1.0, 1.0, 1.0))
    if int(sub_id) % 2 == 0:
        # even:f——leave，j——stay
        leave_text.pos=(-0.5, -0.5)
        stay_text.pos=(0.5, -0.5)
    else:
        # odd：f——stay，j——leave
        leave_text.pos=(0.5, -0.5)
        stay_text.pos=(-0.5, -0.5)
    three_second_progressbar_length = 150
    responded = False
    round_clock.reset()
    while round_clock.getTime() <= 3:
        event.clearEvents()
        _reward_text.draw()
        reward_text.draw()
        leave_text.draw()
        stay_text.draw()
        round_time = round_clock.getTime()
        stay_progress_bar_length = three_second_progressbar_length-round_time*100
        stay_progress_bar = visual.Line(
            win=main_window, start=(-150, -180), end=(stay_progress_bar_length, -180), lineWidth=5, units='pix')
        stay_progress_bar.draw()
        stay_progress_bar_text.draw()
        gold_img.draw()
        main_window.flip()
        # has not made decision in this current 3 second
        if not responded:
            if leave_in_last_round:
                keys=[]
                responded=True
                leave=True#keep leave
                asyncio.create_task(send_msg(writer, sub_id,INFO_TYPE['CHOICE'], n_round_in_game, '3'))#3+0.000,3 for the leave in the last round case
                asyncio.create_task(send_msg(writer, sub_id,INFO_TYPE['RT'], n_round_in_game, '0'))            
            else:
                keys = event.getKeys(
                    keyList=['f', 'j'], timeStamped=round_clock)
            # there are key press, change the has_not_made_decision_for_now flag to false
            if len(keys) != 0:
                responded = True
                choice = str(keys[0][0])
                RT = str(keys[0][1])
                if int(sub_id) % 2 == 0:
                    # even:f——leave，j——stay
                    if choice == 'f':
                        leave = True
                    else:
                        leave = False
                else:
                    # odd：f——stay，j——leave
                    if choice == 'j':
                        leave = True
                    else:
                        leave = False
                asyncio.create_task(send_msg(writer,sub_id,INFO_TYPE['CHOICE'], n_round_in_game, str(int(leave))))
                asyncio.create_task(send_msg(writer,sub_id,INFO_TYPE['RT'], n_round_in_game, RT[0:5]))
        else:
            stay_text.color = [-1, -1, -1]
            leave_text.color = [-1, -1, -1]
    if not responded:
        #flash in the last flip
        leave=False
        main_window.color = [1, 1, 1]
        main_window.flip()
        main_window.color = [-1, -1, -1]
        main_window.flip()
        asyncio.create_task(send_msg(writer, sub_id,INFO_TYPE['CHOICE'], n_round_in_game, '2'))
        asyncio.create_task(send_msg(writer, sub_id,INFO_TYPE['RT'], n_round_in_game, '0'))
    return leave

async def multi_harvest(current_reward, writer,n_round_in_game,leave_in_last_round,quorum,n_propose):
    reward_text = visual.TextStim(win=main_window, text=str(
        current_reward), color=[1, 1, 1], pos=(0, 0.5))
    n_propose_text=visual.TextStim(win=main_window,text='上一轮提议更换人数：'+str(n_propose),color=[1, 1, 1],pos=(0,0))
    quorum_text=visual.TextStim(win=main_window,text='法定人数：'+quorum,pos=(0,0.2))
    if leave_in_last_round:
        leave_text=visual.TextStim(
                win=main_window, text='更换',color=(-1.0, -1.0, -1.0))
        stay_text=visual.TextStim(
                win=main_window, text='继续', color=(-1.0, -1.0, -1.0))
    else:
        leave_text=visual.TextStim(
                win=main_window, text='更换', color=(1.0, 1.0, 1.0))
        stay_text=visual.TextStim(
                win=main_window, text='继续', color=(1.0, 1.0, 1.0))
    if int(sub_id) % 2 == 0:
        # even:f——leave，j——stay
        leave_text.pos=(-0.5, -0.5)
        stay_text.pos=(0.5, -0.5)
    else:
        # odd：f——stay，j——leave
        leave_text.pos=(0.5, -0.5)
        stay_text.pos=(-0.5, -0.5)
    three_second_progressbar_length = 150
    responded = False
    round_clock.reset()
    while round_clock.getTime() <= 3:
        event.clearEvents()
        _reward_text.draw()
        quorum_text.draw()
        n_propose_text.draw()
        reward_text.draw()
        leave_text.draw()
        stay_text.draw()
        round_time = round_clock.getTime()
        stay_progress_bar_length = three_second_progressbar_length-round_time*100
        stay_progress_bar = visual.Line(
            win=main_window, start=(-150, -180), end=(stay_progress_bar_length, -180), lineWidth=5, units='pix')
        stay_progress_bar.draw()
        stay_progress_bar_text.draw()
        gold_img.draw()
        main_window.flip()
        # has not made decision in this current 3 second
        if not responded:
            if leave_in_last_round:
                keys=[]
                responded=True
                leave=True#keep leave
                asyncio.create_task(send_msg(writer, sub_id,INFO_TYPE['CHOICE'], n_round_in_game, '3'))#3+0.000,3 for the leave in the last round case
                asyncio.create_task(send_msg(writer, sub_id,INFO_TYPE['RT'], n_round_in_game, '0'))        
            else:
                keys = event.getKeys(\
                    keyList=['f', 'j'], timeStamped=round_clock)
            # there are key press, change the has_not_made_decision_for_now flag to false
            if len(keys) != 0:
                responded = True
                choice = str(keys[0][0])
                RT = str(keys[0][1])
                if int(sub_id) % 2 == 0:
                    # even:f——leave，j——stay
                    if choice == 'f':
                        leave = True
                    else:
                        leave = False
                else:
                    # odd：f——stay，j——leave
                    if choice == 'j':
                        leave = True
                    else:
                        leave = False
                await asyncio.gather(send_msg(writer,sub_id,INFO_TYPE['CHOICE'], n_round_in_game, str(int(leave))),send_msg(writer,sub_id,INFO_TYPE['RT'], n_round_in_game, RT[0:5]))

        else:
            stay_text.color = [-1, -1, -1]
            leave_text.color = [-1, -1, -1]
    if not responded:
        #flash in the last flip
        leave=False
        main_window.color = [1, 1, 1]
        main_window.flip()
        main_window.color = [-1, -1, -1]
        main_window.flip()
        asyncio.create_task(send_msg(writer, sub_id,INFO_TYPE['CHOICE'], n_round_in_game, '2'))
        asyncio.create_task(send_msg(writer, sub_id,INFO_TYPE['RT'], n_round_in_game, '0'))
    return leave

async def connect_to_host(server_ip, server_port):
    # connect to host
    me =str(sub_id)
    print(f'Starting up {me}')
    reader,writer=await asyncio.open_connection(host=server_ip, port=server_port,family=socket.AF_INET)
    # await send_msg(writer,info_type=INFO_TYPE['SUBJECT_ID'],n_round_in_game=-1, data=me)
    print(f'I am {writer.get_extra_info("sockname")},connected to {server_ip}:{server_port}')
    server_ready=await read_msg(reader,required_round=-1)
    if server_ready[1]!=INFO_TYPE['SERVER_READY']:
        raise ValueError('required Server ready signal')
    first_start_text.draw()
    main_window.flip()
    keys = event.waitKeys(keyList=['space'])
    client_ready_signal = 'True'
    await send_msg(writer,sub_id,info_type=INFO_TYPE['CLIENT_READY'], n_round_in_game=-1,data=client_ready_signal)
    wait_for_other_text.draw()
    main_window.flip()
    return reader,writer

async def run_single_person_experiment(reader,writer):
    n_round_in_game=0
    leave_in_last_round=False
    single_start_text.draw()
    main_window.flip()
    keys = event.waitKeys(keyList=['space'])
    client_ready_signal = 'True'
    await send_msg(writer,sub_id,info_type=INFO_TYPE['CLIENT_READY'], n_round_in_game=-1,data=client_ready_signal)
    while instruction:=await read_msg(reader,required_round=n_round_in_game):
        if instruction[1]==INFO_TYPE['REWARD']:
            reward=instruction[2]
            print(reward)
            if reward == '-1':
                await travel(n_round_in_game)
                leave_in_last_round=False
                n_round_in_game+=1
            else:
                reward_text=float(reward)
                leave=await single_harvest(reward_text,writer=writer,n_round_in_game=n_round_in_game,leave_in_last_round=leave_in_last_round)
                leave_in_last_round=leave
                print(leave)
                n_round_in_game+=1
        elif instruction[1]==INFO_TYPE['RUN_OVER']:
            run_over_text.draw()
            main_window.flip()
            event.waitKeys(keyList='space')
            asyncio.create_task(send_msg(writer,sub_id,info_type=INFO_TYPE['CLIENT_READY'],n_round_in_game=-1,data='True'))
            break
        else:
            raise ValueError('need reward or run_over signal, wrong signal')


async def run_multi_person_experiment(reader,writer):
    run_num=0
    while run_num<4:
        run_num+=1
        keys = event.waitKeys(keyList=['space'])
        client_ready_signal = 'True'
        await send_msg(writer,sub_id,info_type=INFO_TYPE['CLIENT_READY'], n_round_in_game=-1,data=client_ready_signal)
        wait_for_other_text.draw()
        main_window.flip()
        quorum=await read_msg(reader,-1)
        quorum=quorum[2]
        quorum_text=visual.TextStim(win=main_window,text='法定人数：'+quorum)
        quorum_text.draw()
        main_window.flip()
        core.wait(2)
        n_round_in_game=0
        leave_in_last_round=False
        while True:
            instruction=await read_msg(reader,required_round=n_round_in_game)
            if instruction[1]==INFO_TYPE['REWARD']:
                n_propose=await read_msg(reader,required_round=n_round_in_game)
                n_propose=n_propose[2]
                print(n_propose)
                reward=instruction[2]
                reward_text=float(reward)
                leave=await multi_harvest(reward_text,writer=writer,n_round_in_game=n_round_in_game,leave_in_last_round=leave_in_last_round,quorum=quorum,n_propose=n_propose)
                leave_in_last_round=leave
                n_round_in_game+=1
            elif instruction[1]==INFO_TYPE['TRAVEL']:
                await travel(n_round_in_game)
                leave_in_last_round=False
                n_round_in_game+=1
            elif instruction[1]==INFO_TYPE['RUN_OVER']:
                run_over_text.draw()
                main_window.flip()
                event.waitKeys(keyList='space')
                asyncio.create_task(send_msg(writer,sub_id,info_type=INFO_TYPE['CLIENT_READY'],n_round_in_game=-1,data='True'))
                break
            else:
                raise ValueError('need reward or run_over signal, wrong signal')
    
async def main(server_ip, server_port):
    reader,writer=await connect_to_host(server_ip,server_port)
    while start_or_over:=await read_msg(reader,required_round=-1):
        if start_or_over[1]==INFO_TYPE['START_SINGLE']:
            await run_single_person_experiment(reader=reader,writer=writer)
        elif start_or_over[1]==INFO_TYPE['START_MULTI']:
            multi_start_text.draw()
            main_window.flip()
            await run_multi_person_experiment(reader=reader,writer=writer)
        else:
            game_over_text.draw()
            main_window.flip()
            key=waitKeys()

if __name__=='__main__':
    server_ip ='127.0.0.1'
    server_port ='25000'

    asyncio.run(main(server_ip,server_port))