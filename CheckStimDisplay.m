function [chose_onset]=CheckStimDisplay(CheckStinum,iidprac,checki,w1,Checkcue_dir,xCenter,yCenter,font_size,black)
% iΪ5�����ֵ�id
% numΪ�Դ���
% iidΪ���ֵ������
% stinumΪ5������
numi = iidprac(checki);
chose_onset = GetSecs;    %������ʼʱ��
%%%׼���̼�
pngs = dir('D:\Yangyang\ExpOne\FinalExpProcedureClient\CheckMaterial\*.png');  %��ȡ�ļ����������ļ�
picname = randperm(5,5); %���ظ������������
filename = pngs(picname(checki)).name;  %�õ�ͼƬ������
S = regexp(filename, '_', 'split');  %�ָ������
picnum = str2num(char(S(1)));  %�ַ����������,��Ҫ���
dot_pic = imread(fullfile(Checkcue_dir,filename)); %��ȡͼƬ
            
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
picid = CheckStinum(numi);
Bigword = double('��');
Smallword = double('С');
DrawFormattedText(w1,double(['����Ϊ��ͼ�еĵ�����',num2str(picid),'�Ĺ�ϵ']),xCenter-300 ,yCenter+8.5*font_size-200, black,[],[],[],2);  %xCenter+470 ,yCenter+8.5*font_size-300
DrawFormattedText(w1,Bigword,xCenter-200 ,yCenter+8.5*font_size-100, 1, [],[],[],2);
DrawFormattedText(w1,Smallword,xCenter-100 ,yCenter+8.5*font_size-100, 1, [],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);