Notes = 'Please enter host IPs'%%%%输入client的IP地址
IP1 = '192.168.88.3';  %电脑3的IP
IPs={'Notes','IP1'};
defaultParameters = {Notes,IP1};
IPs=inputdlg(IPs,'IPs',1,defaultParameters);
IP1 = IPs{2};


u1=udp(IP1,'RemotePort',8811,'LocalPort',9090,'Timeout',90);%可用出口端口号为8811，8822，8888，8899注意分配不要重复
u1.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示

fopen(u1);%打开udp连接（实际上并没有连接，udp是无连接的通信协议）

CheckConnection1 = 0;
CheckConnection2 = 0;
CheckConnection3 = 0;
CheckConnection4 = 0;
CheckConnection=[CheckConnection1,CheckConnection2,CheckConnection3,CheckConnection4];  %
%%%%网络连接调试
Check_onset = GetSecs;
while sum(CheckConnection)<4 %4
    fwrite(u1,1);
    
    CheckConnection=fread(u1,8);
    
    if sum(CheckConnection) == 4 %4
        break
    end
    
    Check_RT = GetSecs - Check_onset;
    if Check_RT>60
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        error('connection timeout!');
    end
end