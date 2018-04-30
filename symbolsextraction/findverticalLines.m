function [newSymbol,flag]=findverticalLines(symbol,spaceHeight,th,threshold,image,barlines)

newSymbol = [];
A=symbol;

%Find height of the object
y=A(1:2:end);
y=sort(y);
%Find width of the object
x=A(2:2:end);
x=sort(x);


newSymbol1=[y(1) y(end) x(1) x(end)];
flag = 0;

% imshow(image(newSymbol1(1):newSymbol1(2),newSymbol1(3):newSymbol1(4)))


%Double bar
if length(find(barlines == 0)) ~= length(barlines)
    if newSymbol1(3)-barlines(3) < spaceHeight
        c = max(newSymbol1(2),barlines(2));
        d = min(newSymbol1(1),barlines(1));
        symbol = [d c min(newSymbol1(3),barlines(3)) max(newSymbol1(4),barlines(4))];
        h = c - d;
        %heigth
        if h>0.90*th
            newSymbol = [symbol(1) symbol(2) symbol(3) symbol(4) symbol(4)-symbol(3)  h];
            flag = 1;
        end
    else
        if newSymbol1(4) == size(image,2)
            a = newSymbol1(4);
        else
            a = min(newSymbol1(4)-threshold+1, size(image,2));
        end
        b = max(1,newSymbol1(3)+threshold);
        w = a-b+1;
        
        %Width
        if w > 1 && w < 0.90*spaceHeight
            c = min(newSymbol1(2)+threshold,size(image,1));
            d = max(1,newSymbol1(1)-threshold);
            h = c - d;
            %heigth
            if h>0.90*th
                newSymbol = [d c b a w h];
            end
        end
    end
    if size(newSymbol,1)~=0
        %Verificar se a barra dupla nao é uma nota
        if newSymbol(5) > 0.75*spaceHeight
            img = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
            img = img';         
            [runsblack]=numberBlackRuns(img,spaceHeight);
            if runsblack < 2
                newSymbol = [];
            end
        end
    end
else
    if newSymbol1(4) == size(image,2)
        a = newSymbol1(4);
        b = max(1,newSymbol1(3)+threshold);
    elseif newSymbol1(3) == 1
        a = min(newSymbol1(4)-threshold+1, size(image,2));
        b = newSymbol1(3);
    else
        a = min(newSymbol1(4)-threshold+1, size(image,2));
        b = max(1,newSymbol1(3)+threshold);
    end
    w = a-b+1;
    %Width
    if w > 1 && w < 0.75*spaceHeight
        c = min(newSymbol1(2)+threshold,size(image,1));
        d = max(1,newSymbol1(1)-threshold);
        h = c - d;
        %heigth
        if h>0.90*th
            newSymbol = [d c b a w h];
        end
    end
end

return