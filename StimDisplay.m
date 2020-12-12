function [chose_onset,picnum,picid]=StimDisplay(stinum,iid,i,w1,stimi,cue_dir,xCenter,yCenter,font_size,black)
% i为5中数字的id
% num为试次数
% iid为数字的随机列
% stinum为5种数字
numi = iid(i);
chose_onset = GetSecs;    %按键开始时间
picid = stinum(numi);
%%%准备刺激
pngs = dir('D:\Yangyang\ExpOne\FinalExpProcedureClient\material_group\*.jpg');  %读取文件夹中所有文件
picname = randperm(42,42); %不重复随机整数矩阵
filename = pngs(picname(stimi)).name;  %得到图片的名字
S = regexp(filename, '_', 'split');  %分割出数字
picnum = str2num(char(S(1)));  %字符串变成数字,需要输出
checknum = 0;
while checknum == 0
    if abs(picnum - picid) == 1
        dot_pic = imread(fullfile(cue_dir,filename)); %读取图片
        checknum = 1;
    elseif abs(picnum - picid) ~= 1
        stimi = stimi + 1;
        if stimi >42
            stimi = 42;
        end
        filename = pngs(picname(stimi)).name;  %得到图片的名字
        S = regexp(filename, '_', 'split');  %分割出数字
        picnum = str2num(char(S(1)));  %字符串变成数字,需要输出
    end
    if checknum == 1
        break
    end
end
dot_pic = imread(fullfile(cue_dir,filename)); %读取图片

% 保证大小概率一致
% if StimSeq == 0
%     picname = picid - 1; %不重复随机整数矩阵
% elseif StimSeq == 1
%     picname = picid + 1; %不重复随机整数矩阵
% end
% filename = pngs(picname(stimi)).name;  %得到图片的名字
% S = regexp(filename, '_', 'split');  %分割出数字
% picnum = str2num(char(S(1)));  %字符串变成数字,需要输出

            
%%% fixation point（直接画）
fixation = double('+');
DrawFormattedText(w1,fixation,'center','center', 1, [],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);
WaitSecs(1.5);
%             Screen('DrawDots', w1, [x_center; y_center], 10, [255,255,255], [], 1);
%             Screen('Flip',w1);
%             WaitSecs(cell2mat(data(trial, 5)));

%%% present stimulus
belt_figure = Screen('MakeTexture',w1,dot_pic);  %写出图片
Screen('DrawTexture',w1, belt_figure);
Screen('Flip',w1);  %换屏
WaitSecs(1.5);  %呈现时间

% action 1（数字是随机选取的，需要呈现出来）
% Screen('FrameRect', w1, black, [xCenter+425 yCenter-15 xCenter+63 yCenter+150],[1]);%不需要框
Bigword = double('大');
Smallword = double('小');
DrawFormattedText(w1,double(['你认为上图中的点数与',num2str(picid),'的关系']),xCenter ,yCenter+8.5*font_size-100, black,[],[],[],2);  %xCenter+470 ,yCenter+8.5*font_size-300
DrawFormattedText(w1,Bigword,xCenter-100 ,yCenter+8.5*font_size+100, 1, [],[],[],2);
DrawFormattedText(w1,Smallword,xCenter+100 ,yCenter+8.5*font_size+100, 1, [],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);