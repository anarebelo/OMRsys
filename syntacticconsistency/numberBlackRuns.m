%%
function [runsblack]=numberBlackRuns(img,spaceHeight)

numberRunsblack=[];

for i=1:size(img, 2)
    x=img(:,i)';
    len = rle(x);
    
    numberRunsblack = [numberRunsblack length(len(2:2:end))];
end
a = length(find(numberRunsblack==1));
b = length(find(numberRunsblack==2));
c = length(find(numberRunsblack==3));
d = length(find(numberRunsblack==4));

[~,runsblack]=max([a,b,c,d]);

