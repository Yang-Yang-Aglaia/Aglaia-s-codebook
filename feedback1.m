function [raw_chose1] = feedback1(w1,u1,xCenter,yCenter,font_size,black)
raw_chose1 = 0;
raw_chose1 = fread(u1,1); %��ȡ�������尴�������������ip�ж�
if raw_chose1 == 1
    feword = '��';
elseif raw_chose1 == 2
    feword = '��';
end

DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
DrawFormattedText(w1,double(['A:',feword]),xCenter-100,yCenter+8.5*font_size-400, black,[],[],[],2);  %λ�ñ仯
Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
Screen('Flip',w1,[]);
WaitSecs(1.5);  %����ʱ��