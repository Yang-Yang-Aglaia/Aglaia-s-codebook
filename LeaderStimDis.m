function LeaderStimDis(w1,xCenter,yCenter,font_size)
Bigword = double('大');
Smallword = double('小');
DrawFormattedText(w1,double('请代表你的团队做出选择'),'Center',yCenter+250,1,[],[],[],2);
DrawFormattedText(w1,Bigword,xCenter-200 ,yCenter+8.5*font_size-100, 1, [],[],[],2);
DrawFormattedText(w1,Smallword,xCenter-100 ,yCenter+8.5*font_size-100, 1, [],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);