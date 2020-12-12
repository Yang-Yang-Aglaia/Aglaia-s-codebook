%% Screen Setting
function [w1,wRect,xCenter,yCenter,triangle,SCALE_GL,black,font_size,cue_dir,Checkcue_dir,red]=StimPrepare()
%HideCursor;
scnNo = max(Screen('Screens'));
%black = BlackIndex(scnNo);
black = [0 0 0];
blue = [0 0 255];
white = [255 255 255];
yellow = [255 255 0];
green = [0 255 0];
orange = [255 255 0];
red = [255 80 0];
gray = [128,128,128];
[w1,wRect] = Screen('OpenWindow',scnNo,gray); %,,[0 0 1366 600],[0 0 600 600]
%w1=Screen('OpenWindow',scnNo,black,[0 0 1366 768]);


ifi1 = Screen('GetFlipInterval', w1);

%定义屏幕显示的字体大小，字体类型，以及字体的线条
Screen('TextSize', w1, 40);
font_size =30;
Screen('TextFont',w1,'Simsun');
Screen('TextStyle', w1, 1); %0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend


[wide_x, high_y] = Screen('WindowSize',w1);% 在这里w1和w2的屏幕大小是一样的，所以只需要设置一次就可以了
xCenter = wide_x/2;
yCenter = high_y/2;

Screen('BlendFunction', w1, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%% material prepare
folder_path = cd;
cue_dir = fullfile(folder_path,'material_group');
if ~isdir(cue_dir)
    error('There is no stimuli image directory');
end

Checkcue_dir = fullfile(folder_path,'CheckMaterial');
if ~isdir(cue_dir)
    error('There is no stimuli image directory');
end
% 确定选择时的线索提示
%belt = fullfile(folder_path,'stimuli_response');
% belt_pic = imread(fullfile(cue_dir,'belt.jpg'));
% belt_figure = Screen('MakeTexture',w1,belt_pic);

triangle_pic = imread(fullfile(cue_dir,'triangle.png'));
triangle = Screen('MakeTexture',w1,triangle_pic);
SCALE_GL_pic = imread(fullfile(cue_dir,'SCALE_GL.png'));
SCALE_GL = Screen('MakeTexture',w1,SCALE_GL_pic);