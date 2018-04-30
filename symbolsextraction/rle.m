function[len]=rle(x)
pos = [find(x(1:end-1) ~= x(2:end)), length(x)];
len = diff([ 0 pos ]);
if (x(1) ~= 1)
    len = [0 len];
end