%% general setting
% �ͻ��˴���
clc;
clear all;
try
    AssertOpenGL;
    Screen('Preference','SkipSyncTests',1);
    Screen('Preference','TextRenderer',1);
    Screen('Preference','TextEncodingLocale','UTF8');
    KbName('UnifyKeyNames');
    
    [subNo,group,gender,name,version,hand,age,IP1,fp]=PrepareInformation;  %׼��������Ϣ
    [w1,wRect,xCenter,yCenter,triangle,SCALE_GL,black,font_size,cue_dir,Checkcue_dir,red] = StimPrepare; %׼����Ļ�ʹ̼�
    [more,less,rateless,ratemore,yeschange,nochange,stop_rating,start_action,escape_action,move_left,move_right, ...
        frame_left_left,frame_left_right,frame_right_left,frame_right_right] = KeyBoard(xCenter,yCenter);  %���尴��
    %each card have two number, one is earning (matrix 1) and one is lose(matrix 2);
    %in each matrix, the first row means deck_1;the second row means deck_2;
    %the third row means deck_3;the fourth row means deck_4;
    %[u1,CheckConnectionOne,CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41]=ConnectionClientOne(w1,IP1);  %�������
    
    %% Experimental Process
    %start_time = GetSecs; % program start time
    trial_rep = 2;  %�ظ�����
    num=0;
    % this total_score means a starting value and will be updated as the game
    % goes on.
    iid = randperm(3,3);
    iidprac = randperm(5,5);
    stinum = [18,20,22];%19,21,
    StimNum = [];
    ComNum = [];
    DeckCheck=0;
    trials = 0;
    Inicheck = 0;
    practice = 0;
    ConCheck = 0;
    % numMore = 0;  %���ɻ�����
    % numLess = 0;
    % this total_score means a starting value and will be updated as the game
    % goes on.
    for  triali = 1  %:trial_rep
        for  stimi = 1:4  %:42 %%�ǵ������Ҫupdatez
            for  i = 1:3  %:5 %�̼�id
                while ConCheck == 0
                    [u1,CheckConnectionOne,CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41]=ConnectionClientOne(w1,IP1);  %�������
                    Instruction(w1,start_action,escape_action);  %ָ����
                    ConCheck = 1;
                    if ConCheck == 1
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
                            [chose_onset]= CheckStimDisplay(CheckStinum,iidprac,checki,w1,Checkcue_dir,xCenter,yCenter,font_size,black);
                            [chose_RT,position_chose,confidence_rating,confidence_rating_RT] = KeyBoard1(w1,more,rateless,ratemore,stop_rating,escape_action,...
                                less,xCenter,yCenter,move_left,move_right,chose_onset,red,frame_left_left,GetSecs,triangle,SCALE_GL,u1,font_size,black);
                            
                            %                     fwrite(u1,position_chose);
                            %
                            %                     feedback1(w1,u1,xCenter,yCenter,font_size,black);  %��һ�ζ�ȡleaderѡ�񣨷�����
                            
                            Chchose_RT = chose_RT;
                            Chposition_chose = position_chose;
                            Chconfidence_rating = confidence_rating;
                            Chconfidence_rating_RT = confidence_rating_RT;
                        end
                    end
                    Inicheck = 1;
                    if Inicheck == 1
                        break
                    end
                end
