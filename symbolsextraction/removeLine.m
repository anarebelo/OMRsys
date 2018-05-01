%x-> row
%y-> column
function [img]=removeLine(threshold,tolerance,y,x,img,h)

for i=1:size(x,1)
    newX=x(i,:);
    newY=y(i,:);
    newX=newX(find(newX~=0));
    newY=newY(find(newY~=0));
    for ROW=1:length(newY)
        col=newX(ROW);
        refRow=newY(ROW);
        row=refRow;
        run=0;
        runU=0;
        runA=0;
        pel=img(row,col);
        if pel==1
            dist1=0;
            while pel==1
                row=row-1;
                dist1=dist1+1;
                if row<=0
                    break;
                end
                pel=img(row,col);
            end
            if row<=0
                dist1=h-1;
            end

            dist2=0;
            row=refRow;
            pel=img(row,col);
            while pel==1
                row=row+1;
                dist2=dist2+1;
                if row>h-1
                    break;
                end
                pel=img(row,col);
            end
            if row>h-1
                dist2=h-1;
            end

            if dist1<=max(1,min(dist2,tolerance))
                refRow=refRow-dist1;
            elseif dist2<=max(1,min(dist1,tolerance))
                refRow=refRow+dist2;
            else
                continue;
            end
        end

        row=refRow;
        pel=img(row,col);
        while pel==0
            runA=runA+1;
            row=row-1;
            if row<=0
                break;
            end
            pel=img(row,col);
        end

        row=refRow;
        pel=img(row,col);
        while pel==0
            row=row+1;
            if row>h-1
                break;
            end
            pel=img(row,col);
            if pel==0
                runU=runU+1;
            end
        end

        run=runA+runU;
        if run>=threshold
            continue;
        end
        %REMOVE
        row=refRow;
        pel=img(row,col);
        while pel==0
            img(row,col)=1;
            row=row-1;
            if row<=0
                break;
            end
            pel=img(row,col);
        end
        row=refRow+1;
        if row>h-1
            continue;
        end
        pel=img(row,col);
        while pel==0
            img(row,col)=1;
            row=row+1;
            if row>h-1
                break;
            end
            pel=img(row,col);
        end
    end
end