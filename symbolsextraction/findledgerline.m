function numberledgerline = findledgerline(valuestaffline,valuesymbol,spaceHeight)

numberledgerline = [];
diference = valuestaffline - valuesymbol;

%Up ledger lines
if diference > 0
    if diference > spaceHeight/3 & diference <= spaceHeight/3+spaceHeight/2
        numberledgerline = -1;
    elseif diference > spaceHeight-3 & diference <= spaceHeight+3
        numberledgerline = -2;
    elseif diference > spaceHeight+spaceHeight/3 & diference <= spaceHeight+5/6*spaceHeight
        numberledgerline = -3;
    elseif diference > 2*spaceHeight-3 & diference <= spaceHeight*2+3
        numberledgerline = -4;
    elseif diference > 2*spaceHeight & diference <= spaceHeight*3
        numberledgerline = -5;
    elseif diference > 3*spaceHeight-3 & diference <= 4*spaceHeight
        numberledgerline = -6;
    elseif diference > 4*spaceHeight-3 & diference <= 4*spaceHeight+spaceHeight
        numberledgerline = -7;
    end
    %Down ledger lines
else
    diference = abs(diference);
    if diference > spaceHeight/3 & diference <= spaceHeight/3+spaceHeight/2
        numberledgerline = 6;
    elseif diference > spaceHeight-3 & diference <= spaceHeight+3
        numberledgerline = 7;
    elseif diference > spaceHeight+spaceHeight/3 & diference <= spaceHeight+5/6*spaceHeight
        numberledgerline = 8;
    elseif diference > 2*spaceHeight-3 & diference <= spaceHeight*2+3
        numberledgerline = 9;
    elseif diference > 2*spaceHeight & diference <= spaceHeight*3
        numberledgerline = 10;
    elseif diference > 3*spaceHeight-3 & diference <= 4*spaceHeight
        numberledgerline = 11;
    elseif diference > 4*spaceHeight-3 & diference <= 4*spaceHeight+spaceHeight
        numberledgerline = 12;
    end
end