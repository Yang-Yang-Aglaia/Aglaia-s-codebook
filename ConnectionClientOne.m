%% ��������
function [u1,CheckConnectionOne,CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41]=ConnectionClientOne(w1,IP1)
%%%����������������
DrawFormattedText(w1,double('���������У����Ժ� >>>'),'center','center',1, [],[],[],2);
Screen('Flip', w1);
WaitSecs(2);

u1=udp(IP1,'RemotePort',8811,'LocalPort',9090,'Timeout',120);%���ó��ڶ˿ں�Ϊ8811��8822��8888��8899ע����䲻Ҫ�ظ�
u1.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ

fopen(u1);%��udp���ӣ�ʵ���ϲ�û�����ӣ�udp�������ӵ�ͨ��Э�飩

CheckConnection11 = 0;
CheckConnection21 = 0;
CheckConnection31 = 0;
CheckConnection41 = 0;
CheckConnectionOne=[CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41];  %
%%%%�������ӵ���
Check_onset = GetSecs;
while sum(CheckConnectionOne)<4 %4
    fwrite(u1,1);
    
    CheckConnectionOne=fread(u1,8);
    
    if sum(CheckConnectionOne) == 4 %4
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

DrawFormattedText(w1,double('��ϲ�����ӳɹ���'),'center','center',1, [],[],[],2);
Screen('Flip',w1,[]);
WaitSecs(2);