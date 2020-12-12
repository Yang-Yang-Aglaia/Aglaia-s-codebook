%% general setting
% server���룬�ռ�����4�����źţ��������Ƿ���
clc;
clear all;
try
    AssertOpenGL;
    Screen('Preference','SkipSyncTests',1);  %ǿ��ͬ����
    Screen('Preference','TextRenderer',1);
    Screen('Preference','TextEncodingLocale','UTF8');
    KbName('UnifyKeyNames');
    
    [subNo,group,gender,name,version,hand,age,IP2,IP3,IP4,IP5,fp] = ParticipantInformation; %׼��������Ϣ
    [w1,wRect,xCenter,yCenter,font_size,black,gray,red] = ScreenPrepare; %׼����Ļ
    [triangle,SCALE_GL,more,less,rateless,ratemore,stop_rating,start_action,escape_action,move_left,...
        move_right,frame_left_left,frame_left_right,frame_right_left,frame_right_right,cue_dir,Checkcue_dir] = MaterialsPre(w1,xCenter,yCenter); %׼���̼�
    %[u1,u2,u3,u4,CheckConnectionOne,CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41] = ConnectionsOne(w1,IP2,IP3,IP4,IP5);  %�������
    
    %% Experimental Process
    %���ִ̼�
    trial_rep = 2;  %�ظ�����
    num=0;
    % this total_score means a starting value and will be updated as the game
    % goes on.
    stinum = [18,20,22]; %19,21,
    iid = randperm(3,3);
    iidprac = randperm(5,5);
    numMore = 0;  %���ɻ�����
    numLess = 0;
    DeckCheck=0;
    trials = 0;
    Inicheck = 0;
    ComNum = [];
    StimNum = [];
    practice = 0;
    ConCheck = 0;
    %StimSeq = randi([0, 1], 1, 6);
    for  triali = 1 %:trial_rep
        for  stimi = 1:42  %:42 %%�ǵ������Ҫupdate
            for  i = 1:3  %:5 %�̼�id
                %% ���Կ�������Ϣ
                while ConCheck == 0
                    [u1,u2,u3,u4,CheckConnectionOne,CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41] = ConnectionsOne(w1,IP2,IP3,IP4,IP5);  %�������
                    Instruction(w1,start_action,escape_action); %ָ����
                    ConCheck = 1;
                    if ConCheck ==1
                        break
                    end
                end
                %���ִ̼�
                while Inicheck == 0
                    InstructionText = double('�������5����ϰ�ԴΣ���Ϥ�������ٽ�����ʽʵ�飡');
                    Screen(w1, 'TextSize', 30);
                    DrawFormattedText(w1,InstructionText,'center','center', 1, [],[],[],2);
                    Screen('Flip',w1);
                    for ii = 1:trial_rep
                        for checki = 1:5
                            CheckStinum = [22,23,24,25,26];
                            [chose_onset]=CheckStimDisplay(CheckStinum,iidprac,checki,w1,Checkcue_dir,xCenter,yCenter,font_size,black);
                            [chose_RT,position_chose,confidence_rating,confidence_rating_RT,raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41] = KeyBoard1DC(w1,more,rateless,ratemore,stop_rating,escape_action,less,xCenter,...
                                yCenter,move_left,move_right,chose_onset,red,frame_left_left,GetSecs,triangle,SCALE_GL,u1,u2,u3,u4,font_size,black);
                            %[raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41]=FeedbackOne(w1,u1,u2,u3,u4,xCenter,yCenter,font_size,black); %�ȴ����˵�һ��ѡ����
                            
                            % д�����ˣ���һ�Σ�
                            Chposition_chose = position_chose;
                            fwrite(u1,Chposition_chose);
                            fwrite(u2,Chposition_chose);
                            fwrite(u3,Chposition_chose);
                            fwrite(u4,Chposition_chose);
                        end
                    end
                    Inicheck = 1;
                    if Inicheck == 1
                        break
                    end
                end
