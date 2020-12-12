function [raw_chosesum2] = OthersFeed(w1,xCenter,yCenter,u1,font_size,black,raw_chosesum1)
DrawFormattedText(w1,double('请等待他人第二次选择结果>>>'),'Center',yCenter+250,1,[],[],[],2);
Screen('Flip', w1);
WaitSecs(1.5);

raw_chosesum2 = 0;
raw_chosesum2=fread(u1,4);  %Read binary data（二进制数据） from file

[colori] = Comp12(raw_chosesum1,raw_chosesum2);
ChangeCol= find(colori == 2);
% if raw_chose_sum2 == 1
%     feedword = '多';
%     
% elseif raw_chose_sum2 == 2
%     feedword = '少';
% end
raw_chose1 = raw_chosesum2(1);
raw_chose2 = raw_chosesum2(2);
raw_chose3 = raw_chosesum2(3);
raw_chose4 = raw_chosesum2(4);

[feword1,feword2,feword3,feword4] = JudgeInformation(raw_chose1,raw_chose2,raw_chose3,raw_chose4);  %将数字转换为文字

feword11 = feword1;
feword21 = feword2;
feword31 = feword3;
feword41 = feword4;
if isempty(ChangeCol) 
    DrawFormattedText(w1,double('其他人选择情况:'),xCenter,yCenter+8.5*font_size-455, black,[],[],[],2);
    DrawFormattedText(w1,double(['A:',feword12]),xCenter,yCenter+8.5*font_size-355, black,[],[],[],2);  %位置变化500-100
    DrawFormattedText(w1,double(['B:',feword22]),xCenter,yCenter+8.5*font_size-255, black,[],[],[],2);%-70
    DrawFormattedText(w1,double(['C:',feword32]),xCenter,yCenter+8.5*font_size-155, black,[],[],[],2);%-40
    DrawFormattedText(w1,double(['D:',feword42]),xCenter,yCenter+8.5*font_size-55, black,[],[],[],2);%-10
    %DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
    %Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
    Screen('Flip',w1,[]);
    WaitSecs(1.5);  %呈现时间
else
    DisCol(w1,ChangeCol,red,black,feword12,feword22,feword32,feword42,xCenter,yCenter,font_size);
end