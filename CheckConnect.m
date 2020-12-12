
Notes = 'Please enter guest IPs';  %%%%����client��IP��ַ
IP2 = '192.168.88.101';   %����1��IP
IP3 = '192.168.88.2';  %����2��IP
IP4 = '192.168.88.4';  %����4��IP
IP5 = '192.168.88.6';  %����6��IP
IPs={'Notes','IP2','IP3','IP4','IP5'}; %
defaultParameters = {Notes,IP2,IP3,IP4,IP5};  %
IPs=inputdlg(IPs,'IPs',1,defaultParameters);
IP2 = IPs{2};
IP3 = IPs{3};
IP4 = IPs{4};
IP5 = IPs{5};


u1=udp(IP2,'RemotePort',9090,'LocalPort',8811,'Timeout',90);%��IPΪ222.20.36.185��Զ����������ʵ�����Լ���IP����Ҫ�����Լ��ģ�����udp��Զ�������˿�Ϊ8866�����������˿�Ϊ8844��
u2=udp(IP3,'RemotePort',9090,'LocalPort',8822,'Timeout',90);%ͬ��
u3=udp(IP4,'RemotePort',9090,'LocalPort',8888,'Timeout',90);
u4=udp(IP5,'RemotePort',9090,'LocalPort',8899,'Timeout',90);


u1.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u2.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u3.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u4.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ

fopen(u1);% fopen(u1) ��udp���ӣ�ʵ���ϲ�û�����ӣ�udp�������ӵ�ͨ��Э�飩
fopen(u2);%ͬ��
fopen(u3);
fopen(u4);

CheckConnection1 = 0;
CheckConnection2 = 0;
CheckConnection3 = 0;
CheckConnection4 = 0;
CheckConnection = [CheckConnection1,CheckConnection2,CheckConnection3,CheckConnection4];  %
%%%%�������ӵ���
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