function LeaderStimDis(w1,xCenter,yCenter,font_size)
Bigword = double('��');
Smallword = double('С');
DrawFormattedText(w1,double('���������Ŷ�����ѡ��'),'Center',yCenter+250,1,[],[],[],2);
DrawFormattedText(w1,Bigword,xCenter-200 ,yCenter+8.5*font_size-100, 1, [],[],[],2);
DrawFormattedText(w1,Smallword,xCenter-100 ,yCenter+8.5*font_size-100, 1, [],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);