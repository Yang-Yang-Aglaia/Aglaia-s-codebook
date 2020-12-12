%% general setting
% �ͻ��˴���
clc;
clear allq
AssertOpenGL;
Screen('Preference','SkipSyncTests',1);
Screen('Preference','TextRenderer',1);
Screen('Preference','TextEncodingLocale','UTF8')
KbName('UnifyKeyNames');

%% getting participant information
subID = '0';
Gender = '1';
Name = '';
Version = '4';
promptParameters = {'Subject ID' 'Gender' 'Name' 'Version'};
defaultParameters = {subID,Gender,Name,Version};
Settings = inputdlg(promptParameters, 'Settings', 1,  defaultParameters);
pause(0.5);
subID = Settings{1};
subNo = str2double(subID);
gender = str2double(Settings{2});
name = Settings{3};
version = str2double(Settings{4});

Notes = 'Please enter host IPs'%%%%����client��IP��ַ
IP1 = '192.168.88.3';  %����3��IP
IPs={'Notes','IP1'};
defaultParameters = {Notes,IP1};
IPs=inputdlg(IPs,'IPs',1,defaultParameters);
IP1 = IPs{2};

%���������������ļ����
folder_path = cd;
savename = 'data_individual_decision';
if ~isdir(fullfile(folder_path,'data_individual_decision'))
    mkdir(fullfile(folder_path,'data_individual_decision'));
end
outputfile = fullfile(folder_path,'data_individual_decision',[savename '_s' subID '.txt']);

%����Ƿ������Ѿ����ڵı��Ա�ţ���ֹ���ݸ�д
if fopen(outputfile, 'rt')~=-1
    fclose('all');
    %     error('Result data file already exists! Choose a different subject number.');
    
    replace = str2double(inputdlg({'Do you want to replace the exist file? Yes-1 No-2'},'Replace?')); % replace or not
    if replace(1) == 1
        fp = fopen(outputfile,'wt');
        %fp2 = fopen(outputfile2,'wt');
    end
else
    fp = fopen(outputfile,'wt'); % open ASCII file for writing
    %fp2 = fopen(outputfile2,'wt'); % open ASCII file for writing
end


fprintf(fp,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n',...
    'subNo','gender','name','TrialNum','position_chose','chose_RT','confidence_rating','confidence_rating_RT','earnings','losses','net_income','total_score','chose_performance','group_decision','group_performance','position_chose_total_1','position_chose_total_2','position_chose_total_3','position_chose_total_4','NumA','NumB','NumC','NumD','Version');
%fprintf(fp,'%s\n',...
%    'subNo');

%% Screen Setting
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
[w1,wRect] = Screen('OpenWindow',scnNo,gray,[0 0 600 600]); %,,[0 0 1366 600]
%w1=Screen('OpenWindow',scnNo,black,[0 0 1366 768]);


ifi1 = Screen('GetFlipInterval', w1);

%������Ļ��ʾ�������С���������ͣ��Լ����������
Screen('TextSize', w1, 40);
font_size =30;
Screen('TextFont',w1,'Simsun');
Screen('TextStyle', w1, 1); %0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend


[wide_x, high_y] = Screen('WindowSize',w1);% ������w1��w2����Ļ��С��һ���ģ�����ֻ��Ҫ����һ�ξͿ�����
xCenter = wide_x/2;
yCenter = high_y/2;

