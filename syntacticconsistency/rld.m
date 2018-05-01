function [x] = rld (len)
val = zeros (1, length(len));
val(1:2:end) = 1;
val(2:2:end) = 0;
if (len(1) == 0)
    len = len(2:end);
    val = val(2:end);
end
i = cumsum([ 1 len ]);
k = zeros(1, i(end)-1);
k(i(1:end-1)) = 1;
x = val(cumsum(k));
return;