%                 fclose(u1);
%                 fclose(u2);
%                 fclose(u3);
%                 fclose(u4);
%                 [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectTwo(u1,u2,u3,u4);
                while practice == 0
%                     checkj1 = fread(u1,1);
%                     checkj2 = fread(u2,1);
%                     checkj3 = fread(u3,1);
%                     checkj4 = fread(u4,1);
%                     fwrite(u1,checki);
%                     fwrite(u2,checki);
%                     fwrite(u3,checki);
%                     fwrite(u4,checki);
%                     if checkj1 == 5 && checkj2 == 5 && checkj3 == 5 && checkj4 == 5
%                     %�ڶ�������
%                         fclose(u1);
%                         fclose(u2);
%                         fclose(u3);
%                         fclose(u4);
%                         [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectTwo(u1,u2,u3,u4);
%                     else
%                         InstructionText = double('��ȴ����˷�Ӧ');
%                         Screen(w1, 'TextSize', 30);
%                         DrawFormattedText(w1,InstructionText,'center','center', 1, [],[],[],2);
%                         Screen('Flip',w1);
%                     end
                    
                    Practice(w1,start_action,escape_action);
                    practice = 1;
                    %practice = 1;
                    if practice == 1
                        break
                    end
                end
                
                [chose_onset,picnum,picid] = StimDisplay(stinum,iid,i,w1,stimi,cue_dir,xCenter,yCenter,font_size,black);  %�̼�����
                StimNum(stimi,i) = picnum;
                ComNum(stimi,i) = picid;
                num = num + 1;
                TrialNum = num;
                trials = TrialNum;
                

                %result(trials,1).PositionChose = position_chose;
                %��һ�ΰ������õ���һ�η���
                [chose_RT,position_chose,confidence_rating,confidence_rating_RT,raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41] = KeyBoard1DC(w1,more,rateless,ratemore,stop_rating,escape_action,less,xCenter,...
    yCenter,move_left,move_right,chose_onset,red,frame_left_left,GetSecs,triangle,SCALE_GL,u1,u2,u3,u4,font_size,black);  %�жϰ���(��һ���ж�)
                %[raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41]=FeedbackOne(w1,u1,u2,u3,u4,xCenter,yCenter,font_size,black); 
                result(trials,1).PositionChose = position_chose;
                result(trials,1).ConfRate = confidence_rating;
                result(trials,1).RToConfRate = confidence_rating_RT;
                result(trials,1).RawChoseOne = raw_choseone;
                
                % д�����ˣ���һ�Σ�
                fwrite(u1,[raw_choseone]);
                fwrite(u2,[raw_choseone]);
                fwrite(u3,[raw_choseone]);
                fwrite(u4,[raw_choseone]);
%                 fwrite(u1,position_chose);
%                 fwrite(u2,position_chose);
%                 fwrite(u3,position_chose);
%                 fwrite(u4,position_chose);
                
                %
                DrawFormattedText(w1,double('��ȴ����˵ڶ���ѡ���� >>>'),'center','center', 1,[],[],[],2);
                Screen('Flip',w1,[]);
                WaitSecs(2);
                
                practice = 0;
                while practice == 0
                %�ڶ�������
                    fclose(u1);
                    fclose(u2);
                    fclose(u3);
                    fclose(u4);
                    [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectTwo(u1,u2,u3,u4);
                    practice = 1;
                    %practice = 1;
                    if practice == 1
                        break
                    end
                    
                end
                
                % �ȴ��ڶ��η�Ӧ
                [raw_chosetwo,raw_chose12,raw_chose22,raw_chose32,raw_chose42]=FeedbackTwoDC(w1,u1,u2,u3,u4,xCenter,yCenter,font_size,black,raw_choseone); %�ȴ����˸��ĺ󣨵ڶ���ѡ�񣩷���
                result(trials,1).RawChoseTwo = raw_chosetwo;
                
                %% ����ѡ��
                %����������ѡ��
                decision_check=1;
                while decision_check==1
                    %���ִ̼�������ѡ��
                    LeaderStimDis(w1,xCenter,yCenter,font_size);
                    
                    %����
                    [decision_RT,decision_check,group_decision,decision_confidence_rating,decision_confidence_rating_RT] = KeyBoard2DC(w1,more,rateless,ratemore,stop_rating,escape_action,less,xCenter,...
                        yCenter,move_left,move_right,GetSecs,red,frame_left_left,triangle,SCALE_GL);
                    result(trials,1).DecisionRT = decision_RT;
                    result(trials,1).GroupDecision = group_decision;
                    result(trials,1).GroupDecisionRate = decision_confidence_rating;
                    result(trials,1).RToGroupDecisionRate = decision_confidence_rating_RT;

                    %׼ȷ��
                    switch picnum > picid
                        case group_decision == 1
                            acc = 1;
                        case group_decision == 2
                            acc = 0;
                    end
                    
                    switch picnum < picid
                        case group_decision == 1
                            acc = 0;
                        case group_decision == 2
                            acc = 1;
                    end
                    result(trials,1).ACC = acc;
                            
                    %д��������
                    WirteOthers(w1,xCenter,yCenter,font_size,black,u1,u2,u3,u4,group_decision);
                    
                    if decision_check==0
                        break
                    end
                end
                
                
                
                %             if KeyA  == 1
                %                 break
                %             end
                %
                %             if KeyCode(escape_action)
                %                 Screen('CloseAll');
                %                 ShowCursor;
                %                 fclose('all');
                %                 error('experiment aborted by user');
                %             end
                
                
                
                
                
                %%%% gains and losses feedback %%%%
                %                     DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                     raw_chose1=fread(u1,1); %��ȡ�������尴�������������ip�ж�
                %                     raw_chose2=fread(u2,1);
                %                     raw_chose3=fread(u3,1);
                %                     raw_chose4=fread(u4,1);
                %                     DrawFormattedText(w1,double(['A:',num2str(raw_chose1)]),xCenter-130,yCenter+8.5*font_size-490, black,[],[],[],2);  %λ�ñ仯500
                %                     DrawFormattedText(w1,double(['B:',num2str(raw_chose2)]),xCenter-130,yCenter+8.5*font_size-480, black,[],[],[],2);
                %                     DrawFormattedText(w1,double(['C:',num2str(raw_chose3)]),xCenter-130,yCenter+8.5*font_size-470, black,[],[],[],2);
                %                     DrawFormattedText(w1,double(['D:',num2str(raw_chose4)]),xCenter-130,yCenter+8.5*font_size-460, black,[],[],[],2);
                %                     %DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                     Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
                %                     Screen('Flip',w1,[]);
                
                
                % �����Ҫ��Ϊ�е��˻ᷴӦ�Ͽ�
                %                 DrawFormattedText(w1,double('�������ѡ����ȴ�������� >>>'),'center','center', 1,[],[],[],2);
                %                 Screen('Flip',w1,[]);
                % leader��ȡ�����˵�ѡ��
                %%%% ��һ��ѡ�������������
                %                 fwrite(u1,position_chose);
                %                 fwrite(u2,position_chose);
                %                 fwrite(u3,position_chose);
                %                 fwrite(u4,position_chose);
                %
                %                 raw_chose1=fread(u1,1); %��ȡ�������尴�������������ip�ж�
                %                 raw_chose2=fread(u2,1);
                %                 raw_chose3=fread(u3,1);
                %                 raw_chose4=fread(u4,1);
                %
                %                 DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                 DrawFormattedText(w1,double(['A:',num2str(raw_chose1)]),xCenter-130,yCenter+8.5*font_size-490, black,[],[],[],2);  %λ�ñ仯500
                %                 DrawFormattedText(w1,double(['B:',num2str(raw_chose2)]),xCenter-130,yCenter+8.5*font_size-480, black,[],[],[],2);
                %                 DrawFormattedText(w1,double(['C:',num2str(raw_chose3)]),xCenter-130,yCenter+8.5*font_size-470, black,[],[],[],2);
                %                 DrawFormattedText(w1,double(['D:',num2str(raw_chose4)]),xCenter-130,yCenter+8.5*font_size-460, black,[],[],[],2);
                %                 %DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                 Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
                %                 Screen('Flip',w1,[]);
                
                % %                 if KeyA==1&&DeckCheck==0
                %%%% transfer data process %%%%
                % %                     %% 4�����Ե�ѡ�񣨵�һ�η�����
                % %                     raw_chose1 = 0;
                % %                     raw_chose2 = 0;
                % %                     raw_chose3 = 0;
                % %                     raw_chose4 = 0;
                % %                     position_chose_total_1 = 0;
                % %                     position_chose_total_2 = 0;
                % %                     position_chose_total_3 = 0;
                % %                     position_chose_total_4 = 0;
                % %                     chose_sum = [position_chose_total_1,position_chose_total_2,position_chose_total_3,position_chose_total_4];  %
                % %
                % %                     DrawFormattedText(w1,double('�������ѡ����ȴ�������� >>>'),'center','center', 1,[],[],[],2);
                % %                     Screen('Flip',w1,[]);
                % %
                % %                     ��leader��ѡ��д��client������һ�η���
                % %
                % %                     fwrite(u1,1);
                % %                     fwrite(u2,1);
                % %                     fwrite(u3,1);
                % %                     fwrite(u4,1);
                % %
                % %                     ��ȡ���˾��ߣ���һ��ѡ��
                % %                     raw_chose1=fread(u1,1);  %Read binary data�����������ݣ� from file
                % %                     raw_chose2=fread(u2,1);
                % %                     raw_chose3=fread(u3,1);
                % %                     raw_chose4=fread(u4,1);
                % %
                % %
                % %                     matrix_chose = [position_chose, raw_chose1,raw_chose2, raw_chose3, raw_chose4];  %
                % %                     position_chose_total_1 = length(find(matrix_chose == 1));
                % %                     position_chose_total_2 = length(find(matrix_chose == 2));
                % %                     position_chose_total_3 = length(find(matrix_chose == 3));
                % %                     position_chose_total_4 = length(find(matrix_chose == 4));
                % %
                % %                     chose_sum = [position_chose_total_1,position_chose_total_2,position_chose_total_3,position_chose_total_4];  %
                % %
                % %
                % %                     if KeyCode(escape_action)
                % %                         Priority(0);
                % %                         break
                % %                         Screen('CloseAll');
                % %                         ShowCursor;
                % %                         fclose('all');
                % %                         error('experiment aborted by user');
                % %                     end
                % %
                % %                     ���Ƿ����ܵ�ѡ�����
                % %                     fwrite(u1,[chose_sum]);  %Write binary data to file
                % %                     fwrite(u2,[chose_sum]);
                % %                     fwrite(u3,[chose_sum]);
                % %                     fwrite(u4,[chose_sum]);
                % %
                % %
                % %                     %% gains and losses feedback %%%%
                % %                     decision_check=1;
                % %                     while decision_check==1
                % %                         if position_chose_total_1 > 0 %%%�жϵ�����ѡ���ʱ�����ѡ����Ŀ,����ѡ���򲻵������֣�
                % %                             DrawFormattedText(w1,double(num2str(position_chose_total_1)),xCenter-600,yCenter+8.5*font_size-500, black,[],[],[],2);
                % %                         end
                % %
                % %                         if position_chose_total_2 > 0
                % %                             DrawFormattedText(w1,double(num2str(position_chose_total_2)),xCenter-240,yCenter+8.5*font_size-500, black,[],[],[],2);
                % %                         end
                % %                         if position_chose_total_3 > 0
                % %                             DrawFormattedText(w1,double(num2str(position_chose_total_3)),xCenter-240,yCenter+8.5*font_size-500, black,[],[],[],2);
                % %                         end
                % %                         if position_chose_total_4 > 0
                % %                             DrawFormattedText(w1,double(num2str(position_chose_total_4)),xCenter-240,yCenter+8.5*font_size-500, black,[],[],[],2);
                % %                         end
                % %                         WaitSecs(1.5);
                % %                         Screen('Flip', w1);
                
                %                         %% �Ƿ����
                %                         yesword = double('��');
                %                         noword = double('��');
                %                         DrawFormattedText(w1,double('���Ƿ�����Լ��ľ���'),'Center',yCenter+100,1,[],[],[],2);
                %                         DrawFormattedText(w1,yesword,xCenter+200,yCenter+150,1,[],[],[],2); %150
                %                         DrawFormattedText(w1,noword,xCenter+100,yCenter+150,1,[],[],[],2);
                %                         Screen(w1, 'TextSize', 30);
                %                         Screen('Flip',w1);
                %                         [KeyIsDown,secs,KeyCode] = KbCheck;
                %                         KeyA = 0;
                %
                %
                %                         %��������
                %                         %&& ((GetSecs - confidence_pre_onset)<10)
                %
                %
                %                         subIDe=Shuffle([1 2]); %�����������ֵ��Ǹ��
                %                         if  subIDe(1) == 1 %%%������ʼֵ�ж�
                %                             x1 = xCenter-235;
                %                         else
                %                             x1 = xCenter+220;
                %                         end
                %
                %                         [KeyIsDown,secs,KeyCode] = KbCheck;
                %                         ratingkey=0;
                %
                %                         if KeyCode(more)  %ѡ��more
                %                             KeyA = 1;
                %                             %KeyDown = 1;
                %                             chose_RT = secs - chose_onset;
                %                             DeckCheck=0;
                %                             position_chose = 1; % 1 means more;
                %                             %ѡ�����
                %                             Screen('FrameRect', w1, red, frame_left_left, [6]);
                %                             Screen('Flip',w1,[],0);
                %                             WaitSecs(1);
                %
                %
                %
                %
                %                             %%%%%%%% present confidence rating controlled by keyboard %%%%%%
                %
                %                             confidence_pre_onset=GetSecs;  %��ʼʱ��
                %                             while ratingkey ==0 %���ְ���
                %                                 RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);  %������������
                %                                 % ��ʼʱλ��
                %                                 [KeyIsDown,secs,KeyCode] = KbCheck;
                %                                 ConfidenceText = double('��Ը�ѡ������ĳ̶�');
                %                                 DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                %                                 %��ȡ�̼��ļ������ͼƬ
                %                                 GRect=Screen('Rect',triangle);
                %                                 Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) %������
                %                                 pRect = Screen('Rect',SCALE_GL);
                %                                 Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]); %���
                %                                 Screen('Flip', w1,[],0);
                %
                %                                 % ����
                %                                 [KeyIsDown,secs,KeyCode] = KbCheck;
                %                                 KeyNum = find(KeyCode);  %̽�ⰴ��,keycode��ɨ����
                %                                 rank = size(KeyNum);  %�ó�������
                %
                %                                 if KeyCode(rateless)
                %                                     if x1 + move_left < xCenter-235  %λ���ƶ�
                %                                         x1 = x1;
                %                                     else
                %                                         x1 = x1 + move_left;
                %                                     end
                %
                %                                     %�ƶ������Σ���ʾ����
                %                                     DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                %                                     Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) ;
                %                                     pRect=Screen('Rect',SCALE_GL);
                %                                     Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                %                                     Screen('Flip', w1);
                %                                     WaitSecs(0.15);
                %                                 elseif KeyCode(ratemore)
                %                                     if x1 + move_right > xCenter+220
                %                                         x1 = x1;
                %                                     else
                %                                         x1 = x1 + move_right;
                %                                     end
                %
                %                                     DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                %                                     Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]);
                %                                     pRect=Screen('Rect',SCALE_GL);
                %                                     Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                %                                     Screen('Flip', w1);
                %                                     WaitSecs(0.15);
                %
                %
                %                                 elseif KeyCode(stop_rating)  %������ֹͣ
                %                                     RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                %                                     ratingkey = 1;
                %                                     %confidence_response = ((x1-xCenter+235)/455)*100;
                %                                     confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                %                                     confidence_rating_RT = GetSecs - confidence_pre_onset;
                %
                %                                 elseif KeyCode(escape_action)
                %                                     %Priority(0);
                %                                     Screen('CloseAll');
                %                                     ShowCursor;
                %                                     fclose('all');
                %                                     error('experiment aborted by user');
                %
                %                                 end
                %                             end
                %                         elseif KeyCode(less)
                %                             KeyA =1;
                %                             %KeyDown = 1;
                %                             chose_RT = secs - chose_onset;
                %                             DeckCheck=0;
                %                             position_chose = 2; % 1 means deck_A, 2 means deck_B, 3 means deck_C, 4 means deck_D;
                %                             %ѡ�����
                %                             Screen('FrameRect', w1, red, frame_left_left, [6]);
                %                             Screen('Flip',w1,[],0);
                %                             WaitSecs(1);
                %
                %
                %                             %%%%%%%% present confidence rating controlled by keyboard %%%%%%
                %
                %
                %                             confidence_pre_onset=GetSecs;
                %                             while ratingkey ==0
                %                                 RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                %                                 [KeyIsDown,secs,KeyCode] = KbCheck;
                %                                 ConfidenceText = double('��Ը�ѡ������ĳ̶�');
                %                                 DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2); %λ��
                %
                %                                 %��ȡ�ļ����е�ͼƬ
                %                                 GRect=Screen('Rect',triangle);
                %                                 Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20])
                %                                 pRect = Screen('Rect',SCALE_GL);
                %                                 Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                %                                 Screen('Flip', w1,[],0);
                %
                %                                 %̽�ⰴ��
                %                                 [KeyIsDown,secs,KeyCode] = KbCheck;
                %                                 KeyNum = find(KeyCode);
                %                                 rank = size(KeyNum);
                %
                %                                 if KeyCode(rateless)
                %                                     if x1 + move_left < xCenter-235
                %                                         x1 = x1;
                %                                     else
                %                                         x1 = x1 + move_left;  %�������ƶ���λ��
                %                                     end
                %                                     DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                %                                     Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) ;
                %                                     pRect=Screen('Rect',SCALE_GL);
                %                                     Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                %                                     Screen('Flip', w1);
                %                                     WaitSecs(0.15);
                %
                %                                 elseif KeyCode(ratemore)
                %                                     if x1 + move_right > xCenter+220
                %                                         x1 = x1;
                %                                     else
                %                                         x1 = x1 + move_right;
                %                                     end
                %
                %                                     DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
                %                                     Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]);
                %                                     pRect=Screen('Rect',SCALE_GL);
                %                                     Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
                %                                     Screen('Flip', w1);
                %                                     WaitSecs(0.15);
                %
                %                                 elseif KeyCode(stop_rating)
                %                                     RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
                %                                     ratingkey = 1;
                %                                     %confidence_response = ((x1-xCenter+235)/455)*100;
                %                                     confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                %                                     confidence_rating_RT = GetSecs - confidence_pre_onset;
                %
                %                                 elseif KeyCode(escape_action)
                %                                     %Priority(0);
                %                                     Screen('CloseAll');
                %                                     ShowCursor;
                %                                     fclose('all');
                %                                     error('experiment aborted by user');
                %
                %                                 end
                %                             end
                %                         end
                %%%% �����Ҫ��Ϊ�е��˻ᷴӦ�Ͽ�
                %%%% leader�����Ƿ�ı������ѡ��
                %                 fwrite(u1,position_chose);
                %                 fwrite(u2,position_chose);
                %                 fwrite(u3,position_chose);
                %                 fwrite(u4,position_chose);
                
                % leader��ȡ�����˵�ѡ��
                
                %%%% ��ȡ���˵ڶ��θ��ĺ�ѡ��
                
                
                
                
                
                %% ���ĺ���
                %                         raw_chose1=fread(u1,1);  %Read binary data�����������ݣ� from file
                %                         raw_chose2=fread(u2,1);
                %                         raw_chose3=fread(u3,1);
                %                         raw_chose4=fread(u4,1);
                %
                %
                %                         matrix_chose = [position_chose, raw_chose1,raw_chose2, raw_chose3, raw_chose4];  %
                %                         position_chose_total_1 = length(find(matrix_chose == 1));
                %                         position_chose_total_2 = length(find(matrix_chose == 2));
                %                         position_chose_total_3 = length(find(matrix_chose == 3));
                %                         position_chose_total_4 = length(find(matrix_chose == 4));
                %
                %                         chose_sum = [position_chose_total_1,position_chose_total_2,position_chose_total_3,position_chose_total_4];  %
                %
                %
                %                         if KeyCode(escape_action)
                %                             %Priority(0);
                %                             break
                %                             Screen('CloseAll');
                %                             ShowCursor;
                %                             fclose('all');
                %                             error('experiment aborted by user');
                %                         end
                %                     end
                %
                %                     %���Ƿ����ܵ�ѡ�����
                %                     fwrite(u1,[chose_sum]);  %Write binary data to file
                %                     fwrite(u2,[chose_sum]);
                %                     fwrite(u3,[chose_sum]);
                %                     fwrite(u4,[chose_sum]);
                %
                %
                %                     %%%% gains and losses feedback %%%%
                %                     decision_check=1;
                %                     while decision_check==1
                %                         if position_chose_total_1 > 0 %%%�жϵ�����ѡ���ʱ�����ѡ����Ŀ,����ѡ���򲻵������֣�
                %                             DrawFormattedText(w1,double(num2str(position_chose_total_1)),xCenter-600,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                         end
                %
                %                         if position_chose_total_2 > 0
                %                             DrawFormattedText(w1,double(num2str(position_chose_total_2)),xCenter-240,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                         end
                %                         if position_chose_total_3 > 0
                %                             DrawFormattedText(w1,double(num2str(position_chose_total_3)),xCenter-240,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                         end
                %                         if position_chose_total_4 > 0
                %                             DrawFormattedText(w1,double(num2str(position_chose_total_4)),xCenter-240,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                         end
                %                         WaitSecs(1.5);
                %                         Screen('Flip', w1);
                
                
                
                
                
                
                %                         fwrite(u1,group_decision);
                %                                                 fwrite(u2,group_decision);
                %                                                 fwrite(u3,group_decision);
                %                                                 fwrite(u4,group_decision);
                
                
                %                         if   group_decision == 1
                %                             %earnings = matrix_1(group_decision,NumA);
                %                             %losses = matrix_2(group_decision,NumA);
                %                             %net_income = earnings + losses;
                %                             %total_score = total_score + net_income;
                %                             group_performance = matrix_3(a, group_decision); %matrix_3ָ������������
                %                             DrawFormattedText(w1,double('�ܽ��:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                             DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                             Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
                %
                %
                %
                %                         elseif group_decision == 2
                %                             earnings = matrix_1(group_decision,NumB);
                %                             losses = matrix_2(group_decision,NumB);
                %                             net_income = earnings + losses;
                %                             total_score = total_score + net_income;
                %                             group_performance = matrix_3(a, group_decision);
                %
                %                             DrawFormattedText(w1,double('�ܽ��:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                             DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
                %
                %                         end
                
                
                
                %                 if KeyA  == 1
                %                     break
                %                 end
                %
                %                 if KeyCode(escape_action)
                %                     Screen('CloseAll');
                %                     ShowCursor;
                %                     fclose('all');
                %                     error('experiment aborted by user');
                %                 end
                %             end
                KeyIsDown = 0;
                
                %  fprintf(fp,'%s\n',...
                % 'subNo');
                if DeckCheck==0
                    fprintf(fp,'%d\t%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',...
                        subNo,gender,name,TrialNum,position_chose,chose_RT,confidence_rating,confidence_rating_RT,group_decision,decision_RT,decision_confidence_rating,decision_confidence_rating_RT,raw_choseone,raw_chosetwo,version,acc);
                end
                if num==100
                    break
                end
            end
        end
    end
    
    
    
    
    
    
    %%
    fclose(u1);
    fclose(u2);
    fclose(u3);
    fclose(u4);
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
    
    %%%%%
    for trials = 1:210
        
        result(trials,1).SubNo = subNo;
        result(trials,1).Age = age;
        result(trials,1).Group = group;
        if gender == 0
            result(trials,1).Gender = 'Male';
        else
            result(trials,1).Gender = 'Female';
        end
        result(trials,1).Version = version;
        if  hand == 1
            result(trials,1).Handedness = 'Right';
        else
            result(trials,1).Handedness = 'Left';
        end
    end
    columheader ={'SubNo','Group','Version','Gender','Age','Handedness','ACC','PositionChose','ConfRate',...
        'RToConfRate','RawChoseOne','RawChoseTwo','DecisionRT','GroupDecision','GroupDecisionRate','RToGroupDecisionRate'};
    result = orderfields(result,columheader);
    ret = [columheader;(struct2cell(result))'];
    if ~exist(['D:\Yangyang20201113\ExpOne\FinalExpProcedureServer\data_individual_decision\GroupDecLead_',...
            char(subNo),'_',char(group), '.xls'],'file')
        xlswrite(['D:\Yangyang20201113\ExpOne\FinalExpProcedureServer\data_individual_decision\GroupDecLead_',...
            char(subNo),'_',char(group), '.xls'],ret);
    else
        xlswrite(['D:\Yangyang20201113\ExpOne\FinalExpProcedureServer\data_individual_decision\GroupDecLead_',...
            char(subNo),'_',char(group),'_999', '.xls'],ret);
    end
    %�����Ե�ʱ��ǵøı�·��;
    %Priority(0);
    Screen('CloseAll');
    ListenChar(0);
catch
    
    %ShowCursor;
    Screen('CloseAll');
    psychrethrow(lasterror);
    ListenChar(0);
end
ListenChar(0);



return;
