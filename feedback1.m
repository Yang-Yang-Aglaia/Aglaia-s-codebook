function feedback()
%初始化
raw_chose1 = 0;
raw_chose2 = 0;
raw_chose3 = 0;
raw_chose4 = 0;


% 第一次点数估计的选择
raw_chose1=fread(u1,1); %读取单个个体按键，依据输入的ip判断
raw_chose2=fread(u2,1);
raw_chose3=fread(u3,1);
raw_chose4=fread(u4,1);
raw_choseone = [raw_chose1,raw_chose2,raw_chose3,raw_chose4];
%                     switch num2str(raw_chose)
%                         case raw_chose1 == '1'
%                             feword1 = '多';
%                         case raw_chose1 =='2'
%                             feword1 = '少';
%                         case raw_chose2 =='1'
%                             feword2 = '多';
%                         case raw_chose2 =='2'
%                             feword2 = '少';
%                         case raw_chose3 =='1'
%                             feword3 = '多';
%                         case raw_chose3 =='2'
%                             feword3 = '少';
%                         case raw_chose4 =='1'
%                             feword4 = '多';
%                         case raw_chose4 =='2'
%                             feword4 = '少';
%                     end
JudgeInformation(raw_chose1,raw_chose2,raw_chose3,raw_chose4);  %将数字转换为文字
DrawFormattedText(w1,double('其他人选择情况:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
DrawFormattedText(w1,double(['A:',feword1]),xCenter-100,yCenter+8.5*font_size-450, black,[],[],[],2);  %位置变化500
DrawFormattedText(w1,double(['B:',feword2]),xCenter-70,yCenter+8.5*font_size-400, black,[],[],[],2);
DrawFormattedText(w1,double(['C:',feword3]),xCenter-40,yCenter+8.5*font_size-350, black,[],[],[],2);
DrawFormattedText(w1,double(['D:',feword4]),xCenter-10,yCenter+8.5*font_size-300, black,[],[],[],2);
%DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
%Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
Screen('Flip',w1,[]);
WaitSecs(1.5);  %呈现时间