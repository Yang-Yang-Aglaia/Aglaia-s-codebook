
Notes = 'Please enter guest IPs';  %%%%输入client的IP地址
IP2 = '192.168.88.101';   %电脑1的IP
IP3 = '192.168.88.2';  %电脑2的IP
IP4 = '192.168.88.4';  %电脑4的IP
IP5 = '192.168.88.6';  %电脑6的IP
IPs={'Notes','IP2','IP3','IP4','IP5'}; %
defaultParameters = {Notes,IP2,IP3,IP4,IP5};  %
IPs=inputdlg(IPs,'IPs',1,defaultParameters);
IP2 = IPs{2};
IP3 = IPs{3};
IP4 = IPs{4};
IP5 = IPs{5};


u1=udp(IP2,'RemotePort',9090,'LocalPort',8811,'Timeout',90);%与IP为222.20.36.185的远程主机（其实是我自己的IP，需要换成自己的）建立udp，远程主机端口为8866，本地主机端口为8844。
u2=udp(IP3,'RemotePort',9090,'LocalPort',8822,'Timeout',90);%同上
u3=udp(IP4,'RemotePort',9090,'LocalPort',8888,'Timeout',90);
u4=udp(IP5,'RemotePort',9090,'LocalPort',8899,'Timeout',90);


u1.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u2.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u3.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示
u4.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示

fopen(u1);% fopen(u1) 打开udp连接（实际上并没有连接，udp是无连接的通信协议）
fopen(u2);%同上
fopen(u3);
fopen(u4);

CheckConnection1 = 0;
CheckConnection2 = 0;
CheckConnection3 = 0;
CheckConnection4 = 0;
CheckConnection = [CheckConnection1,CheckConnection2,CheckConnection3,CheckConnection4];  %
%%%%网络连接调试
Check_onset=GetSecs;

while sum(CheckConnection)<4  %4
    CheckConnection1=fread(u1,1);
    CheckConnection2=fread(u2,1);
    CheckConnection3=fread(u3,1);
    CheckConnection4=fread(u4,1);
    
    
    CheckConnection = [CheckConnection1,CheckConnection2,CheckConnection3,CheckConnection4];  %
    
    fwrite(u1,[CheckConnection]);
    fwrite(u2,[CheckConnection]);
    fwrite(u3,[CheckConnection]);
    fwrite(u4,[CheckConnection]);
    %WaitSecs(1);
    
    if sum(CheckConnection) == 4  %4
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