Screen('BlendFunction', w1, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%% material prepare
folder_path = cd;
cue_dir = fullfile(folder_path,'Picture_group');
if ~isdir(cue_dir)
    error('There is no stimuli image directory');
end

% ȷ��ѡ��ʱ��������ʾ
%belt = fullfile(folder_path,'stimuli_response');
% belt_pic = imread(fullfile(cue_dir,'belt.jpg'));
% belt_figure = Screen('MakeTexture',w1,belt_pic);

triangle_pic = imread(fullfile(cue_dir,'triangle.png'));
triangle = Screen('MakeTexture',w1,triangle_pic);
SCALE_GL_pic = imread(fullfile(cue_dir,'SCALE_GL.png'));
SCALE_GL = Screen('MakeTexture',w1,SCALE_GL_pic);



%each card have two number, one is earning (matrix 1) and one is lose(matrix 2);
%in each matrix, the first row means deck_1;the second row means deck_2;
%the third row means deck_3;the fourth row means deck_4;


%%
%����ʵ���һ���ֵİ���
more = KbName('q');  % ���ڵ��Ը�������
less = KbName('p'); % ���ڵ��Ը�������
rateless = KbName('f'); %ѡ��ڶ���belt
ratemore = KbName('j'); %ѡ�������belt


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
%%
%%%����������������
DrawFormattedText(w1,double('���������У����Ժ� >>>'),'center','center',1, [],[],[],2);
Screen('Flip', w1);
WaitSecs(2);

u1=udp(IP1,'RemotePort',8811,'LocalPort',9090,'Timeout',90);%���ó��ڶ˿ں�Ϊ8811��8822��8888��8899ע����䲻Ҫ�ظ�
u1.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ

fopen(u1);%��udp���ӣ�ʵ���ϲ�û�����ӣ�udp�������ӵ�ͨ��Э�飩

CheckConnection1 = 0;
CheckConnection2 = 0;
CheckConnection3 = 0;
CheckConnection4 = 0;
CheckConnection=[CheckConnection1,CheckConnection2,CheckConnection3,CheckConnection4];  %
%%%%�������ӵ���
Check_onset = GetSecs;
while sum(CheckConnection)<4 %4
    fwrite(u1,1);
    
    CheckConnection=fread(u1,4);
    
    if sum(CheckConnection) == 4 %4
        break
    end
    
    Check_RT = GetSecs - Check_onset;
    if Check_RT>60
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        error('connection timeout!');
    end
end

DrawFormattedText(w1,double('��ϲ�����ӳɹ���'),'center','center',1, [],[],[],2);
Screen('Flip',w1,[]);
WaitSecs(2);
%% Experimental Process
% instruction
InstructionText = double('ʵ�鼴����ʼ\n���������жϺ󰴼�������Ӧ\n�밴 Q ����ʼʵ��');
Screen(w1, 'TextSize', 30);
DrawFormattedText(w1,InstructionText,'center','center', 1, [],[],[],2);
Screen('Flip',w1);

start_yes = 0;
%RestrictKeysForKbCheck([start_roleM start_roleN escape_roleM escape_roleN]);
[KeyIsDown, tempt, KeyCode] = KbCheck;
while start_yes == 0
    [KeyIsDown, tempt, KeyCode] = KbCheck;
    if KeyCode(start_action)
        Screen('Flip',w1);
        start_yes = 1;
    elseif KeyCode(escape_action)
        %Priority(0);
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        error('experiment aborted by user');
    end
    if start_yes == 1;
        break;
    end
end
WaitSecs(1.5);
%RestrictKeysForKbCheck([]);
KeyIsDown = 0;

%start_time = GetSecs; % program start time


trial_rep = 2;  %�ظ�����
num=0;
% this total_score means a starting value and will be updated as the game
% goes on.
iid = randperm(5,5);
% numMore = 0;  %���ɻ�����
% numLess = 0;
% this total_score means a starting value and will be updated as the game
% goes on.
for i = 1:5
    numi = iid(i);
    num = [18,19,20,21,22];
    for triali = 1:trial_rep  %%�ǵ������Ҫupdate
        for stimi = 1:42  %�̼�id
            num = num + 1;
            TrialNum = num;
            chose_onset = GetSecs;    %������ʼʱ��
            
            %% ���Կ�������Ϣ
            % fixation point��ֱ�ӻ���
            fixation = double('+');
            Screen(w1, 'TextSize', 30);
            DrawFormattedText(w1,fixation,'center','center', 1, [],[],[],2);
            Screen('Flip',w1);
            %             Screen('DrawDots', w1, [x_center; y_center], 10, [255,255,255], [], 1);
            %             Screen('Flip',w1);
            %             WaitSecs(cell2mat(data(trial, 5)));
            
            % present stimulus
            pngs = dir('D:\Yangyang\Exp_procedure\Picture_group\*.png');  %��ȡ�ļ����������ļ�
            picname = randperm(42,42); %���ظ������������
            filename = pngs(picname(stimi)).name;  %�õ�ͼƬ������
            S = regexp(filename, '_', 'split');  %�ָ������
            picnum = str2num(char(S(1)));  %�ַ����������,��Ҫ���
            dot_pic = imread(fullfile(cue_dir,filename)); %��ȡͼƬ
            belt_figure = Screen('MakeTexture',w1,dot_pic);  %д��ͼƬ
            Screen('DrawTexture',w1, belt_figure);
            WaitSecs(1.5);  %����ʱ��
            Screen('Flip',w1);  %����
            
            % action 1�����������ѡȡ�ģ���Ҫ���ֳ�����
            % Screen('FrameRect', w1, black, [xCenter+425 yCenter-15 xCenter+63 yCenter+150],[1]);%����Ҫ��
            picid = num(numi);
            Bigword = double('��');
            Smallword = double('С');
            DrawFormattedText(w1,double(['����Ϊ��ͼ�еĵ�����',num2str(picid),'�Ĺ�ϵ']),xCenter-300 ,yCenter+8.5*font_size-200, black,[],[],[],2);  %xCenter+470 ,yCenter+8.5*font_size-300
            DrawFormattedText(w1,Bigword,xCenter-200 ,yCenter+8.5*font_size-100, 1, [],[],[],2);
            DrawFormattedText(w1,Smallword,xCenter-100 ,yCenter+8.5*font_size-100, 1, [],[],[],2);
            Screen(w1, 'TextSize', 30);
            Screen('Flip',w1);
            [KeyIsDown,secs,KeyCode] = KbCheck;
            KeyA = 0;
            
            subIDe=Shuffle([1 2]); %�����������ֵ��Ǹ��
            if     subIDe(1) == 1 %%%������ʼֵ�ж�
                x1 = xCenter-235;
            else
                x1 = xCenter+220;
            end
            
            %��������
            while 1    %&& ((GetSecs - confidence_pre_onset)<10)
                
                [KeyIsDown,secs,KeyCode] = KbCheck;
                ratingkey=0;
                
                if KeyCode(more)  %ѡ��more
                    KeyA =1;
                    %KeyDown = 1;
                    chose_RT = secs - chose_onset;
                    DeckCheck=0;
                    position_chose = 1; % 1 means more;
                    %ѡ�����
                    Screen('FrameRect', w1, red, frame_left_left, [6]);
                    Screen('Flip',w1,[],0);
                    WaitSecs(1);
                    
                    %%%%%%%% present confidence rating controlled by keyboard %%%%%%
                    
                    confidence_pre_onset=GetSecs;  %��ʼʱ��
                    while ratingkey ==0 %���ְ���
                        RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);  %������������
                        [KeyIsDown,secs,KeyCode] = KbCheck;
                        ConfidenceText = double('��Ը�ѡ������ĳ̶�');
                        DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                        %Screen('Flip',w1);
                        %��ȡ�̼��ļ������ͼƬ
                        GRect=Screen('Rect',triangle);
                        Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) %������
                        pRect = Screen('Rect',SCALE_GL);
                        Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]); %���
                        Screen('Flip', w1,[],0);
                        
                        [KeyIsDown,secs,KeyCode] = KbCheck;
                        KeyNum = find(KeyCode);  %̽�ⰴ��,keycode��ɨ����
                        rank = size(KeyNum);  %�ó�������
                        
                        if KeyCode(rateless)
                            if x1 + move_left < xCenter-235  %λ���ƶ�
                                x1 = x1;
                            else
                                x1 = x1 + move_left;
                            end
                            DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                            Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) ;
                            pRect=Screen('Rect',SCALE_GL);
                            Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                            Screen('Flip', w1);
                            WaitSecs(0.15);
                        elseif KeyCode(ratemore)
                            if x1 + move_right > xCenter+220
                                x1 = x1;
                            else
                                x1 = x1 + move_right;
                            end
                            
                            DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                            Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]);
                            pRect=Screen('Rect',SCALE_GL);
                            Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                            Screen('Flip', w1);
                            WaitSecs(0.15);
                            
                            
                        elseif KeyCode(stop_rating)
                            RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                            ratingkey = 1;
                            %confidence_response = ((x1-xCenter+235)/455)*100;
                            confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                            confidence_rating_RT = GetSecs - confidence_pre_onset;
                            
                        elseif KeyCode(escape_action)
                            %Priority(0);
                            Screen('CloseAll');
                            ShowCursor;
                            fclose('all');
                            error('experiment aborted by user');
                            
                        end
                    end
                    %%%% ���������˵ľ��� %%%%
                    %��Ҫ̽�������˵İ�����Ȼ����Щ�����ַ���Ϊ���
                    % ÿ��followerֻ��leader��ѡ��
                    raw_chose1=fread(u1,1); %��ȡ�������尴�������������ip�ж�
                    DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                    DrawFormattedText(w1,double(['A:',num2str(raw_chose1)]),xCenter-130,yCenter+8.5*font_size-490, black,[],[],[],2);  %λ�ñ仯
                    %DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
                    Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
                    Screen('Flip',w1,[]);
                    
                elseif KeyCode(less)
                    KeyA =1;
                    %KeyDown = 1;
                    chose_RT = secs - chose_onset;
                    DeckCheck=0;
                    position_chose = 2; % 1 means deck_A, 2 means deck_B, 3 means deck_C, 4 means deck_D;
                    %ѡ�����
                    Screen('FrameRect', w1, red, frame_left_left, [6]);
                    Screen('Flip',w1,[],0);
                    WaitSecs(1);
                    
                    %%%%%%%% present confidence rating controlled by keyboard %%%%%%
                    
                    
                    confidence_pre_onset=GetSecs;
                    while ratingkey ==0
                        RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                        [KeyIsDown,secs,KeyCode] = KbCheck;
                        ConfidenceText = double('��Ը�ѡ������ĳ̶�');
                        DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2); %λ��
                        
                        %��ȡ�ļ����е�ͼƬ
                        GRect=Screen('Rect',triangle);
                        Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20])
                        pRect = Screen('Rect',SCALE_GL);
                        Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                        Screen('Flip', w1,[],0);
                        
                        %̽�ⰴ��
                        [KeyIsDown,secs,KeyCode] = KbCheck;
                        KeyNum = find(KeyCode);
                        rank = size(KeyNum);
                        
                        if KeyCode(rateless)
                            if x1 + move_left < xCenter-235
                                x1 = x1;
                            else
                                x1 = x1 + move_left;
                            end
                            DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                            Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) ;
                            pRect=Screen('Rect',SCALE_GL);
                            Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                            Screen('Flip', w1);
                            WaitSecs(0.15);
                        elseif KeyCode(ratemore)
                            if x1 + move_right > xCenter+220
                                x1 = x1;
                            else
                                x1 = x1 + move_right;
                            end
                            
                            DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                            Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]);
                            pRect=Screen('Rect',SCALE_GL);
                            Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                            Screen('Flip', w1);
                            WaitSecs(0.15);
                            
                            
                        elseif KeyCode(stop_rating)
                            RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                            ratingkey = 1;
                            %confidence_response = ((x1-xCenter+235)/455)*100;
                            confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                            confidence_rating_RT = GetSecs - confidence_pre_onset;
                            
                        elseif KeyCode(escape_action)
                            %Priority(0);
                            Screen('CloseAll');
                            ShowCursor;
                            fclose('all');
                            error('experiment aborted by user');
                            
                        end
                    end
                    
                    %%%% gains and losses feedback %%%%
                    raw_chose1=fread(u1,1); %��ȡ�������尴�������������ip�ж�
                    DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                    DrawFormattedText(w1,double(['A:',num2str(raw_chose1)]),xCenter-130,yCenter+8.5*font_size-490, black,[],[],[],2);  %λ�ñ仯
                    Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
                    Screen('Flip',w1,[]);
                    
                end
                
                if KeyA==1&&DeckCheck==0
                    %%%% transfer data process %%%%
                    %% 4�����Ե�ѡ�񣨵�һ�η�����
                    % leader��ѡ��
                    raw_chose1 = 0;
                    position_chose_total_1 = 0;
                    chose_sum = position_chose_total_1;  %,position_chose_total_2,position_chose_total_3,position_chose_total_4
                    
                    % �����Ҫ��Ϊ�е��˻ᷴӦ�Ͽ�
                    DrawFormattedText(w1,double('�������ѡ����ȴ�������� >>>'),'center','center', 1,[],[],[],2);
                    Screen('Flip',w1,[]);
                    
                    %CheckConnection=fread(u1,8);
                    
                    %��ȡleader�ķ�������һ�η���
                    raw_chose_leader=fread(u1,1);  %Read binary data�����������ݣ� from file
                    matrix_chose = [position_chose,raw_chose_leader];  %, raw_chose1,raw_chose2, raw_chose3, raw_chose4
                    position_chose_total_leader = length(find(matrix_chose == 1));
                    chose_sum = position_chose_total_leader;  %,position_chose_total_2,position_chose_total_3,position_chose_total_4
                    
                    if KeyCode(escape_action)
                        %Priority(0);
                        break
                        Screen('CloseAll');
                        ShowCursor;
                        fclose('all');
                        error('experiment aborted by user');
                    end
                    
                    
                    fwrite(u1,[chose_sum]);  %Write binary data to file
                    
                    %%%% gains and losses feedback %%%%
                    decision_check=1;
                    while decision_check==1
                        if position_chose_total_leader > 0 %%%�жϵ�����ѡ���ʱ�����ѡ����Ŀ,����ѡ���򲻵������֣�
                            DrawFormattedText(w1,double(num2str(position_chose_total_leader)),xCenter-600,yCenter+8.5*font_size-500, black,[],[],[],2);
                            WaitSecs(1.5);
                            Screen('Flip', w1);
                        end
                        
                        %% �Ƿ����ѡ��
                        yesword = double('��');
                        noword = double('��');
                        DrawFormattedText(w1,double('���Ƿ�����Լ��ľ���'),'Center',yCenter+250,1,[],[],[],2);
                        DrawFormattedText(w1,yesword,xCenter-200,yCenter+300,1,[],[],[],2);
                        DrawFormattedText(w1,noword,xCenter-100,yCenter+300,1,[],[],[],2);
                        Screen(w1, 'TextSize', 30);
                        Screen('Flip',w1);
                        [KeyIsDown,secs,KeyCode] = KbCheck;
                        KeyA = 0;
                        
                        
                        if KeyCode(more)  %ѡ��more
                            KeyA =1;
                            %KeyDown = 1;
                            chose_RT = secs - chose_onset;
                            DeckCheck=0;
                            position_chose = 1; % 1 means more;
                            %ѡ�����
                            Screen('FrameRect', w1, red, frame_left_left, [6]);
                            Screen('Flip',w1,[],0);
                            WaitSecs(1);
                            
                            %%%%%%%% present confidence rating controlled by keyboard %%%%%%
                            
                            confidence_pre_onset=GetSecs;  %��ʼʱ��
                            while ratingkey ==0 %���ְ���
                                RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);  %������������
                                [KeyIsDown,secs,KeyCode] = KbCheck;
                                ConfidenceText = double('��Ը�ѡ������ĳ̶�');
                                DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                %Screen('Flip',w1);
                                %��ȡ�̼��ļ������ͼƬ
                                GRect=Screen('Rect',triangle);
                                Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) %������
                                pRect = Screen('Rect',SCALE_GL);
                                Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]); %���
                                Screen('Flip', w1,[],0);
                                
                                [KeyIsDown,secs,KeyCode] = KbCheck;
                                KeyNum = find(KeyCode);  %̽�ⰴ��,keycode��ɨ����
                                rank = size(KeyNum);  %�ó�������
                                
                                if KeyCode(rateless)
                                    if x1 + move_left < xCenter-235  %λ���ƶ�
                                        x1 = x1;
                                    else
                                        x1 = x1 + move_left;
                                    end
                                    DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                    Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) ;
                                    pRect=Screen('Rect',SCALE_GL);
                                    Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                    Screen('Flip', w1);
                                    WaitSecs(0.15);
                                elseif KeyCode(ratemore)
                                    if x1 + move_right > xCenter+220
                                        x1 = x1;
                                    else
                                        x1 = x1 + move_right;
                                    end
                                    
                                    DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                    Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]);
                                    pRect=Screen('Rect',SCALE_GL);
                                    Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                    Screen('Flip', w1);
                                    WaitSecs(0.15);
                                    
                                    
                                elseif KeyCode(stop_rating)
                                    RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                                    ratingkey = 1;
                                    %confidence_response = ((x1-xCenter+235)/455)*100;
                                    confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                                    confidence_rating_RT = GetSecs - confidence_pre_onset;
                                    
                                elseif KeyCode(escape_action)
                                    %Priority(0);
                                    Screen('CloseAll');
                                    ShowCursor;
                                    fclose('all');
                                    error('experiment aborted by user');
                                    
                                end
                            end
                            %%%% ���������˵ľ��� %%%%
                            %��Ҫ̽�������˵İ�����Ȼ����Щ�����ַ���Ϊ���
                            % ÿ��followerֻ��leader��ѡ��
                            raw_chose1=fread(u1,1); %��ȡ�������尴�������������ip�ж�
                            DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                            DrawFormattedText(w1,double(['A:',num2str(raw_chose1)]),xCenter-130,yCenter+8.5*font_size-490, black,[],[],[],2);  %λ�ñ仯
                            %DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
                            Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
                            Screen('Flip',w1,[]);
                            
                        elseif KeyCode(less)
                            KeyA =1;
                            %KeyDown = 1;
                            chose_RT = secs - chose_onset;
                            DeckCheck=0;
                            position_chose = 2; % 1 means deck_A, 2 means deck_B, 3 means deck_C, 4 means deck_D;
                            %ѡ�����
                            Screen('FrameRect', w1, red, frame_left_left, [6]);
                            Screen('Flip',w1,[],0);
                            WaitSecs(1);
                            
                            %%%%%%%% present confidence rating controlled by keyboard %%%%%%
                            
                            
                            confidence_pre_onset=GetSecs;
                            while ratingkey ==0
                                RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                                [KeyIsDown,secs,KeyCode] = KbCheck;
                                ConfidenceText = double('��Ը�ѡ������ĳ̶�');
                                DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2); %λ��
                                
                                %��ȡ�ļ����е�ͼƬ
                                GRect=Screen('Rect',triangle);
                                Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20])
                                pRect = Screen('Rect',SCALE_GL);
                                Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                Screen('Flip', w1,[],0);
                                
                                %̽�ⰴ��
                                [KeyIsDown,secs,KeyCode] = KbCheck;
                                KeyNum = find(KeyCode);
                                rank = size(KeyNum);
                                
                                if KeyCode(rateless)
                                    if x1 + move_left < xCenter-235
                                        x1 = x1;
                                    else
                                        x1 = x1 + move_left;
                                    end
                                    DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                    Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) ;
                                    pRect=Screen('Rect',SCALE_GL);
                                    Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                    Screen('Flip', w1);
                                    WaitSecs(0.15);
                                elseif KeyCode(ratemore)
                                    if x1 + move_right > xCenter+220
                                        x1 = x1;
                                    else
                                        x1 = x1 + move_right;
                                    end
                                    
                                    DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                    Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]);
                                    pRect=Screen('Rect',SCALE_GL);
                                    Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                    Screen('Flip', w1);
                                    WaitSecs(0.15);
                                    
                                    
                                elseif KeyCode(stop_rating)
                                    RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                                    ratingkey = 1;
                                    %confidence_response = ((x1-xCenter+235)/455)*100;
                                    confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                                    confidence_rating_RT = GetSecs - confidence_pre_onset;
                                    
                                elseif KeyCode(escape_action)
                                    %Priority(0);
                                    Screen('CloseAll');
                                    ShowCursor;
                                    fclose('all');
                                    error('experiment aborted by user');
                                    
                                end
                            end
                            
                            %%%% gains and losses feedback %%%%
                            raw_chose1=fread(u1,1); %��ȡ�������尴�������������ip�ж�
                            DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                            DrawFormattedText(w1,double(['A:',num2str(raw_chose1)]),xCenter-130,yCenter+8.5*font_size-490, black,[],[],[],2);  %λ�ñ仯
                            Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
                            Screen('Flip',w1,[]);
                            
                        end
                        
                        %% ���ĺ���
                        raw_chose_leader=fread(u1,1);  %Read binary data�����������ݣ� from file
                        matrix_chose = [position_chose,raw_chose_leader, raw_chose1,raw_chose2, raw_chose3, raw_chose4];  %
                        position_chose_total_leader = length(find(matrix_chose == 1));
                        chose_sum = [position_chose_total_leader,position_chose_total_2,position_chose_total_3,position_chose_total_4];  %
                        
                        if KeyCode(escape_action)
                            %Priority(0);
                            break
                            Screen('CloseAll');
                            ShowCursor;
                            fclose('all');
                            error('experiment aborted by user');
                        end
                        
                        
                        fwrite(u1,[chose_sum]);  %Write binary data to file
                        
                        %%%% gains and losses feedback %%%%
                        decision_check=1;
                        while decision_check==1
                            if position_chose_total_leader > 0 %%%�жϵ�����ѡ���ʱ�����ѡ����Ŀ,����ѡ���򲻵������֣�
                                DrawFormattedText(w1,double(num2str(position_chose_total_leader)),xCenter-600,yCenter+8.5*font_size-500, black,[],[],[],2);
                                WaitSecs(1.5);
                                Screen('Flip', w1);
                            end
                            
                            DrawFormattedText(w1,double('��ȴ����վ���'),'Center',yCenter+250,1,[],[],[],2)
                            WaitSecs(1.5);
                            Screen('Flip', w1);
                            
                            %% ����Ⱥ��ѡ��
                            raw_chose_leader=fread(u1,1);  %Read binary data�����������ݣ� from file
                            matrix_chose = [position_chose,raw_chose_leader, raw_chose1,raw_chose2, raw_chose3, raw_chose4];  %
                            position_chose_total_leader = length(find(matrix_chose == 1));
                            chose_sum = [position_chose_total_leader,position_chose_total_2,position_chose_total_3,position_chose_total_4];  %
                            
                            if KeyCode(escape_action)
                                %Priority(0);
                                break
                                Screen('CloseAll');
                                ShowCursor;
                                fclose('all');
                                error('experiment aborted by user');
                            end
                            
                            
                            fwrite(u1,[chose_sum]);  %Write binary data to file
                            
                            %%%% gains and losses feedback %%%%
                            decision_check=1;
                            while decision_check==1
                                if position_chose_total_leader > 0 %%%�жϵ�����ѡ���ʱ�����ѡ����Ŀ,����ѡ���򲻵������֣�
                                    DrawFormattedText(w1,double(num2str(position_chose_total_leader)),xCenter-600,yCenter+8.5*font_size-500, black,[],[],[],2);
                                    WaitSecs(1.5);
                                    Screen('Flip', w1);
                                end
                                
                                %                             KeyA=0;
                                %                             while 1    %&& ((GetSecs - confidence_pre_onset)<10)
                                %
                                %                                 [KeyIsDown,secs,KeyCode] = KbCheck;
                                %                                 ratingkey=0;
                                %                                 chose_onset=GetSecs;
                                %
                                %                                 if KeyCode(more)
                                %                                     KeyA =1;
                                %                                     %KeyDown = 1;
                                %                                     decision_RT = GetSecs - chose_onset;
                                %                                     decision_check=0;
                                %                                     group_decision = 1; % 1 means deck_A, 2 means deck_B, 3 means deck_C, 4 means deck_D;
                                %
                                %
                                %                                     %%%%%%%% present confidence rating controlled by keyboard %%%%%%
                                %                                     confidence_pre_onset=GetSecs;
                                %                                     while ratingkey ==0
                                %                                         RestrictKeysForKbCheck([more less stop_rating escape_action]);
                                %                                         [KeyIsDown,secs,KeyCode] = KbCheck;
                                %                                         ConfidenceText = double('��Ը�ѡ������ĳ̶�');
                                %                                         DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                %
                                %                                         GRect=Screen('Rect',triangle);
                                %                                         Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20])
                                %                                         pRect = Screen('Rect',SCALE_GL);
                                %                                         Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                %                                         Screen('Flip', w1,[],0);
                                %
                                %                                         [KeyIsDown,secs,KeyCode] = KbCheck;
                                %                                         KeyNum = find(KeyCode);
                                %                                         rank = size(KeyNum);
                                %
                                %                                         if KeyCode(less)
                                %                                             if x1 + move_left < xCenter-235
                                %                                                 x1 = x1;
                                %                                             else
                                %                                                 x1 = x1 + move_left;
                                %                                             end
                                %                                             DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                %                                             Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) ;
                                %                                             pRect=Screen('Rect',SCALE_GL);
                                %                                             Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                %                                             Screen('Flip', w1);
                                %                                             WaitSecs(0.15);
                                %
                                %
                                %                                         elseif KeyCode(stop_rating)
                                %                                             RestrictKeysForKbCheck([more less stop_rating escape_action]);
                                %                                             ratingkey = 1;
                                %                                             %confidence_response = ((x1-xCenter+235)/455)*100;
                                %                                             decision_confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                                %                                             decision_confidence_rating_RT = GetSecs - confidence_pre_onset;
                                %
                                %                                         elseif KeyCode(escape_action)
                                %                                             %Priority(0);
                                %                                             Screen('CloseAll');
                                %                                             ShowCursor;
                                %                                             fclose('all');
                                %                                             error('experiment aborted by user');
                                %
                                %                                         end
                                %                                     end
                                %
                                %                                 elseif KeyCode(less)
                                %                                     KeyA =1;
                                %                                     %KeyDown = 1;
                                %                                     decision_RT = GetSecs - chose_onset;
                                %                                     decision_check=0;
                                %                                     group_decision = 2; % 1 means more, 2 means less
                                %
                                %
                                %                                     confidence_pre_onset=GetSecs;
                                %                                     while ratingkey ==0
                                %                                         RestrictKeysForKbCheck([more less stop_rating escape_action]);
                                %                                         [KeyIsDown,secs,KeyCode] = KbCheck;
                                %                                         ConfidenceText = double('��Ը�ѡ������ĳ̶�');
                                %                                         DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                %
                                %                                         GRect=Screen('Rect',triangle);
                                %                                         Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20])
                                %                                         pRect = Screen('Rect',SCALE_GL);
                                %                                         Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                %                                         Screen('Flip', w1,[],0);
                                %
                                %                                         [KeyIsDown,secs,KeyCode] = KbCheck;
                                %                                         KeyNum = find(KeyCode);
                                %                                         rank = size(KeyNum);
                                %
                                %                                         if KeyCode(less)
                                %                                             if x1 + move_left < xCenter-235
                                %                                                 x1 = x1;
                                %                                             else
                                %                                                 x1 = x1 + move_left;
                                %                                             end
                                %                                             DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                                %                                             Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) ;
                                %                                             pRect=Screen('Rect',SCALE_GL);
                                %                                             Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                                %                                             Screen('Flip', w1);
                                %                                             WaitSecs(0.15);
                                %
                                %
                                %                                         elseif KeyCode(stop_rating)
                                %                                             RestrictKeysForKbCheck([deck_A deck_B deck_C deck_D stop_rating escape_action]);
                                %                                             ratingkey = 1;
                                %                                             %confidence_response = ((x1-xCenter+235)/455)*100;
                                %                                             decision_confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                                %                                             decision_confidence_rating_RT = GetSecs - confidence_pre_onset;
                                %
                                %                                         elseif KeyCode(escape_action)
                                %                                             %Priority(0);
                                %                                             Screen('CloseAll');
                                %                                             ShowCursor;
                                %                                             fclose('all');
                                %                                             error('experiment aborted by user');
                                %
                                %                                         end
                                %                                     end
                                %
                                %                                     if KeyCode(escape_action)
                                %                                         Screen('CloseAll');
                                %                                         ShowCursor;
                                %                                         fclose('all');
                                %                                         error('experiment aborted by user');
                                %                                     end
                                %
                                %                                     if KeyA  == 1
                                %                                         break
                                %                                     end
                                %                                 end
                                %
                                %                                 if decision_check==0
                                %                                     break
                                %                                 end
                                %                             end
                                %
                                %                             fwrite(u1,group_decision);
                                %                             %                         fwrite(u2,group_decision);
                                %                             %                         fwrite(u3,group_decision);
                                %                             %                         fwrite(u4,group_decision);
                                %
                                %
                                %                             if   group_decision == 1
                                %                                 %earnings = matrix_1(group_decision,NumA);
                                %                                 %losses = matrix_2(group_decision,NumA);
                                %                                 %net_income = earnings + losses;
                                %                                 %total_score = total_score + net_income;
                                %                                 group_performance = matrix_3(a, group_decision); %matrix_3ָ������������
                                %                                 DrawFormattedText(w1,double('�ܽ��:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                                %                                 DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
                                %                                 Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
                                %
                                %
                                %
                                %                             elseif group_decision == 2
                                %                                 earnings = matrix_1(group_decision,NumB);
                                %                                 losses = matrix_2(group_decision,NumB);
                                %                                 net_income = earnings + losses;
                                %                                 total_score = total_score + net_income;
                                %                                 group_performance = matrix_3(a, group_decision);
                                %
                                %                                 DrawFormattedText(w1,double('�ܽ��:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                                %                                 DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
                                %                             end
                            end
                        end
                        
                        
                        if KeyA  == 1
                            break
                        end
                        if KeyCode(escape_action)
                            Screen('CloseAll');
                            ShowCursor;
                            fclose('all');
                            error('experiment aborted by user');
                        end
                    end
                    KeyIsDown = 0;
                    
                    %  fprintf(fp,'%s\n',...
                    % 'subNo');
                    if DeckCheck==0
                        fprintf(fp,'%d\t%d\t%s\t%d\t%d\t%f\t%d\t%f\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%f\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',...
                            subNo,gender,name,TrialNum,position_chose,chose_RT,confidence_rating,confidence_rating_RT,earnings,losses,net_income,total_score,chose_performance,group_decision,decision_RT,decision_confidence_rating,decision_confidence_rating_RT,group_performance,position_chose_total_1,position_chose_total_2,position_chose_total_3,position_chose_total_4,NumA,NumB,NumC,NumD,Version);
                    end
                    if num==100
                        break
                    end
                end
            end
        end
    end
end


%%
fclose(u1);
% fclose(u2);
% fclose(u3);
% fclose(u4);
message = 'ʵ�����������д�ʾ�';
DrawFormattedText(w1,double(message),'center','center', 1,[],[],[],2);
%DrawFormattedText(w2,double(message),'center','center', 1,[],[],[],2);
endt = Screen('Flip', w1);
% endt = Screen('Flip', w2);``
WaitSecs(5);
% Cleanup at end of experiment - Close window, show mouse cursor, close
% result file, switch Matlab/Octave back to priority 0 -- normal
% priority:
Screen('CloseAll');
ShowCursor;
fclose('all');
%Priority(0);

return;

