function [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectTwo(u1,u2,u3,u4)
% u1=udp(IP2,'RemotePort',9090,'LocalPort',8811,'Timeout',90);%与IP为222.20.36.185的远程主机（其实是我自己的IP，需要换成自己的）建立udp，远程主机端口为8866，本地主机端口为8844。
% u2=udp(IP3,'RemotePort',9090,'LocalPort',8822,'Timeout',90);%同上
% u3=udp(IP4,'RemotePort',9090,'LocalPort',8888,'Timeout',90);
% u4=udp(IP5,'RemotePort',9090,'LocalPort',8899,'Timeout',90);


u1.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u2.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u3.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u4.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示

fopen(u1);% fopen(u1) 打开udp连接（实际上并没有连接，udp是无连接的通信协议）
fopen(u2);%同上
fopen(u3);
fopen(u4);

CheckConnection12 = 0;
CheckConnection22 = 0;
CheckConnection32 = 0;
CheckConnection42 = 0;
CheckConnectionTwo = [CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42];  %
%%%%网络连接调试
Check_onset=GetSecs;

while sum(CheckConnectionTwo)<4  %4
    CheckConnection12=fread(u1,1);
    CheckConnection22=fread(u2,1);
    CheckConnection32=fread(u3,1);
    CheckConnection42=fread(u4,1);
    
    
    CheckConnectionTwo = [CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42];  %
    
    fwrite(u1,[CheckConnectionTwo]);
    fwrite(u2,[CheckConnectionTwo]);
    fwrite(u3,[CheckConnectionTwo]);
    fwrite(u4,[CheckConnectionTwo]);
    %WaitSecs(1);
    
    if sum(CheckConnectionTwo) == 4  %4
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