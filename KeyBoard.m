%% ���尴��
function [more,less,rateless,ratemore,yeschange,nochange,stop_rating,start_action,escape_action,move_left,move_right, ...
    frame_left_left,frame_left_right,frame_right_left,frame_right_right] = KeyBoard(xCenter,yCenter)
%����ʵ���һ���ֵİ���
more = KbName('q');  % ���ڵ��Ը�������
less = KbName('p'); % ���ڵ��Ը�������
rateless = KbName('f'); %ѡ��ڶ���belt
ratemore = KbName('j'); %ѡ�������belt
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