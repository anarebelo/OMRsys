function [newImage, stem]=removeSTEM_new(newImage,d2)
%Remove vertical objects with height lower than d2
k=1;
l=1;
stem={};
row=[];

for column=1:size(newImage,2)
    x=newImage(:,column)';
    [a] = rle(x);
    runs0 = a(2:2:end);
    aux=cumsum(a);
    idxRemove = find(runs0 < d2);
    if size(idxRemove,2)~=0;
        %Start with black pixels
        if aux(1)==0 && mod(length(aux),2)==0
            for i=1:2:length(aux)
                row(l)=aux(i)+1;
                l=l+1;
                row(l)=aux(i+1);
                l=l+1;
            end
            %end with white pixels
        elseif aux(1)==0 && mod(length(aux),2)==1
            for i=1:2:length(aux)-2
                row(l)=aux(i)+1;
                l=l+1;
                row(l)=aux(i+1);
                l=l+1;
            end
            %Start with white pixels
        else
            for i=1:length(runs0)
                row(l)=aux(2*i-1)+1;
                l=l+1;
                row(l)=aux(2*i);
                l=l+1;
            end
        end
        stem(k)={[row column]};
        row=[];
        k=k+1;
        l=1;
    end
    for j=length(idxRemove):-1:1
        idx = 2*idxRemove(j);
        if (idx < numel(a))
            a = [a(1:idx-2) a(idx-1)+a(idx)+a(idx+1) a(idx+2:end)];
        else
            a = [a(1:idx-2) a(idx-1)+a(idx)];
        end
    end
    x = rld (a);
    newImage(:,column) = x';

end