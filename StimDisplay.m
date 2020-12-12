function [chose_onset,picnum,picid]=StimDisplay(stinum,iid,i,w1,stimi,cue_dir,xCenter,yCenter,font_size,black)
% iΪ5�����ֵ�id
% numΪ�Դ���
% iidΪ���ֵ������
% stinumΪ5������
numi = iid(i);
chose_onset = GetSecs;    %������ʼʱ��
picid = stinum(numi);
%%%׼���̼�
pngs = dir('D:\Yangyang\ExpOne\FinalExpProcedureClient\material_group\*.jpg');  %��ȡ�ļ����������ļ�
picname = randperm(42,42); %���ظ������������
filename = pngs(picname(stimi)).name;  %�õ�ͼƬ������
S = regexp(filename, '_', 'split');  %�ָ������
picnum = str2num(char(S(1)));  %�ַ����������,��Ҫ���
checknum = 0;
while checknum == 0
    if abs(picnum - picid) == 1
        dot_pic = imread(fullfile(cue_dir,filename)); %��ȡͼƬ
        checknum = 1;
    elseif abs(picnum - picid) ~= 1
        stimi = stimi + 1;
        if stimi >42
            stimi = 42;
        end
        filename = pngs(picname(stimi)).name;  %�õ�ͼƬ������
        S = regexp(filename, '_', 'split');  %�ָ������
        picnum = str2num(char(S(1)));  %�ַ����������,��Ҫ���
    end
    if checknum == 1
        break
    end
end
dot_pic = imread(fullfile(cue_dir,filename)); %��ȡͼƬ

% ��֤��С����һ��
% if StimSeq == 0
%     picname = picid - 1; %���ظ������������
% elseif StimSeq == 1
%     picname = picid + 1; %���ظ������������
% end
% filename = pngs(picname(stimi)).name;  %�õ�ͼƬ������
% S = regexp(filename, '_', 'split');  %�ָ������
% picnum = str2num(char(S(1)));  %�ַ����������,��Ҫ���

            
%%% fixation point��ֱ�ӻ���
fixation = double('+');
DrawFormattedText(w1,fixation,'center','center', 1, [],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);
WaitSecs(1.5);
%             Screen('DrawDots', w1, [x_center; y_center], 10, [255,255,255], [], 1);
%             Screen('Flip',w1);
%             WaitSecs(cell2mat(data(trial, 5)));

%%% present stimulus
belt_figure = Screen('MakeTexture',w1,dot_pic);  %д��ͼƬ
Screen('DrawTexture',w1, belt_figure);
Screen('Flip',w1);  %����
WaitSecs(1.5);  %����ʱ��

% action 1�����������ѡȡ�ģ���Ҫ���ֳ�����
% Screen('FrameRect', w1, black, [xCenter+425 yCenter-15 xCenter+63 yCenter+150],[1]);%����Ҫ��
Bigword = double('��');
Smallword = double('С');
DrawFormattedText(w1,double(['����Ϊ��ͼ�еĵ�����',num2str(picid),'�Ĺ�ϵ']),xCenter ,yCenter+8.5*font_size-100, black,[],[],[],2);  %xCenter+470 ,yCenter+8.5*font_size-300
DrawFormattedText(w1,Bigword,xCenter-100 ,yCenter+8.5*font_size+100, 1, [],[],[],2);
DrawFormattedText(w1,Smallword,xCenter+100 ,yCenter+8.5*font_size+100, 1, [],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);