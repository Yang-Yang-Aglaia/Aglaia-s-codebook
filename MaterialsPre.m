function [triangle,SCALE_GL,more,less,rateless,ratemore,stop_rating,start_action,escape_action,move_left,...
    move_right,frame_left_left,frame_left_right,frame_right_left,frame_right_right,cue_dir,Checkcue_dir] = MaterialsPre(w1,xCenter,yCenter)
%% material prepare
folder_path = cd;
cue_dir = fullfile(folder_path,'material_group');
if ~isdir(cue_dir)
    error('There is no stimuli image directory');
end

Checkcue_dir = fullfile(folder_path,'CheckMaterial');
if ~isdir(Checkcue_dir)
    error('There is no stimuli image directory');
end

% 确定选择时的线索提示
%belt = fullfile(folder_path,'stimuli_response');
%我的图直接需要变换调取

triangle_pic = imread(fullfile(cue_dir,'triangle.png'));
triangle = Screen('MakeTexture',w1,triangle_pic);
SCALE_GL_pic = imread(fullfile(cue_dir,'SCALE_GL.png'));
SCALE_GL = Screen('MakeTexture',w1,SCALE_GL_pic);


%% 按键和位置定义
%定义实验第一部分的按键
more = KbName('q');  % 多于电脑给的数字
less = KbName('p'); % 少于电脑给的数字
rateless = KbName('f'); %选择第二个belt
ratemore = KbName('j'); %选择第三个belt


stop_rating = KbName('u');
start_action = KbName('q');  %开始实验
escape_action = KbName('escape');  %终止实验

move_left = -75.83333;  %这个数字表示的scale中的单位长度
move_right = 75.83333;
%confidence_response_maxRT = 10;
% 红框的位置坐标嘛？！
frame_left_left   = [xCenter-695 yCenter-170 xCenter-445 yCenter+170];
frame_left_right  = [xCenter-335 yCenter-170 xCenter-80  yCenter+170];
frame_right_left  = [xCenter+30  yCenter-170 xCenter+290 yCenter+170];
frame_right_right = [xCenter+405 yCenter-170 xCenter+655 yCenter+170];