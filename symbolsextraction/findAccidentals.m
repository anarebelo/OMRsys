function [newSymbol]=findAccidentals(newImage,val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,val_findAccidentals4)
global visitedMatrix

%Height bigger than 2*spaceHeight and width bigger than spaceHeight*0.85
minH = val_findAccidentals1; 
minW = val_findAccidentals2; 
maxH = val_findAccidentals3; 
maxW = val_findAccidentals4; 


[h,w]=size(newImage);
visitedMatrix=ones([h,w]);
symbol={};
for column=1:size(newImage,2)
    %Height
    x=newImage(:,column)';
    [a] = rle(x);
    aux=cumsum(a);
    runs0 = a(2:2:end);
    for i=1:length(runs0)
        if runs0(i)>minH & runs0(i)<maxH
            row=aux(2*i-1)+1;
            if row+1<h & column+1<w
                if visitedMatrix(row+1, column+1)==1
                    [object]=BreadthFirstSearch([row+1,column+1], w, h, newImage,3);
                    symbol=[symbol object];
                end
            end
        end
    end
end


newSymbol=[];
k=1;
for i=1:length(symbol)
    A=cell2mat(symbol(i));

    %Find height of the object
    y=A(1:2:end);
    y=sort(y);
    h=y(end)-y(1)+1;
    %Find width of the object
    x=A(2:2:end);
    x=sort(x);
    w=x(end)-x(1)+1;

    %Width
    if w > minW & w < maxW
        newSymbol(k,:)=[y(1) y(end) x(1) x(end) w h];
        k=k+1;
    end
end