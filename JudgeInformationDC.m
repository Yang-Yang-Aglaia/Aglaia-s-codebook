function [feword1,feword2,feword3,feword4,feword5] = JudgeInformationDC(raw_chose1,raw_chose2,raw_chose3,raw_chose4,raw_chose_leader)
if raw_chose1 == 1
    feword1 = '多';
elseif raw_chose1 == 2
    feword1 = '少';
end
if raw_chose2 == 1
    feword2 = '多';
elseif raw_chose2 == 2
    feword2 = '少';
end
if raw_chose3 == 1
    feword3 = '多';
elseif raw_chose3 == 2
    feword3 = '少';
end
if raw_chose4 == 1
    feword4 = '多';
elseif raw_chose4 == 2
    feword4 = '少';
end
if raw_chose_leader == 1
    feword5 = '多';
elseif raw_chose4 == 2
    feword5 = '少';
end