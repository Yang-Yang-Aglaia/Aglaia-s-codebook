%% 定义按键
function [more,less,rateless,ratemore,yeschange,nochange,stop_rating,start_action,escape_action,move_left,move_right, ...
    frame_left_left,frame_left_right,frame_right_left,frame_right_right] = KeyBoard(xCenter,yCenter)
%定义实验第一部分的按键
more = KbName('q');  % 多于电脑给的数字
less = KbName('p'); % 少于电脑给的数字
rateless = KbName('f'); %选择第二个belt
ratemore = KbName('j'); %选择第三个belt
yeschange = KbName('q');
nochange = KbName('p');


stop_rating = KbName('u');
start_action = KbName('q');
escape_action = KbName('escape');


move_left = -75.83333;
move_right = 75.83333;
%confidence_response_maxRT = 10;
frame_left_left   = [xCenter-695 yCenter-170 xCenter-445 yCenter+170];
frame_left_right  = [xCenter-335 yCenter-170 xCenter-80  yCenter+170];
frame_right_left  = [xCenter+30  yCenter-170 xCenter+290 yCenter+170];
frame_right_right = [xCenter+405 yCenter-170 xCenter+655 yCenter+170];