function [noteHead,noteHeadRejected]=WidthHeightDiag(limNoteHead,val_WidthHeightDiag)
k=1;
j=1;
noteHead=[];
noteHeadRejected=[];
for i=1:size(limNoteHead,1)
    %width = val_WidthHeightDiag% height and height = val_WidthHeightDiag% width
    if ((limNoteHead(i,6)>limNoteHead(i,5)*val_WidthHeightDiag) && (limNoteHead(i,5)>limNoteHead(i,6)*val_WidthHeightDiag))
        noteHead(k,:)=limNoteHead(i,:);
        k=k+1;
    else
        noteHeadRejected(j,:)=limNoteHead(i,:);
        j=j+1;
    end
end