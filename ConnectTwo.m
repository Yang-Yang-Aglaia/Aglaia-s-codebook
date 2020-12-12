function [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42] = ConnectTwo(u1,u2,u3,u4)
% u1=udp(IP2,'RemotePort',9090,'LocalPort',8811,'Timeout',90);%��IPΪ222.20.36.185��Զ����������ʵ�����Լ���IP����Ҫ�����Լ��ģ�����udp��Զ�������˿�Ϊ8866�����������˿�Ϊ8844��
% u2=udp(IP3,'RemotePort',9090,'LocalPort',8822,'Timeout',90);%ͬ��
% u3=udp(IP4,'RemotePort',9090,'LocalPort',8888,'Timeout',90);
% u4=udp(IP5,'RemotePort',9090,'LocalPort',8899,'Timeout',90);


u1.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u2.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u3.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u4.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ

fopen(u1);% fopen(u1) ��udp���ӣ�ʵ���ϲ�û�����ӣ�udp�������ӵ�ͨ��Э�飩
fopen(u2);%ͬ��
fopen(u3);
fopen(u4);

CheckConnection12 = 0;
CheckConnection22 = 0;
CheckConnection32 = 0;
CheckConnection42 = 0;
CheckConnectionTwo = [CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42];  %
%%%%�������ӵ���
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