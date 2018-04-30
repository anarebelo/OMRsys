function [newAccentSymbol]=findAccents(score,spaceHeight,lineHeight)
global visitedMatrix

accSymbol = [];
newAccentSymbol = [];
[h,w]=size(score);
visitedMatrix=ones([h,w]);

tam = size(find(score(:)==0),1);
if size(find(score(:)==0),1)~=0
    while tam ~= 0
        [rr cc]=find(score==0);
        point=[rr(1) cc(1)];
        
        [symbol]=BreadthFirstSearch(point, w, h, score, 1);
        
        if size(symbol,1) == 0
            break;
        end

        %Find height of the object
        y=symbol(1:2:end);
        y=sort(y);
        h1=y(end)-y(1)+1;
        %Find width of the object
        x=symbol(2:2:end);
        x=sort(x);
        w1=x(end)-x(1)+1;
 
        if w1 > lineHeight & w1 < 4*spaceHeight & h1 > lineHeight & h1 < 4*spaceHeight
            accSymbol=[accSymbol; y(1) y(end) x(1) x(end) w1 h1];
            score(accSymbol(end,1):accSymbol(end,2), accSymbol(end,3):accSymbol(end,4)) = 1;
            [h,w]=size(score);
            visitedMatrix=ones([h,w]);
        end
        
        tam = size(find(score(:)==0),1);
    end
end

if size(accSymbol,1) > 1
    newAccentSymbol = zeros(size(accSymbol));
    m = 1;
    c = 1;
    for k=1:size(accSymbol,1)-1
        if k==1
            if abs(accSymbol(k+1,1)-accSymbol(k,1)) <= lineHeight
                a1 = min(accSymbol(k+1,1),accSymbol(k,1));
                a2 = max(accSymbol(k+1,2),accSymbol(k,2));
                newAccentSymbol(c,:) = [a1 a2 accSymbol(k,3) accSymbol(k+1,4) accSymbol(k+1,4)-accSymbol(k,3)+1 a1-a2+1];
            else
                newAccentSymbol(c,:) = accSymbol(k,:); 
                c = c+1;
                newAccentSymbol(c,:) = accSymbol(k+1,:);
                m = m+1;
            end
        else
            if abs(accSymbol(k+1,1)-newAccentSymbol(m,1)) <= lineHeight
                a1 = min(accSymbol(k+1,1),newAccentSymbol(m,1));
                a2 = max(accSymbol(k+1,2),newAccentSymbol(m,2));
                newAccentSymbol(c-1,:) = [a1 a2  newAccentSymbol(m,3) accSymbol(k+1,4) accSymbol(k+1,4)-newAccentSymbol(m,3)+1 a2-a1+1];     
            else
               newAccentSymbol(c,:) = accSymbol(k+1,:); 
            end
            m = m+1;
        end
        c = c+1; 
        
        if k == size(accSymbol,1)-1
            if abs(accSymbol(size(accSymbol,1),1)-newAccentSymbol(m,1)) <= lineHeight
                a1 = min(accSymbol(size(accSymbol,1),1),newAccentSymbol(m,1));
                a2 = max(accSymbol(size(accSymbol,1),2),newAccentSymbol(m,2));
                newAccentSymbol(c-1,:) = [a1 a2  newAccentSymbol(m,3) accSymbol(size(accSymbol,1),4) accSymbol(size(accSymbol,1),4)-newAccentSymbol(m,3)+1 a2-a1+1];     
            else
               newAccentSymbol(c,:) = accSymbol(size(accSymbol,1),:); 
            end
        end
    end
    newAccentSymbol(find(newAccentSymbol(:,1) == 0),:)=[];
elseif size(accSymbol,1) == 1
    newAccentSymbol = accSymbol;
end

return