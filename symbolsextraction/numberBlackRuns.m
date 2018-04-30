%%
function [runsblack]=numberBlackRuns(img,spaceHeight)

numberRunsblack=[];

for i=1:size(img, 2)
    x=img(:,i)';
    len = rle(x);
    
    numberRunsblack = [numberRunsblack length(len(2:2:end))];
end
runsblack = max(numberRunsblack);

positionMax = find(numberRunsblack==runsblack);
%Verificar se o máximo é o valor que mais se repete.
if length(positionMax) < round(spaceHeight/2)
    numberRunsblack(positionMax) = []; 
    runsblack = max(numberRunsblack);
    positionMax = find(numberRunsblack==runsblack);
    if length(positionMax) >= round(spaceHeight*0.45)
        return
    else
        runsblack = inf;
    end
end