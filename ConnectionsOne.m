function [u1,u2,u3,u4,CheckConnectionOne,CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41] = ConnectionsOne(w1,IP2,IP3,IP4,IP5)
%%  �豸����
%%%%׼�����ӵ���������
word = double('���������У����Ժ� >>>');
DrawFormattedText(w1,word,'center','center',1, [],[],[],2);
Screen('Flip', w1);
WaitSecs(2);

%����о���Ҫ����
u1=udp(IP2,'RemotePort',9090,'LocalPort',8811,'Timeout',120);%��IPΪ222.20.36.185��Զ����������ʵ�����Լ���IP����Ҫ�����Լ��ģ�����udp��Զ�������˿�Ϊ8866�����������˿�Ϊ8844��
u2=udp(IP3,'RemotePort',9090,'LocalPort',8822,'Timeout',120);%ͬ��
u3=udp(IP4,'RemotePort',9090,'LocalPort',8888,'Timeout',120);
u4=udp(IP5,'RemotePort',9090,'LocalPort',8899,'Timeout',120);


u1.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u2.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u3.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ
u4.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ

fopen(u1);% fopen(u1) ��udp���ӣ�ʵ���ϲ�û�����ӣ�udp�������ӵ�ͨ��Э�飩
fopen(u2);%ͬ��
fopen(u3);
fopen(u4);

CheckConnection11 = 0;
CheckConnection21 = 0;
CheckConnection31 = 0;
CheckConnection41 = 0;
CheckConnectionOne = [CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41];  %
%%%%�������ӵ���
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
DrawFormattedText(w1,double('��ϲ�����ӳɹ���'),'center','center',1, [],[],[],2);
Screen('Flip',w1,[]);
WaitSecs(2);