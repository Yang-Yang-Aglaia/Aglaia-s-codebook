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

% ȷ��ѡ��ʱ��������ʾ
%belt = fullfile(folder_path,'stimuli_response');
%�ҵ�ͼֱ����Ҫ�任��ȡ

triangle_pic = imread(fullfile(cue_dir,'triangle.png'));
triangle = Screen('MakeTexture',w1,triangle_pic);
SCALE_GL_pic = imread(fullfile(cue_dir,'SCALE_GL.png'));
SCALE_GL = Screen('MakeTexture',w1,SCALE_GL_pic);


%% ������λ�ö���
%����ʵ���һ���ֵİ���
more = KbName('q');  % ���ڵ��Ը�������
less = KbName('p'); % ���ڵ��Ը�������
rateless = KbName('f'); %ѡ��ڶ���belt
ratemore = KbName('j'); %ѡ�������belt


stop_rating = KbName('u');
start_action = KbName('q');  %��ʼʵ��
escape_action = KbName('escape');  %��ֹʵ��

move_left = -75.83333;  %������ֱ�ʾ��scale�еĵ�λ����
move_right = 75.83333;
%confidence_response_maxRT = 10;
% ����λ���������
frame_left_left   = [xCenter-695 yCenter-170 xCenter-445 yCenter+170];
frame_left_right  = [xCenter-335 yCenter-170 xCenter-80  yCenter+170];
frame_right_left  = [xCenter+30  yCenter-170 xCenter+290 yCenter+170];
frame_right_right = [xCenter+405 yCenter-170 xCenter+655 yCenter+170];