function [chose_RT,position_chose,confidence_rating,confidence_rating_RT,raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41] = KeyBoard1(w1,more,rateless,ratemore,stop_rating,escape_action,less,xCenter,...
    yCenter,move_left,move_right,chose_onset,red,frame_left_left,GetSecs,triangle,SCALE_GL,u1,u2,u3,u4,font_size,black)
% KeyA���Ʋ���
% chose_RT��ʾѡ����ٵķ�Ӧ��
% DeckCheck���Ʋ���
% position_chose��ʾѡ������
% conf��ʾѡ������
% ,CheckConnectionTwo1,CheckConnection121,CheckConnection221,CheckConnection321,CheckConnection421

[KeyIsDown,secs,KeyCode] = KbCheck;  
KeyA = 0;
while 1    %&& ((GetSecs - confidence_pre_onset)<10)
    [x1]=ShufID(xCenter);
    ratingkey=0;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    if KeyCode(more)  %ѡ��more
        KeyA = 1;
        %KeyDown = 1;
        chose_RT = secs - chose_onset;
        DeckCheck=0;
        position_chose = 1; % 1 means more
        %ѡ�����
        Screen('FrameRect', w1, red, frame_left_left, [6]);
        Screen('Flip',w1,[],0);
        WaitSecs(1);
        
        %%%%%%%% present confidence rating controlled by keyboard %%%%%%
        
        confidence_pre_onset=GetSecs;  %��ʼʱ��
        while ratingkey ==0 %���ְ���
            RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);  %������������
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
        
        %KeyA = KeyA;
        
        %%%% ���������˵ľ��� %%%%
        %��Ҫ̽�������˵İ�����Ȼ����Щ�����ַ���Ϊ���
        
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
        
        %KeyA = KeyA;
    end
    
    
    if KeyA==1&&DeckCheck==0
        
        DrawFormattedText(w1,double('�������ѡ����ȴ�������� >>>'),'center','center', 1,[],[],[],2);
        Screen('Flip',w1,[]);
        DeckCheck=1;
        WaitSecs(2);
        
        if KeyCode(escape_action)
            %Priority(0);
            break
            Screen('CloseAll');
            ShowCursor;
            fclose('all');
            error('experiment aborted by user');
        end
        
        % ��д��Ϣ
%         fclose(u1);
%         fclose(u2);
%         fclose(u3);
%         fclose(u4);
%         [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectTwo(u1,u2,u3,u4);
%         CheckConnectionTwo1 = CheckConnectionTwo;
%         CheckConnection121 = CheckConnection12;
%         CheckConnection221 = CheckConnection22;
%         CheckConnection321 = CheckConnection32;
%         CheckConnection421 = CheckConnection42;
        [raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41]=FeedbackOne(w1,u1,u2,u3,u4,xCenter,yCenter,font_size,black); %�ȴ����˵�һ��ѡ����
       
        if DeckCheck  == 1
            break
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

%return(KeyA,chose_RT,DeckCheck,position_chose,conf);