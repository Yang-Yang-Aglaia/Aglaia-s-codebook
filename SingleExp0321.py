# %%
import os
from asyncio.tasks import sleep  #
from psychopy import gui, logging, visual, core, event  # 调用psychopy界面
from psychopy import data
# viual用于生成屏幕，呈现刺激
# core用于计时
# event用于记录按键
import psychopy
from psychopy.hardware import keyboard
import asyncio  #
from asyncio import StreamReader, StreamWriter, gather  # 调用线程
from collections import deque, defaultdict
from typing import Deque, DefaultDict

from wx.core import PlatformInfo, WXK_CATEGORY_NAVIGATION
from msgproto_YY import read_msg, send_msg, INFO_TYPE
import numpy as np
import pandas as pd
import socket
logging.console.setLevel(logging.DEBUG)
kb = keyboard.Keyboard()

# %%被试信息
prompt_box = gui.Dlg(title='实验即将开始，请做好准备！')
prompt_box.show()

clients_tuple = []
run_clock = core.Clock()

# %% stimulus display

win = visual.Window(size=(1000,600), color = (-1,-1,-1), fullscr = False)  # create a wwindow
pic = visual.ImageStim(win, image = '20_18_7.JPG')
pic.draw()
win.flip()
core.wait(2)
k_1 = event.waitKeys()


# %% single experiment

async def run_single_person_experiment(reader: StreamReader, writer: StreamWriter):
    """

    """
    behavior_data = pd.DataFrame(columns=['round_in_game', 'accuracy', 'sub_id', 'sub_choice', 'sub_response_time'])
    run_clock.reset()
    n_round_in_game = 0

    sub_id = 0
    try:
        while run_clock.getTime() <= 4:  # 时间小于4分钟
            decide = False
            choice = await read_msg(Stream=reader, required_round= n_round_in_game)
            RT = await read_msg(Stream=reader, required_round=n_round_in_game)
            received_time = run_clock.getTime()
            sub_id = choice[0]
            choice_info_type = choice[1]
            RT_info_type = RT[1]
            if choice_info_type != INFO_TYPE['CHOICE']:
                raise ValueError('required Choice')
            if RT_info_type != INFO_TYPE['RT']:
                raise ValueError('required RT')
            choice_data = choice[2]
            RT_data = RT[2]
            current_data = pd.Series({'round_in_game': n_round_in_game, 'sub_id': sub_id, 'sub_choice': choice_data, 'sub_response_time': RT_data,'run_time':received_time})
            behavior_data = behavior_data.append(current_data, ignore_index=True)
            if choice_data == '1':
                decide = True
            else:
                decide = False
            n_round_in_game += 1
            # ask the clients to travel
            await send_msg(Stream=writer, sub_id=0, info_type=INFO_TYPE['ACCURACY'], n_round_in_game=n_round_in_game, data=str('-1'))
    except KeyboardInterrupt:
        print('Interrupted by server')
    behavior_data_path = sub_id+'_'+'single'+'.csv'
    behavior_data.to_csv(behavior_data_path)
    behavior_data_path = sub_id+'_'+'single'+'.csv'
    behavior_data.to_csv(behavior_data_path)
