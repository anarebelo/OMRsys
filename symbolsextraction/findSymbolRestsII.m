function [type, restClassII] = findSymbolRestsII(imgWithoutSymbols,lineHeight,spaceHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff,numberofLine,flag,data_staffinfo_sets)
global visitedMatrix


[h,w]=size(imgWithoutSymbols);
visitedMatrix=ones([h,w]);

vect = cumsum(data_staffinfo_sets);
if numberOfstaff == 1
    vect1=1;
else
    vect1 = vect(numberOfstaff-1)+1;
end

dataY = dataY(vect1:min(vect1+(numberLines-1),size(dataY,1)),:);
dataX = dataX(vect1:min(vect1+(numberLines-1),size(dataX,1)),:);

restClassII=zeros(1,6);
type=[];

%row
valueY=dataY(min(numberofLine,size(dataY,1)),:);
valueY=valueY(find(valueY~=0));

%column
valueX=dataX(min(numberofLine,size(dataX,1)),:);
valueX=valueX(find(valueX~=0));
th = valueX(1);

if flag==0
    for j=1:size(valueY,2)
        
        row = valueY(j)-initialpositions(numberOfstaff);
        column = valueX(j)-th;
        
        if column < restClassII(end,4)
            continue
        end
        
        a = max(1,row-lineHeight);
        b = min(row+lineHeight,size(imgWithoutSymbols,1));
        c = max(1,column-spaceHeight);
        d = min(column+spaceHeight,size(imgWithoutSymbols,2));
        img1 = imgWithoutSymbols(a:b,c:d);
        
        if size(find(img1(:)==0),1)~=0
            [rr cc]=find(img1==0);
            point=[rr(1)+a-1 cc(1)+c-1];
            threshold = 2;
            [object]=BreadthFirstSearch(point, w, h, imgWithoutSymbols, threshold);
            if size(object,1)~=0
                y=object(1:2:end);
                y=sort(y);
                hh=y(end)-y(1)+1;
                %Find width of the object
                x=object(2:2:end);
                x=sort(x);
                ww=x(end)-x(1)+1;
                
%                                 xx=[y(1) y(end) x(1) x(end) ww hh]
%                                 pause
                
                %Width
                if ww > spaceHeight+round(spaceHeight*0.50) & ww < 3*spaceHeight+round(spaceHeight*0.50) & hh > round(spaceHeight*0.60) & hh < spaceHeight+round(spaceHeight*0.50)
                    restClassII=[restClassII; y(1) y(end) x(1) x(end) ww hh];
                end
            end
        end
        
    end
    restClassII(1,:)=[];
elseif flag==1
    for j=1:size(valueY,2)       
        row = valueY(j)-initialpositions(numberOfstaff);
        column = valueX(j)-th;
        
        if column < restClassII(end,4)
            continue
        end
        
        a = max(1,row-lineHeight);
        b = min(row+lineHeight,size(imgWithoutSymbols,1));
        c = max(1,column-spaceHeight);
        d = min(column+spaceHeight,size(imgWithoutSymbols,2));
        img1 = imgWithoutSymbols(a:b,c:d);
        
        if size(find(img1(:)==0),1)~=0
            [rr cc]=find(img1==0);
            point=[rr(1)+a-1 cc(1)+c-1];
            threshold = 2;
            [object]=BreadthFirstSearch(point, w, h, imgWithoutSymbols, threshold);
            if size(object,1)~=0
                y=object(1:2:end);
                y=sort(y);
                hh=y(end)-y(1)+1;
                %Find width of the object
                x=object(2:2:end);
                x=sort(x);
                ww=x(end)-x(1)+1;
                
                %                 xx=[y(1) y(end) x(1) x(end) ww hh]
                %                 pause
                
                %Width
                if ww > spaceHeight+round(spaceHeight*0.50) & ww < 3*spaceHeight+round(spaceHeight*0.50) & hh > round(spaceHeight*0.60) & hh < spaceHeight+round(spaceHeight*0.50)
                    restClassII=[restClassII; y(1) y(end) x(1) x(end) ww hh];
                end
            end
        end     
    end
    restClassII(1,:)=[];
    restClassIIa=[];
    for i=1:size(restClassII,1)
        rest=restClassII(i,:);      
        row = dataY(size(dataY,1),rest(3))-initialpositions(numberOfstaff);
        
        a = max(1,row-lineHeight);
        b = min(row+lineHeight,size(imgWithoutSymbols,1));
        c = max(1,rest(3)-spaceHeight);
        d = min(rest(4)+spaceHeight,size(imgWithoutSymbols,2));
        img1 = imgWithoutSymbols(a:b,c:d);
        
        if size(find(img1(:)==0),1)~=0
            [rr cc]=find(img1==0);
            point=[rr(1)+a-1 cc(1)+c-1];
            threshold = 2;
            [object]=BreadthFirstSearch(point, w, h, imgWithoutSymbols, threshold);
            if size(object,1)~=0
                y=object(1:2:end);
                y=sort(y);
                hh=y(end)-y(1)+1;
                %Find width of the object
                x=object(2:2:end);
                x=sort(x);
                ww=x(end)-x(1)+1;
                
                %                 xx=[y(1) y(end) x(1) x(end) ww hh]
                %                 pause
                
                %Width
                if ww > spaceHeight+round(spaceHeight*0.50) & ww < 3*spaceHeight+round(spaceHeight*0.50) & hh > round(spaceHeight*0.60) & hh < spaceHeight+round(spaceHeight*0.50)
                    restClassIIa=[restClassIIa; rest; y(1) y(end) x(1) x(end) ww hh];
                    if abs(y(1)-row) < 2*lineHeight
                        %whole rest
                        type = [type 0];
                    else
                        %half rest
                        type = [type 1]; 
                    end
                end
            end
        end     
        
    end
    restClassII = restClassIIa;
else
    for j=1:size(valueY,2)   
        row = valueY(j)-initialpositions(numberOfstaff);
        column = valueX(j)-th;
        
        if column < restClassII(end,4)
            continue
        end
        
        a = max(1,row-lineHeight);
        b = min(row+lineHeight,size(imgWithoutSymbols,1));
        c = max(1,column-spaceHeight);
        d = min(column+spaceHeight,size(imgWithoutSymbols,2));
        img1 = imgWithoutSymbols(a:b,c:d);
        
        if size(find(img1(:)==0),1)~=0
            [rr cc]=find(img1==0);
            point=[rr(1)+a-1 cc(1)+c-1];
            threshold = 2;
            [object]=BreadthFirstSearch(point, w, h, imgWithoutSymbols, threshold);
            if size(object,1)~=0
                y=object(1:2:end);
                y=sort(y);
                hh=y(end)-y(1)+1;
                %Find width of the object
                x=object(2:2:end);
                x=sort(x);
                ww=x(end)-x(1)+1;
                
%                                 xx=[y(1) y(end) x(1) x(end) ww hh]
%                                 pause
                
                %Width
                if ww > spaceHeight & ww < 3*spaceHeight+round(spaceHeight*0.50) & hh > round(spaceHeight*0.60) & hh < 2*spaceHeight
                    if abs(y(1)-row) < 2*lineHeight 
                        restClassII=[restClassII; y(1) y(end) x(1) x(end) ww hh];
                    end
                end
            end
        end
        
    end
    restClassII(1,:)=[];
end


return