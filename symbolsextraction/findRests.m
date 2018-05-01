function [newSymbol]=findRests(symbol,spaceHeight,threshold,image)

newSymbol = [];
A=symbol;

%Find height of the object
y=A(1:2:end);
y=sort(y);
%Find width of the object
x=A(2:2:end);
x=sort(x);

newSymbol1=[y(1) y(end) x(1) x(end)];
a = min(newSymbol1(4)-threshold, size(image,2));
b = max(1,newSymbol1(3)+threshold);
w = a-b+1;

%Width
if w > spaceHeight && w < 6*spaceHeight
    c = min(newSymbol1(2)+threshold,size(image,1));
    d = max(1,newSymbol1(1)-threshold);
    h = c - d;
    newSymbol = [d c b a w h];
end



return