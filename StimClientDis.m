function StimClientDis(w1,xCenter,yCenter)
yesword = double('��');
noword = double('��');
DrawFormattedText(w1,double('���Ƿ�����Լ��ľ���'),'Center',yCenter-100,1,[],[],[],2);
DrawFormattedText(w1,yesword,xCenter-100,yCenter+100,1,[],[],[],2);
DrawFormattedText(w1,noword,xCenter+100,yCenter+100,1,[],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);