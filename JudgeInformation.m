function [feword1,feword2,feword3,feword4] = JudgeInformation(raw_chose1,raw_chose2,raw_chose3,raw_chose4)
if raw_chose1 == 1
    feword1 = '多';
else
    feword1 = '少';
end
if raw_chose2 == 1
    feword2 = '多';
else
    feword2 = '少';
end
if raw_chose3 == 1
    feword3 = '多';
else
    feword3 = '少';
end
if raw_chose4 == 1
    feword4 = '多';
else
    feword4 = '少';
end
