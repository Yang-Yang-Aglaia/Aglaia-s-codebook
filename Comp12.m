function [colori] = Comp12(raw_choseone,raw_chosetwo)
colori = [];
for ii = 1:4
    if raw_choseone(ii) == raw_chosetwo(ii)
        colori(ii) = 1;  %1Ϊ��ɫ
    else
        colori(ii) = 2;  %2Ϊ��ɫ
    end
end
