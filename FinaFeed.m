%% ����Ⱥ��ѡ��
function [raw_chose_leader]=FinaFeed(w1,u1,xCenter,yCenter,font_size,black)
% ����������ѡ��

DrawFormattedText(w1,double('��ȴ����վ���'),'Center',yCenter+250,1,[],[],[],2);
Screen('Flip', w1);
WaitSecs(1.5);

raw_chose_leader = 0;
raw_chose_leader=fread(u1,1);  %Read binary data�����������ݣ� from file
if raw_chose_leader == 1
    feedword = '��';
    
elseif raw_chose_leader == 2
    feedword = '��';
end

DrawFormattedText(w1,double('�Ŷ�����ѡ��'),'Center',yCenter-100,1,[],[],[],2);
DrawFormattedText(w1,feedword,xCenter,yCenter+8.5*font_size+100, black,[],[],[],2);  %λ�ñ仯500
Screen('Flip', w1);
WaitSecs(1.5);

%                 DrawFormattedText(w1,double('������ѡ�����:'),xCenter-130,yCenter+8.5*font_size-500, black,[],[],[],2);
%                 DrawFormattedText(w1,double(['A:',num2str(raw_chose1)]),xCenter-130,yCenter+8.5*font_size-490, black,[],[],[],2);  %λ�ñ仯500
%                 DrawFormattedText(w1,double(['B:',num2str(raw_chose2)]),xCenter-130,yCenter+8.5*font_size-480, black,[],[],[],2);
%                 DrawFormattedText(w1,double(['C:',num2str(raw_chose3)]),xCenter-130,yCenter+8.5*font_size-470, black,[],[],[],2);
%                 DrawFormattedText(w1,double(['D:',num2str(raw_chose4)]),xCenter-130,yCenter+8.5*font_size-460, black,[],[],[],2);
%DrawFormattedText(w1,double(num2str(total_score)),xCenter+20,yCenter+8.5*font_size-500, black,[],[],[],2);
%Screen('FrameRect', w1, black, [xCenter-675 yCenter-150 xCenter-465 yCenter+150],[1]);
%Screen('Flip',w1,[]);
%WaitSecs(1.5);  %����ʱ��