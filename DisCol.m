function DisCol(w1,ChangeCol,red,black,feword12,feword22,feword32,feword42,xCenter,yCenter,font_size)
for i = 1:length(ChangeCol)
    if ChangeCol(i) == 1
        DrawFormattedText(w1,double(['A:',feword12]),xCenter,yCenter+8.5*font_size-355, red,[],[],[],2);  %位置变化500-100
        DrawFormattedText(w1,double(['B:',feword22]),xCenter,yCenter+8.5*font_size-255, black,[],[],[],2);%-70
        DrawFormattedText(w1,double(['C:',feword32]),xCenter,yCenter+8.5*font_size-155, black,[],[],[],2);%-40
        DrawFormattedText(w1,double(['D:',feword42]),xCenter,yCenter+8.5*font_size-55, black,[],[],[],2);%-10
        Screen('Flip',w1,[]);
        WaitSecs(1.5);  %呈现时间
    elseif ChangeCol(i) == 2
        DrawFormattedText(w1,double(['A:',feword12]),xCenter,yCenter+8.5*font_size-355, black,[],[],[],2);  %位置变化500-100
        DrawFormattedText(w1,double(['B:',feword22]),xCenter,yCenter+8.5*font_size-255, red,[],[],[],2);%-70
        DrawFormattedText(w1,double(['C:',feword32]),xCenter,yCenter+8.5*font_size-155, black,[],[],[],2);%-40
        DrawFormattedText(w1,double(['D:',feword42]),xCenter,yCenter+8.5*font_size-55, black,[],[],[],2);%-10
        Screen('Flip',w1,[]);
        WaitSecs(1.5);  %呈现时间
    elseif ChangeCol(i) == 3
        DrawFormattedText(w1,double(['A:',feword12]),xCenter,yCenter+8.5*font_size-355, black,[],[],[],2);  %位置变化500-100
        DrawFormattedText(w1,double(['B:',feword22]),xCenter,yCenter+8.5*font_size-255, black,[],[],[],2);%-70
        DrawFormattedText(w1,double(['C:',feword32]),xCenter,yCenter+8.5*font_size-155, red,[],[],[],2);%-40
        DrawFormattedText(w1,double(['D:',feword42]),xCenter,yCenter+8.5*font_size-55, black,[],[],[],2);%-10
        Screen('Flip',w1,[]);
        WaitSecs(1.5);  %呈现时间
    elseif ChangeCol(i) == 4
        DrawFormattedText(w1,double(['A:',feword12]),xCenter,yCenter+8.5*font_size-355, black,[],[],[],2);  %位置变化500-100
        DrawFormattedText(w1,double(['B:',feword22]),xCenter,yCenter+8.5*font_size-255, black,[],[],[],2);%-70
        DrawFormattedText(w1,double(['C:',feword32]),xCenter,yCenter+8.5*font_size-155, black,[],[],[],2);%-40
        DrawFormattedText(w1,double(['D:',feword42]),xCenter,yCenter+8.5*font_size-55, red,[],[],[],2);%-10
        Screen('Flip',w1,[]);
        WaitSecs(1.5);  %呈现时间
    elseif ChangeCol(i) ~= 1 && ChangeCol(i) ~= 2 && ChangeCol(i) ~= 3 && ChangeCol(i) ~= 4
        DrawFormattedText(w1,double(['A:',feword12]),xCenter,yCenter+8.5*font_size-355, black,[],[],[],2);  %位置变化500-100
        DrawFormattedText(w1,double(['B:',feword22]),xCenter,yCenter+8.5*font_size-255, black,[],[],[],2);%-70
        DrawFormattedText(w1,double(['C:',feword32]),xCenter,yCenter+8.5*font_size-155, black,[],[],[],2);%-40
        DrawFormattedText(w1,double(['D:',feword42]),xCenter,yCenter+8.5*font_size-55, black,[],[],[],2);%-10
        Screen('Flip',w1,[]);
        WaitSecs(1.5);  %呈现时间
    end
end