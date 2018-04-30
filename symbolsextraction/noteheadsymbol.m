function notehead = noteheadsymbol(symbols,score)

nH = cell2mat(symbols(1,1));
% stem = cell2mat(symbols(1,2));
% flag = cell2mat(symbols(1,4));
% beam = cell2mat(symbols(1,3));
%         
% k = stem(:,1:2);
% if size(k,1)>1
%     k = k(:)';
% end
% if size(flag,1) ==0
%     v = [nH(1:2) k];
%     v = sort(v);
%     symbol=[v(1) v(end) nH(3) nH(4) (nH(4)-nH(3)+1) (v(end)-v(1)+1)];
% else
%     v = [nH(1:2) k];
%     v = sort(v);
%     vv = [nH(3:4) flag(3:4)];
%     vv = sort(vv);
%     symbol=[v(1) v(end) vv(1) vv(end) (vv(end)-vv(1)+1) (v(end)-v(1)+1)];
% end
% a = max(symbol(3)-5,1);
% b = min(symbol(4)+5,size(score,2));
% 
% if size(beam,1) ~= 0
%     notehead = [symbol(1) symbol(2) a b beam];
% else
%     notehead = [symbol(1) symbol(2) a b zeros(1,6)];
% end

notehead = nH(:,1:4);