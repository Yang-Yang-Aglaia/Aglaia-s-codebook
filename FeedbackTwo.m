function [raw_chosetwo,raw_chose12,raw_chose22,raw_chose32,raw_chose42]=FeedbackTwo(w1,u1,u2,u3,u4,xCenter,yCenter,font_size,black)
%��ʼ��
raw_chose12 = 0;
raw_chose22 = 0;
raw_chose32 = 0;
raw_chose42 = 0;


% ��һ�ε������Ƶ�ѡ��
raw_chose12=fread(u1,1); %��ȡ�������尴�������������ip�ж�
raw_chose22=fread(u2,1);
raw_chose32=fread(u3,1);
raw_chose42=fread(u4,1);
raw_chosetwo = [raw_chose12,raw_chose22,raw_chose32,raw_chose42];
%raw_chosetwo = raw_choseone;
%                     switch num2str(raw_chose)
%                         case raw_chose1 == '1'
%                             feword1 = '��';
%                         case raw_chose1 =='2'
%                             feword1 = '��';
%                         case raw_chose2 =='1'
%                             feword2 = '��';
%                         case raw_chose2 =='2'
%                             feword2 = '��';
%                         case raw_chose3 =='1'
%                             feword3 = '��';
%                         case raw_chose3 =='2'
%                             feword3 = '��';
%                         case raw_chose4 =='1'
%                             feword4 = '��';
%                         case raw_chose4 =='2'
%                             feword4 = '��';
%                     end
raw_chose1= raw_chose12;
raw_chose2= raw_chose22;
raw_chose3= raw_chose32;
raw_chose4= raw_chose42;
[feword1,feword2,feword3,feword4] = JudgeInformation(raw_chose1,raw_chose2,raw_chose3,raw_chose4);  %������ת��Ϊ����
feword12 = feword1;
feword22 = feword2;
feword32 = feword3;
feword42 = feword4;
DrawFormattedText(w1,double('������ѡ�����:'),xCenter,yCenter+8.5*font_size-455, black,[],[],[],2);
DrawFormattedText(w1,double(['A:',feword12]),xCenter,yCenter+8.5*font_size-355, black,[],[],[],2);  %λ�ñ仯500-100
DrawFormattedText(w1,double(['B:',feword22]),xCenter,yCenter+8.5*font_size-255, black,[],[],[],2);%-70
DrawFormattedText(w1,double(['C:',feword32]),xCenter,yCenter+8.5*font_size-155, black,[],[],[],2);%-40
DrawFormattedText(w1,double(['D:',feword42]),xCenter,yCenter+8.5*font_size-55, black,[],[],[],2);%-10
%DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
%Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
Screen('Flip',w1,[]);
WaitSecs(1.5);  %����ʱ��