function [raw_choseone,raw_chose11,raw_chose21,raw_chose31,raw_chose41]=FeedbackOne(w1,u1,u2,u3,u4,xCenter,yCenter,font_size,black)

%��ʼ��
raw_chose11 = 0;
raw_chose21 = 0;
raw_chose31 = 0;
raw_chose41 = 0;


% ��һ�ε������Ƶ�ѡ��
raw_chose11 = fread(u1,1); %��ȡ�������尴�������������ip�ж�
raw_chose21 = fread(u2,1);
raw_chose31 = fread(u3,1);
raw_chose41 = fread(u4,1);
raw_choseone = [raw_chose11,raw_chose21,raw_chose31,raw_chose41];

raw_chose1 = raw_chose11;
raw_chose2 = raw_chose21;
raw_chose3 = raw_chose31;
raw_chose4 = raw_chose41;

[feword1,feword2,feword3,feword4] = JudgeInformation(raw_chose1,raw_chose2,raw_chose3,raw_chose4);  %������ת��Ϊ����

feword11 = feword1;
feword21 = feword2;
feword31 = feword3;
feword41 = feword4;
DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
DrawFormattedText(w1,double(['A:',feword11]),xCenter-100,yCenter+8.5*font_size-450, black,[],[],[],2);  %λ�ñ仯500
DrawFormattedText(w1,double(['B:',feword21]),xCenter-70,yCenter+8.5*font_size-400, black,[],[],[],2);
DrawFormattedText(w1,double(['C:',feword31]),xCenter-40,yCenter+8.5*font_size-350, black,[],[],[],2);
DrawFormattedText(w1,double(['D:',feword41]),xCenter-10,yCenter+8.5*font_size-300, black,[],[],[],2);
%DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
%Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
Screen('Flip',w1,[]);
WaitSecs(1.5);  %����ʱ��