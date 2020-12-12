function [KeyA,decision_RT,decision_check,position_chose2,decision_confidence_rating,decision_confidence_rating_RT] = KeyBoardClient2(w1,rateless,ratemore,stop_rating,escape_action,xCenter,...
    yCenter,move_left,move_right,red,frame_left_left,GetSecs,triangle,SCALE_GL,yeschange,nochange,position_chose1)
% ����ѡ��İ���
%
%
[KeyIsDown,secs,KeyCode] = KbCheck;
KeyA = 0;
while 1
    [x1] = ShufID(xCenter);
    [KeyIsDown,secs,KeyCode] = KbCheck;
    ratingkey=0;
    chose_onset=GetSecs;
    if KeyCode(yeschange)  %ѡ��more��yeschange:q
        KeyA = 1; %����
        %KeyDown = 1;
        decision_RT = GetSecs - chose_onset;
        decision_check=0;
        if position_chose1 == 1
            position_chose2 = 2; % 1 means more;
        elseif  position_chose1 == 2
            position_chose2 = 1;
        end
        %ѡ�����
        Screen('FrameRect', w1, red, frame_left_left, [6]);
        Screen('Flip',w1,[],0);
        WaitSecs(1);
        
        %%%%%%%% present confidence rating controlled by keyboard %%%%%%
        
        confidence_pre_onset=GetSecs;  %��ʼʱ��
        while ratingkey ==0 %���ְ���
            RestrictKeysForKbCheck([yeschange nochange ratemore rateless stop_rating escape_action]);  %������������
            % ��ʼʱλ��
            [KeyIsDown,secs,KeyCode] = KbCheck;
            ConfidenceText = double('��Ը�ѡ������ĳ̶�');
            DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
            %��ȡ�̼��ļ������ͼƬ
            GRect=Screen('Rect',triangle);
            Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) %������
            pRect = Screen('Rect',SCALE_GL);
            Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]); %���
            Screen('Flip', w1,[],0);
            
            % ����
            [KeyIsDown,secs,KeyCode] = KbCheck;
            KeyNum = find(KeyCode);  %̽�ⰴ��,keycode��ɨ����
            rank = size(KeyNum);  %�ó�������
            
            if KeyCode(rateless)
                if x1 + move_left < xCenter-235  %λ���ƶ�
                    x1 = x1;
                else
                    x1 = x1 + move_left;
                end
                
                %�ƶ������Σ���ʾ����
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
                
                
            elseif KeyCode(stop_rating)  %������ֹͣ
                RestrictKeysForKbCheck([yeschange nochange ratemore rateless stop_rating escape_action]);
                ratingkey = 1;
                %confidence_response = ((x1-xCenter+235)/455)*100;
                decision_confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                decision_confidence_rating_RT = GetSecs - confidence_pre_onset;
                
            elseif KeyCode(escape_action)
                %Priority(0);
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                error('experiment aborted by user');
                
            end
        end
        %fwrite(u1,position_chose);
        
    elseif KeyCode(nochange)
        KeyA =1;
        %KeyDown = 1;
        decision_RT = GetSecs - chose_onset;
        decision_check=0;
        position_chose2 = position_chose1; % 1 means deck_A, 2 means deck_B, 3 means deck_C, 4 means deck_D;
        %ѡ�����
        Screen('FrameRect', w1, red, frame_left_left, [6]);
        Screen('Flip',w1,[],0);
        WaitSecs(1);
        
        
        %%%%%%%% present confidence rating controlled by keyboard %%%%%%
        
        
        confidence_pre_onset=GetSecs;
        while ratingkey ==0
            RestrictKeysForKbCheck([yeschange nochange ratemore rateless stop_rating escape_action]);
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
                    x1 = x1 + move_left;  %�������ƶ���λ��
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
                RestrictKeysForKbCheck([yeschange nochange ratemore rateless stop_rating escape_action]);
                ratingkey = 1;
                %confidence_response = ((x1-xCenter+235)/455)*100;
                decision_confidence_rating = (x1-xCenter+235)/75.83333 + 1;
                decision_confidence_rating_RT = GetSecs - confidence_pre_onset;
                
            elseif KeyCode(escape_action)
                %Priority(0);
                Screen('CloseAll');
                ShowCursor;
                fclose('all');
                error('experiment aborted by user');
                
            end
        end
    end
    if KeyCode(escape_action)
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        error('experiment aborted by user');
    end
    
    if KeyA  == 1
        break
    end
end
