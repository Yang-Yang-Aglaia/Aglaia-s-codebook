function StimClientDis(w1,xCenter,yCenter)
yesword = double('是');
noword = double('否');
DrawFormattedText(w1,double('您是否更改自己的决定'),'Center',yCenter-100,1,[],[],[],2);
DrawFormattedText(w1,yesword,xCenter-100,yCenter+100,1,[],[],[],2);
DrawFormattedText(w1,noword,xCenter+100,yCenter+100,1,[],[],[],2);
Screen(w1, 'TextSize', 30);
Screen('Flip',w1);