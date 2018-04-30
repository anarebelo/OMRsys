function [notes, flags] = notesflags(setsymbols,score)

flags = [];
notes=[];
for j=1:size(setsymbols,1)
    nH = cell2mat(setsymbols(j,1));
    stem = cell2mat(setsymbols(j,2));
    flag = cell2mat(setsymbols(j,4));
    flags = [flags; flag];
    
    k = stem(:,1:2);
    if size(k,1)>1
        k = k(:)';
    end
    if size(flag,1) ==0
        v = [nH(1:2) k];
        v = sort(v);
        symbol=[v(1) v(end) nH(3) nH(4) (nH(4)-nH(3)+1) (v(end)-v(1)+1)];
    else
        v = [nH(1:2) k];
        v = sort(v);
        vv = [nH(3:4) flag(3:4)];
        vv = sort(vv);
        symbol=[v(1) v(end) vv(1) vv(end) (vv(end)-vv(1)+1) (v(end)-v(1)+1)];
    end
    
    a = max(symbol(3)-5,1);
    b = min(symbol(4)+5,size(score,2));
    notes=[notes; [symbol(1) symbol(2) a b 0 0]];   
end