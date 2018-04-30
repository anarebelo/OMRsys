function [dotSymbol]=finddots(score,spaceHeight,lineHeight)
global visitedMatrix

[h,w]=size(score);
visitedMatrix=ones([h,w]);

                
%Search for black pixels
if size(find(score(:)==0),1)~=0
    [rr cc]=find(score==0);
    point=[rr(1) cc(1)];
    
    aux = find(cc > 5);
    if size(aux,1 ) == 0
        dotSymbol= [];
        return
    end
    
    cc = cc(aux);
    rr = rr(aux);
    point=[rr(1) cc(1)];
    
    [symbol]=BreadthFirstSearch(point, w, h, score, 0);

    %Find height of the object
    y=symbol(1:2:end);
    y=sort(y);
    h=y(end)-y(1)+1;
    %Find width of the object
    x=symbol(2:2:end);
    x=sort(x);
    w=x(end)-x(1)+1;
    
    if w > lineHeight & w < spaceHeight & h > lineHeight & h < spaceHeight
        dotSymbol=[y(1) y(end) x(1) x(end) w h];
    else
       dotSymbol = []; 
    end

else
    dotSymbol = [];
    return
end

return