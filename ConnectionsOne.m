function [u1,u2,u3,u4,CheckConnectionOne,CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41] = ConnectionsOne(w1,IP2,IP3,IP4,IP5)
%%  设备连接
%%%%准备链接的属性设置
word = double('设置连接中，请稍候 >>>');
DrawFormattedText(w1,word,'center','center',1, [],[],[],2);
Screen('Flip', w1);
WaitSecs(2);

%这个感觉需要更改
u1=udp(IP2,'RemotePort',9090,'LocalPort',8811,'Timeout',120);%与IP为222.20.36.185的远程主机（其实是我自己的IP，需要换成自己的）建立udp，远程主机端口为8866，本地主机端口为8844。
u2=udp(IP3,'RemotePort',9090,'LocalPort',8822,'Timeout',120);%同上
u3=udp(IP4,'RemotePort',9090,'LocalPort',8888,'Timeout',120);
u4=udp(IP5,'RemotePort',9090,'LocalPort',8899,'Timeout',120);


u1.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u2.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u3.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u4.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示

fopen(u1);% fopen(u1) 打开udp连接（实际上并没有连接，udp是无连接的通信协议）
fopen(u2);%同上
fopen(u3);
fopen(u4);

CheckConnection11 = 0;
CheckConnection21 = 0;
CheckConnection31 = 0;
CheckConnection41 = 0;
CheckConnectionOne = [CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41];  %
%%%%网络连接调试
Check_onset=GetSecs;

while sum(CheckConnectionOne)<4  %4
    CheckConnection11=fread(u1,1);
    CheckConnection21=fread(u2,1);
    CheckConnection31=fread(u3,1);
    CheckConnection41=fread(u4,1);
    
    
    CheckConnectionOne = [CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41];  %
    
    fwrite(u1,[CheckConnectionOne]);
    fwrite(u2,[CheckConnectionOne]);
    fwrite(u3,[CheckConnectionOne]);
    fwrite(u4,[CheckConnectionOne]);
    %WaitSecs(1);
    
    if sum(CheckConnectionOne) == 4  %4
        break
    end
    
    Check_RT=GetSecs-Check_onset;
    if Check_RT>60
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        error('connection timeout!');
    end
end
DrawFormattedText(w1,double('恭喜，连接成功！'),'center','center',1, [],[],[],2);
Screen('Flip',w1,[]);
WaitSecs(2);