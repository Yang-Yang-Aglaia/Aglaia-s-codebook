Notes = 'Please enter host IPs'%%%%����client��IP��ַ
IP1 = '192.168.88.3';  %����3��IP
IPs={'Notes','IP1'};
defaultParameters = {Notes,IP1};
IPs=inputdlg(IPs,'IPs',1,defaultParameters);
IP1 = IPs{2};


u1=udp(IP1,'RemotePort',8811,'LocalPort',9090,'Timeout',90);%���ó��ڶ˿ں�Ϊ8811��8822��8888��8899ע����䲻Ҫ�ظ�
u1.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ

fopen(u1);%��udp���ӣ�ʵ���ϲ�û�����ӣ�udp�������ӵ�ͨ��Э�飩

CheckConnection1 = 0;
CheckConnection2 = 0;
CheckConnection3 = 0;
CheckConnection4 = 0;
CheckConnection=[CheckConnection1,CheckConnection2,CheckConnection3,CheckConnection4];  %
%%%%�������ӵ���
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