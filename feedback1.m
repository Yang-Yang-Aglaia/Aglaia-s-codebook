function [raw_chosesum] = feedback1DC(w1,u1,xCenter,yCenter,font_size,black)
raw_chosesum = 0;
raw_chosesum = fread(u1,5); %��ȡ�������尴�������������ip�ж�
% for iii = 1:5
%     if raw_chosesum(ii) == 1
%         feword(ii) = '��';
%     elseif raw_chosesum(ii) == 2
%         feword(ii) = '��';
%     end
% end
raw_chose1 = raw_chosesum(1);
raw_chose2 = raw_chosesum(2);
raw_chose3 = raw_chosesum(3);
raw_chose4 = raw_chosesum(4);
raw_chose_lead = raw_chosesum(5);

[feword1,feword2,feword3,feword4,feword5] = JudgeInformationDC(raw_chose1,raw_chose2,raw_chose3,raw_chose4,raw_chose_lead);  %������ת��Ϊ����

feword11 = feword1;
feword21 = feword2;
feword31 = feword3;
feword41 = feword4;
feword51 = feword5;
DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
DrawFormattedText(w1,double(['A:',feword11]),xCenter-100,yCenter+8.5*font_size-450, black,[],[],[],2);  %λ�ñ仯500
DrawFormattedText(w1,double(['B:',feword21]),xCenter-70,yCenter+8.5*font_size-400, black,[],[],[],2);
DrawFormattedText(w1,double(['C:',feword31]),xCenter-40,yCenter+8.5*font_size-350, black,[],[],[],2);
DrawFormattedText(w1,double(['D:',feword41]),xCenter-10,yCenter+8.5*font_size-300, black,[],[],[],2);
DrawFormattedText(w1,double(['�쵼��:',feword51]),xCenter-100,yCenter+8.5*font_size-400, black,[],[],[],2);  %λ�ñ仯
Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
Screen('Flip',w1,[]);
WaitSecs(1.5);  %����ʱ��