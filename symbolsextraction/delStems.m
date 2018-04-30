function stems = delStems(stemsClass)

dif = diff(stemsClass(:,end));
idx = find( dif == 0 );

if length(idx) == size(stemsClass,1)-1
    stems = [min(stemsClass(:,1)) max(stemsClass(:,2)) stemsClass(1,3) stemsClass(1,4)];
else
    sz = stemsClass(:,2)-stemsClass(:,1);
    [v, idx] = max(sz);
    stems = stemsClass(idx,:);
end