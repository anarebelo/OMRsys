function simplifieddistance=simplifiedAvgDistance(newX,newY,newNextX,newNextY)
m=max(newX(1),newNextX(1));
M=min(newX(end),newNextX(end));

idx1=1;
idx2=1;
simplifieddistance=0;
if m>M
    simplifieddistance=-1;
end
while newX(idx1)~=m
    idx1=idx1+1;
end
while newNextX(idx2)~=m
    idx2=idx2+1;
end

while newX(idx1)~=M
    dy=abs(newY(idx1)-newNextY(idx2));
    simplifieddistance=simplifieddistance+dy;
    idx1=idx1+1;
    idx2=idx2+1;
end

simplifieddistance=simplifieddistance/(M-m+1);