function [chose_RT,position_chose,confidence_rating,confidence_rating_RT,raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41] = KeyBoard1(w1,more,rateless,ratemore,stop_rating,escape_action,less,xCenter,...
    yCenter,move_left,move_right,chose_onset,red,frame_left_left,GetSecs,triangle,SCALE_GL,u1,u2,u3,u4,font_size,black)
% KeyA控制参数
% chose_RT表示选择多少的反应是
% DeckCheck控制参数
% position_chose表示选择的情况
% conf表示选择信心
% ,CheckConnectionTwo1,CheckConnection121,CheckConnection221,CheckConnection321,CheckConnection421

[KeyIsDown,secs,KeyCode] = KbCheck;  
KeyA = 0;
while 1    %&& ((GetSecs - confidence_pre_onset)<10)
    [x1]=ShufID(xCenter);
    ratingkey=0;
    [KeyIsDown,secs,KeyCode] = KbCheck;
    if KeyCode(more)  %选择more
        KeyA = 1;
        %KeyDown = 1;
        chose_RT = secs - chose_onset;
        DeckCheck=0;
        position_chose = 1; % 1 means more
        %选择后反馈
        Screen('FrameRect', w1, red, frame_left_left, [6]);
        Screen('Flip',w1,[],0);
        WaitSecs(1);
        
        %%%%%%%% present confidence rating controlled by keyboard %%%%%%
        
        confidence_pre_onset=GetSecs;  %开始时间
        while ratingkey ==0 %评分按键
            RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);  %限制其他按键
            % 开始时位置
            [KeyIsDown,secs,KeyCode] = KbCheck;
            ConfidenceText = double('你对该选择的信心程度');
            DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
            %读取刺激文件夹里的图片
            GRect=Screen('Rect',triangle);
            Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20]) %三角形
            pRect = Screen('Rect',SCALE_GL);
            Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]); %标尺
            Screen('Flip', w1,[],0);
            
            % 按键
            [KeyIsDown,secs,KeyCode] = KbCheck;
            KeyNum = find(KeyCode);  %探测按键,keycode是扫描码
            rank = size(KeyNum);  %得出按键数
            
            if KeyCode(rateless)
                if x1 + move_left < xCenter-235  %位置移动
                    x1 = x1;
                else
                    x1 = x1 + move_left;
                end
                
                %移动三角形，表示评分
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
                
                
            elseif KeyCode(stop_rating)  %评分完停止
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
        
        %%%% 反馈出他人的决定 %%%%
        %需要探测其他人的按键，然后将那些按键又返回为结果
        
    elseif KeyCode(less)
        KeyA =1;
        %KeyDown = 1;
        chose_RT = secs - chose_onset;
        DeckCheck=0;
        position_chose = 2; % 1 means deck_A, 2 means deck_B, 3 means deck_C, 4 means deck_D;
        %选择后反馈
        Screen('FrameRect', w1, red, frame_left_left, [6]);
        Screen('Flip',w1,[],0);
        WaitSecs(1);
        
        %%%%%%%% present confidence rating controlled by keyboard %%%%%%
        confidence_pre_onset=GetSecs;
        while ratingkey ==0
            RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
            [KeyIsDown,secs,KeyCode] = KbCheck;
            ConfidenceText = double('你对该选择的信心程度');
            DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2); %位置
            
            %读取文件夹中的图片
            GRect=Screen('Rect',triangle);
            Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20])
            pRect = Screen('Rect',SCALE_GL);
            Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
            Screen('Flip', w1,[],0);
            
            %探测按键
            [KeyIsDown,secs,KeyCode] = KbCheck;
            KeyNum = find(KeyCode);
            rank = size(KeyNum);
            
            if KeyCode(rateless)
                if x1 + move_left < xCenter-235
                    x1 = x1;
                else
                    x1 = x1 + move_left;  %三角形移动的位置
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
        
        DrawFormattedText(w1,double('您已完成选择，请等待他人完成 >>>'),'center','center', 1,[],[],[],2);
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
        
        % 读写信息
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
        [raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41]=FeedbackOne(w1,u1,u2,u3,u4,xCenter,yCenter,font_size,black); %等待他人第一次选择反馈
       
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