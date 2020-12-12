function [CheckConnectionTwo,CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42]=ConnectionClientTwo(u1)

u1.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示

fopen(u1);%打开udp连接（实际上并没有连接，udp是无连接的通信协议）

CheckConnection12 = 0;
CheckConnection22 = 0;
CheckConnection32 = 0;
CheckConnection42 = 0;
CheckConnectionTwo=[CheckConnection12,CheckConnection22,CheckConnection32,CheckConnection42];  %
%%%%网络连接调试
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