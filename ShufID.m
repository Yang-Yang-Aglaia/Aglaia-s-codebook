function [x1]=ShufID(xCenter)
subIDe=Shuffle([1 2]); %�����������ֵ��Ǹ��
if  subIDe(1) == 1 %%%������ʼֵ�ж�
    x1 = xCenter-235;
else
    x1 = xCenter+220;
end