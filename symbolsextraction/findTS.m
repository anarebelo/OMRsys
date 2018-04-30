function [newSymbol]=findTS(symbol,spaceHeight)

newSymbol = [];
A=symbol;

%Find height of the object
y=A(1:2:end);
y=sort(y);
h=y(end)-y(1)+1;
%Find width of the object
x=A(2:2:end);
x=sort(x);
w=x(end)-x(1)+1;

%Width
if w > spaceHeight 
    newSymbol=[y(1) y(end) x(1) x(end) w h];
end

return