function [NewnoteHead, newStem] = verifyNoteHeadStem(val_verifyNoteHeadStem1,val_verifyNoteHeadStem2, noteHead, stem,val_sideFlag)


newStem=[];
m=1;
%1->stem at right of the notehead
%0->stem at left of the notehead
for num=1:size(stem,2)
    S=cell2mat(stem(num));
    colStem=S(end);
    pos=length(S);

    %Right
    [R]=sideFlag1(noteHead,colStem,1,val_sideFlag);
    if size(R,2)~=0
        [stemInicialRow, stemFinalRow, stemAux]=stemSize(colStem,S,pos,R,val_verifyNoteHeadStem1);
        for j=1:length(stemInicialRow)
            if ((stemInicialRow(j)>=noteHead(1,1) && noteHead(1,2)>stemInicialRow(j)) || (stemFinalRow(j)<=noteHead(1,2) && noteHead(1,1)<stemFinalRow(j)) || (stemFinalRow(j)>noteHead(1,2) && stemInicialRow(j)<noteHead(1,1)))
                newStem(m,:)=[stemInicialRow(j) stemFinalRow(j) R-noteHead(1,4) R 1];
                m=m+1;
            elseif stemInicialRow(j)>=noteHead(1,2) &  stemInicialRow(j)-noteHead(1,2)<val_verifyNoteHeadStem2 
                newStem(m,:)=[stemInicialRow(j) stemFinalRow(j) abs(R-noteHead(1,4)) R 1];
                m=m+1;
            elseif stemFinalRow(j)<=noteHead(1,1) &  noteHead(1,1)-stemFinalRow(j)<val_verifyNoteHeadStem2 
                newStem(m,:)=[stemInicialRow(j) stemFinalRow(j) abs(R-noteHead(1,4)) R 1];
                m=m+1;
            end
        end
    end

    %Left
    [L]=sideFlag0(noteHead,colStem,1,val_sideFlag);
    if size(L,2)~=0
        [stemInicialRow, stemFinalRow, stemAux]=stemSize(colStem,S,pos,L,val_verifyNoteHeadStem1);
        for j=1:length(stemInicialRow)
            if ((stemInicialRow(j)>=noteHead(1,1) && noteHead(1,2)>stemInicialRow(j)) || (stemFinalRow(j)<=noteHead(1,2) && noteHead(1,1)<stemFinalRow(j)) || (stemFinalRow(j)>noteHead(1,2) && stemInicialRow(j)<noteHead(1,1)))
                newStem(m,:)=[stemInicialRow(j) stemFinalRow(j) noteHead(1,3)-L L 0];
                m=m+1;
            elseif stemInicialRow(j)>=noteHead(1,2) &  stemInicialRow(j)-noteHead(1,2)<val_verifyNoteHeadStem2 
                newStem(m,:)=[stemInicialRow(j) stemFinalRow(j) abs(noteHead(1,3)-L) L 0];
                m=m+1;
            elseif stemFinalRow(j)<=noteHead(1,1) &  noteHead(1,1)-stemFinalRow(j)<val_verifyNoteHeadStem2 
                newStem(m,:)=[stemInicialRow(j) stemFinalRow(j) abs(noteHead(1,3)-L) L 0];
                m=m+1;
            end
        end
    end
end


if size(newStem,2)~=0
    [v, idx]=sort(newStem(:,3));
    %[value, idx]=min(v);
    newStem1=newStem(idx(1),:);
    if length(idx)>1
        newStem=newStem(idx(2),:);
    else
        newStem = newStem1;
    end
    newStem = [newStem1; newStem];
    newStem(:,3)=[];
    NewnoteHead = noteHead;
else
    NewnoteHead=[];
    newStem=[];
end