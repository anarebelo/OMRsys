function accentClass = removeerroraccent(accentClass,spaceHeight)

[~,idx] = sort(accentClass(:,3));
accentClass = accentClass(idx,:);
countidx = [];
flag = 0;
idx = [];
for i=1:size(accentClass,1)-1
   aux = accentClass(i+1,3) - accentClass(i,4) ;
   if aux < spaceHeight
       idx = [idx i i+1];
       flag = 1;
   else
       if flag == 1
           countidx = [countidx idx];
       end
       idx = [];
       flag = 0;
   end
   if i == size(accentClass,1)-1
       aux = accentClass(size(accentClass,1),3) - accentClass(i,4) ;
       if aux < spaceHeight
           if flag == 1
                idx = [idx size(accentClass,1) i];
                countidx = [countidx idx];
           else
               countidx = [countidx idx];
           end
       else
           if flag == 1
               countidx = [countidx idx];
           end
       end
   end
end
accentClass(countidx,:) = [];
