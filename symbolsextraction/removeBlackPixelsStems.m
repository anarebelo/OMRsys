
function [imgWithoutStem]=removeBlackPixelsStems(imgWithoutStem,stem,value)

for i=1:size(stem,2)
    A = cell2mat(stem(i));
    a = max(1,A(3)-value);
    b = min(A(3)+value,size(imgWithoutStem,2));
    imgWithoutStem(A(1):A(2),a:b) = 1;
end