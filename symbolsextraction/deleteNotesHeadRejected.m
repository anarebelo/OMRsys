function notes = deleteNotesHeadRejected(noteHeadRejected,symbols,spaceHeight)

notes = noteHeadRejected;
idx = [];
for j=1:size(noteHeadRejected,1)
    n = noteHeadRejected(j,:);
    if abs(n(1)-symbols(1))<spaceHeight && abs(n(3)-symbols(3))<spaceHeight
        idx = [idx j];
    elseif abs(n(2)-symbols(2))<spaceHeight && abs(n(3)-symbols(3))<spaceHeight
        idx = [idx j];
    elseif abs(n(1)-symbols(2))<spaceHeight && abs(n(3)-symbols(3))<spaceHeight
        idx = [idx j];
    elseif abs(n(1)-symbols(1))<spaceHeight && abs(n(4)-symbols(3))<spaceHeight
        idx = [idx j];
    elseif abs(n(1)-symbols(1))<spaceHeight && abs(n(3)-symbols(4))<spaceHeight
        idx = [idx j];
    elseif abs(n(1)-symbols(2))<spaceHeight && abs(n(3)-symbols(4))<spaceHeight
        idx = [idx j];
    elseif abs(n(1)-symbols(2))<spaceHeight && abs(n(4)-symbols(3))<spaceHeight
        idx = [idx j];
    end
end
notes(idx,:) = [];