%                fclose(u1);
%               [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectionClientTwo(u1);
                while practice == 0
%                     fwrite(u1,checki);
%                     checkj = fread(u1,1);
%                     if checkj == 5
%                         fclose(u1);
%                         [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectionClientTwo(u1);
%                     else
%                         InstructionText = double('��ȴ����˷�Ӧ');
%                         Screen(w1, 'TextSize', 30);
%                         DrawFormattedText(w1,InstructionText,'center','center', 1, [],[],[],2);
%                         Screen('Flip',w1);
%                     end
                    Practice(w1,start_action,escape_action);
                    practice = 1;
                    if practice == 1
                        break
                    end
                end
                
                [chose_onset,picnum,picid]=StimDisplay(stinum,iid,i,w1,stimi,cue_dir,xCenter,yCenter,font_size,black);
                StimNum(stimi,i) = picnum;
                ComNum(stimi,i) = picid;
                num = num + 1;
                TrialNum = num;
                trials = TrialNum;
                %result(trials,1).PositionChose = position_chose;
                %��������
                %&& ((GetSecs - confidence_pre_onset)<10)
                %��һ�ΰ���,CheckConnectionOne1,CheckConnection111,CheckConnection211,CheckConnection311,CheckConnection411
                [chose_RT,position_chose,confidence_rating,confidence_rating_RT,raw_chosesum1] = KeyBoard1DC(w1,more,rateless,ratemore,stop_rating,escape_action,...
                    less,xCenter,yCenter,move_left,move_right,chose_onset,red,frame_left_left,GetSecs,triangle,SCALE_GL,u1,font_size,black);
                
%                 fwrite(u1,position_chose);
%                 
%                 feedback1(w1,u1,xCenter,yCenter,font_size,black);  %��һ�ζ�ȡleaderѡ�񣨷�����
                
                result(trials,1).PositionChose = position_chose;
                result(trials,1).ConfRate = confidence_rating;
                result(trials,1).RToConfRate = confidence_rating_RT;
                result(trials,1).RawChoseOne = raw_chosesum1;
                
                % �����Ҫ��Ϊ�е��˻ᷴӦ�Ͽ�
                %% �Ƿ����ѡ��
                decision_check=1;
                while decision_check==1
                    %�ڶ���ѡ��̼�����
                    StimClientDis(w1,xCenter,yCenter);
                    
                    %��������
                    %&& ((GetSecs - confidence_pre_onset)<10)
                    position_chose1 = position_chose;
                    [KeyA,decision_RT,decision_check,position_chose2,decision_confidence_rating,decision_confidence_rating_RT] = KeyBoardClient2(w1,rateless,ratemore,stop_rating,escape_action,xCenter,...
                        yCenter,move_left,move_right,red,frame_left_left,GetSecs,triangle,SCALE_GL,yeschange,nochange,position_chose1);  %�ڶ���ѡ�񰴼�
                    result(trials,1).DecisionRT = decision_RT;
                    result(trials,1).Position_chose2 = position_chose2;
                    result(trials,1).SecDecisionRate = decision_confidence_rating;
                    result(trials,1).RToGroupDecisionRate2 = decision_confidence_rating_RT;

                    % �ڶ����Ƿ���ĵ�ѡ��
                    
                    DrawFormattedText(w1,double('������ɸ���ѡ����ȴ�������� >>>'),'center','center', 1,[],[],[],2);
                    Screen('Flip',w1,[]);
                    DeckCheck = 0;
                    WaitSecs(2);
                    
                    %ѡ��д�����ˣ�����������
                    practice = 0;
                    while practice == 0
                        fclose(u1);
                        [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectionClientTwo(u1);
                        
                        practice = 1;
                        if practice == 1
                            break
                        end
                    end
                    fwrite(u1,position_chose2);
                    
                    [raw_chosesum2] = OthersFeed(w1,xCenter,yCenter,u1,font_size,black,raw_chosesum1);
                    %if KeyA==1&&DeckCheck==0
          
                    %Ⱥ������ѡ��
                    [raw_chose_lead]=FinaFeed(w1,u1,xCenter,yCenter,font_size,black);
                    result(trials,1).RawChoseTwo = raw_chosesum2;
                    %׼ȷ��
                    switch picnum > picid
                        case raw_chose_leader == 1
                            acc = 1;
                        case raw_chose_leader == 2
                            acc = 0;
                    end
                    
                    switch picnum < picid
                        case raw_chose_leader == 1
                            acc = 0;
                        case raw_chose_leader == 2
                            acc = 1;
                    end
                    result(trials,1).ACC = acc;
                    
                    if decision_check==0
                        break
                    end
                end
                
                
                
                
                
                
                %%%% gains and losses feedback %%%%
                
                
                %                 if KeyA==1&&DeckCheck==0
                %                     %%%% transfer data process %%%%
                %                     %% 4�����Ե�ѡ�񣨵�һ�η�����
                %                     % leader��ѡ��
                %                     raw_chose1 = 0;
                %                     position_chose_total_1 = 0;
                %                     chose_sum = position_chose_total_1;  %,position_chose_total_2,position_chose_total_3,position_chose_total_4
                %
                %
                %
                %                     %CheckConnection=fread(u1,8);
                %
                %                     %��ȡleader�ķ�������һ�η���
                %                     raw_chose_leader=fread(u1,1);  %Read binary data�����������ݣ� from file
                %                     matrix_chose = [position_chose,raw_chose_leader];  %, raw_chose1,raw_chose2, raw_chose3, raw_chose4
                %                     position_chose_total_leader = length(find(matrix_chose == 1));
                %                     chose_sum = position_chose_total_leader;  %,position_chose_total_2,position_chose_total_3,position_chose_total_4
                %
                %                     if KeyCode(escape_action)
                %                         %Priority(0);
                %                         break
                %                         Screen('CloseAll');
                %                         ShowCursor;
                %                         fclose('all');
                %                         error('experiment aborted by user');
                %                     end
                %
                %
                %                     fwrite(u1,[chose_sum]);  %Write binary data to file
                %
                %                     %%%% gains and losses feedback %%%%
                %                     decision_check=1;
                %                     while decision_check==1
                %                         if position_chose_total_leader > 0 %%%�жϵ�����ѡ���ʱ�����ѡ����Ŀ,����ѡ���򲻵������֣�
                %                             DrawFormattedText(w1,double(num2str(position_chose_total_leader)),xCenter-600,yCenter+8.5*font_size-500, black,[],[],[],2);
                %                             WaitSecs(1.5);
                %                             Screen('Flip', w1);
                %                         end
                
                
                
                
                
                
                
                
                
                
                %         if KeyA  == 1
                %             break
                %         end
                %         if KeyCode(escape_action)
                %             Screen('CloseAll');
                %             ShowCursor;
                %             fclose('all');
                %             error('experiment aborted by user');
                %         end
                %     end
                KeyIsDown = 0;
                
                %  fprintf(fp,'%s\n',...
                % 'subNo');
                if DeckCheck==0
                    fprintf(fp,'%d\t%d\t%s\t%d\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%d\t%d\t%d\t%d\t%d\n',...
                        subNo,gender,name,TrialNum,position_chose,chose_RT,confidence_rating,confidence_rating_RT,decision_RT,decision_confidence_rating,decision_confidence_rating_RT,position_chose1,position_chose2,raw_chose_leader,version,acc);
                end
                if num==100
                    break
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
        'RToConfRate','RawChoseOne','RawChoseTwo','DecisionRT','Position_chose2','SecDecisionRate','RToGroupDecisionRate2'};
    result = orderfields(result,columheader);
    ret = [columheader;(struct2cell(result))'];
    if ~exist(['D:\Yangyang\ExpOne\FinalExpProcedureClient\data_individual_decision\GroupDecTwo_',...
            char(subNo),'_',char(group), '.xls'],'file')
        xlswrite(['D:\Yangyang\ExpOne\FinalExpProcedureClient\data_individual_decision\GroupDecTwo_',...
            char(subNo),'_', char(group),'.xls'],ret);
    else
        xlswrite(['D:\Yangyang\ExpOne\FinalExpProcedureClient\data_individual_decision\GroupDecTwo_',...
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

%% ���ĺ���
%fwrite(u1,position_chose);



%                         matrix_chose = [position_chose,raw_chose_leader];  %, raw_chose1,raw_chose2, raw_chose3, raw_chose4
%                         position_chose_total_leader = length(find(matrix_chose == 1));
%                         chose_sum = position_chose_total_leader;  %,position_chose_total_2,position_chose_total_3,position_chose_total_4
%
%                         if KeyCode(escape_action)
%                             %Priority(0);
%                             break
%                             Screen('CloseAll');
%                             ShowCursor;
%                             fclose('all');
%                             error('experiment aborted by user');
%                         end
%
%
%                         fwrite(u1,[chose_sum]);  %Write binary data to file
%
%                         %%%% gains and losses feedback %%%%
%                         decision_check=1;
%                         while decision_check==1
%                             if position_chose_total_leader > 0 %%%�жϵ�����ѡ���ʱ�����ѡ����Ŀ,����ѡ���򲻵������֣�
%                                 DrawFormattedText(w1,double(num2str(position_chose_total_leader)),xCenter-600,yCenter+8.5*font_size-500, black,[],[],[],2);
%                                 WaitSecs(1.5);
%                                 Screen('Flip', w1);
%                             end
%
%                 DrawFormattedText(w1,double('��ȴ����վ���'),'Center',yCenter+250,1,[],[],[],2)
%                 WaitSecs(1.5);
%                 Screen('Flip', w1);
%
%                 %% ����Ⱥ��ѡ��
%                 fwrite(u1,position_chose);
%                 raw_chose_leader=fread(u1,1);  %Read binary data�����������ݣ� from file
%
%
%                 DrawFormattedText(w1,double('�Ŷ�����ѡ��'),'Center',yCenter+250,1,[],[],[],2);
%                 DrawFormattedText(w1,double(num2str(raw_chose_leader)),xCenter-130,yCenter+8.5*font_size-490, black,[],[],[],2);  %λ�ñ仯500
%                 WaitSecs(1.5);
%                 Screen('Flip', w1);
%                             raw_chose_leader=fread(u1,1);  %Read binary data�����������ݣ� from file
%                             matrix_chose = [position_chose,raw_chose_leader];  %, raw_chose1,raw_chose2, raw_chose3, raw_chose4
%                             position_chose_total_leader = length(find(matrix_chose == 1));
%                             chose_sum = position_chose_total_leader;  %,position_chose_total_2,position_chose_total_3,position_chose_total_4
%
%                             if KeyCode(escape_action)
%                                 %Priority(0);
%                                 break
%                                 Screen('CloseAll');
%                                 ShowCursor;
%                                 fclose('all');
%                                 error('experiment aborted by user');
%                             end
%
%
%                             fwrite(u1,[chose_sum]);  %Write binary data to file
%
%                             %%%% gains and losses feedback %%%%
%                             decision_check=1;
%                             while decision_check==1
%                                 if position_chose_total_leader > 0 %%%�жϵ�����ѡ���ʱ�����ѡ����Ŀ,����ѡ���򲻵������֣�
%                                     DrawFormattedText(w1,double(num2str(position_chose_total_leader)),xCenter-600,yCenter+8.5*font_size-500, black,[],[],[],2);
%                                     WaitSecs(1.5);
%                                     Screen('Flip', w1);
%                                 end

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


