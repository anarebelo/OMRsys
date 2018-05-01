function pitch = findnotepositionstaff(symbolNoteHead, spaceHeight, dataX, dataY, numberLines, numberOfstaff,initialpositions,data_staffinfo_sets)

vect = cumsum(data_staffinfo_sets);
if numberOfstaff == 1
    vect1=1;
else
    vect1 = vect(numberOfstaff-1)+1;
end

dataY = dataY(vect1:min(vect1+(numberLines-1),size(dataY,1)),:);
dataX = dataX(vect1:min(vect1+(numberLines-1),size(dataX,1)),:);


rowStaffLine = dataY-repmat(initialpositions(numberOfstaff),size(dataY));
columnStaffLine = dataX - repmat(dataX(1,1),size(dataX));


[r,c]=find(rowStaffLine<0);
for i=1:size(r,1)
    rowStaffLine(r(i),c(i)) = 0;
end

setrows = [];
%Find the position in the staff
column1=symbolNoteHead(3);
A = find(columnStaffLine(1,:) == column1);
if size(A,2) == 0
    for idxidx = 3:-1:0
        A = find(columnStaffLine(numberLines-idxidx,:) == column1);
        if size(A,2)~=0
            setrows=[rowStaffLine(:,A(1)) 2*ones(numberLines,1)];
            break;
        end
    end
else
    setrows=[rowStaffLine(:,A(1)) 2*ones(size(rowStaffLine(:,A(1)),1),1)];
end

ss = [symbolNoteHead(1:2)' ones(2,1)];
aux = [ss; setrows];
[value idx]=sort(aux(:,1));
aux = aux(idx,:);
idxone=find(aux(:,2)==1);
aux1 = aux(idxone(1):idxone(2),:);

if size(aux1,1)==4
    if aux1(2,1) - aux1(1,1) == 1
        aux1(2,:) = [];
    elseif aux1(4,1) - aux1(3,1) == 1
        aux1(3,:) = [];
    end
end


%On a staffline
if length(find(diff(aux1(:,1))>spaceHeight/3) == 1) == 2
    number = find(aux1(2) == setrows(:,1));
    if size(number,1)~=0
        pitch = choosescale(number);
    else
        pitch = inf;
    end
    %On a staffspace
else
    %If we have a staffline
    if length(find(aux1(:,2)==2)) ~= 0
        number = find(aux1(2) == setrows(:,1));
        pitch = choosescale(number);
    else
        %If we do not have a staffline
        if idxone(1)==6
            if abs(aux(5) - aux(6)) < spaceHeight/3
                pitch = 1;
            else
                numberledgerline = findledgerline(aux(5),aux(6),spaceHeight);
                if size(numberledgerline,1)~=0
                    pitch = choosescale(numberledgerline);
                else
                    pitch = inf;
                end
            end
        elseif idxone(1)==1
            if abs(aux(3) - aux(2)) < spaceHeight/3
                pitch = 11;
            else
                numberledgerline = findledgerline(aux(3),aux(2),spaceHeight);
                if size(numberledgerline,1)~=0
                    pitch = choosescale(numberledgerline);
                else
                    pitch = inf;
                end
            end
        else
            vl=aux(idxone(1)-1,1);
            number = find(vl == setrows(:,1));
            pitch = choosescale(number);
        end
    end
end



