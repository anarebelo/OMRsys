function [spaceHeight, lineHeight]= getStaffInfo(image)

runswhite=[];
runsblack=[];

for i=1:size(image, 2)
    x=image(:,i)';
    len = rle(x);
    runswhite = [runswhite len(1:2:end)] ;
    runsblack = [runsblack len(2:2:end)];
end


[m,spaceHeight] = max(hist(runswhite, 1:max(runswhite)));
[m,lineHeight] = max(hist(runsblack, 1:max(runsblack)));