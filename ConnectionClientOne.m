%% 检验连结
function [u1,CheckConnectionOne,CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41]=ConnectionClientOne(w1,IP1)
%%%设置网络连接属性
DrawFormattedText(w1,double('设置连接中，请稍候 >>>'),'center','center',1, [],[],[],2);
Screen('Flip', w1);
WaitSecs(2);

u1=udp(IP1,'RemotePort',8811,'LocalPort',9090,'Timeout',120);%可用出口端口号为8811，8822，8888，8899注意分配不要重复
u1.DatagramReceivedFcn = @instrcallback;%设置u1接收到数据包时，调用回调函数显示

fopen(u1);%打开udp连接（实际上并没有连接，udp是无连接的通信协议）

CheckConnection11 = 0;
CheckConnection21 = 0;
CheckConnection31 = 0;
CheckConnection41 = 0;
CheckConnectionOne=[CheckConnection11,CheckConnection21,CheckConnection31,CheckConnection41];  %
%%%%网络连接调试
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

DrawFormattedText(w1,double('恭喜，连接成功！'),'center','center',1, [],[],[],2);
Screen('Flip',w1,[]);
WaitSecs(2);