function [KeyA,decision_RT,decision_check,group_decision,conf] = KeyBoard2()
% KeyA控制参数
% decision_RT表示选择多少的反应是
% decision_check控制参数
% group_decision表示选择的情况
% conf表示选择信心
if KeyCode(more)
    KeyA =1;
    %KeyDown = 1;
    decision_RT = GetSecs - chose_onset;
    decision_check=0;
    group_decision = 1; % 1 means deck_A, 2 means deck_B, 3 means deck_C, 4 means deck_D;
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
        DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
        
        GRect=Screen('Rect',triangle);
        Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20])
        pRect = Screen('Rect',SCALE_GL);
        Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
        Screen('Flip', w1,[],0);
        
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
    
elseif KeyCode(less)
    KeyA =1;
    %KeyDown = 1;
    decision_RT = GetSecs - chose_onset;
    decision_check=0;
    group_decision = 2; % 1 means more, 2 means less
    %选择后反馈
    Screen('FrameRect', w1, red, frame_left_left, [6]);
    Screen('Flip',w1,[],0);
    WaitSecs(1);
    
    confidence_pre_onset=GetSecs;
    while ratingkey ==0
        RestrictKeysForKbCheck([more less ratemore rateless stop_rating escape_action]);
        [KeyIsDown,secs,KeyCode] = KbCheck;
        ConfidenceText = double('你对该选择的信心程度');
        DrawFormattedText(w1,ConfidenceText,'center',yCenter+100, 1,[],[],[],2);
        
        GRect=Screen('Rect',triangle);
        Screen('DrawTexture',w1, triangle,GRect,[x1 yCenter-40 x1+15 yCenter-20])
        pRect = Screen('Rect',SCALE_GL);
        Screen('DrawTexture', w1, SCALE_GL,pRect,[xCenter-250 yCenter-20 xCenter+250 yCenter+30]);
        Screen('Flip', w1,[],0);
        
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
conf = x1;