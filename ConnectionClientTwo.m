function [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42]=ConnectionClientTwo(u1)

u1.DatagramReceivedFcn = @instrcallback;%����u1���յ����ݰ�ʱ�����ûص�������ʾ

fopen(u1);%��udp���ӣ�ʵ���ϲ�û�����ӣ�udp�������ӵ�ͨ��Э�飩

CheckConnection12 = 0;
CheckConnection22 = 0;
CheckConnection32 = 0;
CheckConnection42 = 0;
CheckConnectionTwo=[CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42];  %
%%%%�������ӵ���
Check_onset = GetSecs;
while sum(CheckConnectionTwo)<4 %4
    fwrite(u1,1);
    
    CheckConnectionTwo=fread(u1,8);
    
    if sum(CheckConnectionTwo) == 4 %4
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