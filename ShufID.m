function [x1]=ShufID(xCenter)
subIDe=Shuffle([1 2]); %这是想干嘛？评分的那个嘛？
if  subIDe(1) == 1 %%%浮标起始值判定
    x1 = xCenter-235;
else
    x1 = xCenter+220;
end