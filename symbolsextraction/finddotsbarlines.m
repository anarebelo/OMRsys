function [newSymbol]=finddotsbarlines(symbol,spaceHeight,threshold,image,flag)

newSymbol = [];
A=symbol;

%Find height of the object
y=A(1:2:end);
y=sort(y);
%Find width of the object
x=A(2:2:end);
x=sort(x);


newSymbol1=[y(1) y(end) x(1) x(end)];
a = newSymbol1(4);
b = newSymbol1(3);
if flag == 0
    if newSymbol1(4) == size(image,2)
        a = newSymbol1(4);
    else
        a = min(newSymbol1(4)-threshold, size(image,2));
    end
else
    b = max(1,newSymbol1(3)+threshold);
end
w = a-b+1;

%Width
if w > 1 && w < 0.75*spaceHeight
    c = min(newSymbol1(2)+threshold,size(image,1));
    d = max(1,newSymbol1(1)-threshold);
    h = c - d;
    %heigth
    if h<3*spaceHeight
        newSymbol = [d c b a w h];
    end
end

return