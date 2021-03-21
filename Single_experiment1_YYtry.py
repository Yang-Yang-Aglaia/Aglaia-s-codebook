# %% module
from psychopy import event, visual, data, core, gui
import random
import os
# import Image
import numpy as np
from itertools import *

# %% background settings
'''
setting background parameters
'''
def MakeStimBackGround(exp_win):
    t = TextStim(exp_win, text = '+', pos = (0, 0), colorSpace = 'rgb255', color = COLOR['white'], units = 'pix', height = 32)
    stimBackground = BufferImageStim(exp_win, stim = t)
    return stimBackground

# %% 按键设置

def WaitTheKey(exp_win, key = 'space'):
    event.clearEvents()
    while key not in event.getKeys():
        pass

def ShowTextAndWaitTheKey(exp_win, text='', wait = 0, key = '', pos=(0,-0.0),  height = 55, units = "pix"):
    compaid = companum[i]
    text = '您认为图中的点数与' + compaid + '的关系：\n多         少'
    t =TextStim(exp_win, text ,pos = pos,  height = height, units = units)
    t.draw()
    event.clearEvents()
    clk = clock.CountdownTimer(wait)
    win.flip()
    while clk.getTime() > 0:
        pass
    while key not in event.getKeys():
        pass

def ShowTextAndWait(exp_win, text = '', wait = 0, pos=(0,-0.0),  height = 55, units = "pix"):
    t =TextStim(exp_win, text ,pos = pos,  height = height, units = units)
    t.draw()
    clk = clock.CountdownTimer(wait)
    win.flip()
    while clk.getTime() > 0:
        pass

def ShowRatingAndWaitTheKey(exp_win, text='', wait = 0, key = '', pos=(0,-0.0),  height = 55, units = "pix"):
    Rating =visual.RatingScale(win = MyWindown,scale="无信心 ------无感------充满信心", low=1, high=7,precision=1,pos=(0,-0.1),showValue=True, marker='cirle')
    #呈现刺激,不断的刷新屏幕
    while Rating.noResponse:
        Rating.draw()
        Text.draw()
        MyWindown.flip()

    #如果被试确定了刺激，就进行下一个画面

    '''
    Text1 = visual.TextStim(exp_win, text = u"请等待他人反应",units= 'pix',pos=(0,100))
    Text1.draw()
    exp_win.flip()
    core.wait(5)
    exp_win.close()
    '''

#%% 指导语和注视点
def ShowIntro(exp_win):
    inrotext = u'''您需要对下图中点数数量进行判断\n您认为数量大于屏幕中给出的数字时请按Q\n小于屏幕中给出的数字时请按P'''
    ShowTextAndWaitTheKey(exp_win, inrotext)

def ShowFixation1(exp_win, stimBackground):
    clk = clock.CountdownTimer(0.8)
    stimBackground.draw()
    win.flip()
    while clk.getTime() > 0:
        pass

# %% pictures stimulus
'''
imead a single picture from folder
'''
def pictimi(exp_win,trail):
    stimpic = ''.join(trails[trail])  # join是连接函数
    img_full_path = os.path.join(data_path, stimpic)
    pic = visual.ImageStim(exp_win, image = img_full_path)
    pic.draw()
    exp_win.flip()
    core.wait(2)

#%% 实验流程
prompt_box = gui.Dlg(title='实验即将开始，请做好准备！')
prompt_box.show()
# setting
#定义一些基本常量
fullscr = False

COLOR = {'red':   [220, 0, 0],
         'green': [0, 165, 0],
         'blue':  [18, 18, 255],
         'white': [255, 255, 255],
         'black': [0, 0, 0],
         'gray':  [127, 127, 127]
         }

N = 168   # 试次数

img_path = 'E:\\ScholarFight\\Experiment design\\Exp1_Individual\\Individual_experiment\\NorepPic'
picfir = os.listdir(img_path) # 读取文件夹中图片
# itertools里的product会生成一个迭代器，这个迭代器会依次返回多个循环器集合的笛卡尔积，相当于嵌套循环。在外面套上list把结果转换成列表。
trails = list(product(picfir))
random.shuffle(trails)

exp_win = visual.Window(size=(1000,600), color= (0.5,0.5,0.5), fullscr= False)

for i in range(N):

    RT = 0
    rKey = 0

    # MakeStimBackGround(exp_win)
    ShowFixation1(exp_win, stimBackground)
    pictimi(exp_win,i)
    key = ShowTextAndWaitTheKey(exp_win, text='', wait = 0, key = '')
    if key != 'timeout':
        ShowTimePre(exp_win)
        RT = -1
        rKey = 0
    else:
        (rKey, RT) = ShowTarget(exp_win, tloc, stimBackground)
        if tloc == 0 and rKey != 'timeout':
            ShowTimePre(exp_win)
        elif tloc !=0 and rKey == 'timeout':
            ShowTimeOut(exp_win)
        else:
            pass

    ShowBlank(exp_win, 0.7)

    if rKey == 'q':
        StoreResult('exp-' + name, i, trails, results)
        exp_win.close()
        exit(0)

    results.append((rKey, RT))

    if i % 60 == 59:
        ShowBreak(exp_win)

StoreResult('exp-' + name, N, trails, results)
ShowEnd(exp_win)


exp_win.close()



# %%
