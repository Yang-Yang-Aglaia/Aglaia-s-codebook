function [raw_chose1] = feedback1(w1,u1,xCenter,yCenter,font_size,black)
raw_chose1 = 0;
raw_chose1 = fread(u1,1); %读取单个个体按键，依据输入的ip判断
if raw_chose1 == 1
    feword = '多';
elseif raw_chose1 == 2
    feword = '少';
end

DrawFormattedText(w1,double('其他人选择情况:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
DrawFormattedText(w1,double(['A:',feword]),xCenter-100,yCenter+8.5*font_size-400, black,[],[],[],2);  %位置变化
Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
Screen('Flip',w1,[]);
WaitSecs(1.5);  %呈现时间