function [result,w] = findnH(NewnoteHead,beam,flag2,flag1,rangenumber)

colnoteHead=NewnoteHead(:,flag1);
result = -1;
for w=1:size(colnoteHead,1)
    for k=1:rangenumber
        if (colnoteHead(w)-k) == beam(flag2)
            result=w;
            break;
        elseif (colnoteHead(w)+k) == beam(flag2)
            result=w;
            break;
        elseif colnoteHead(w) == beam(flag2)
            result=w;
            break;
        end
    end
    if result>-1
        break;
    end
end

return