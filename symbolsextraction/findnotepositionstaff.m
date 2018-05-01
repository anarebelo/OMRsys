function staffNotesHead = findnotepositionstaff(notehead, imgOutput, lineHeight, spaceHeight, dataX, dataY, numberLines, numberOfstaff,initialpositions,data_staffinfo_sets,val_NoteHeads1, val_NoteHeads2,val_NoteHeads3)
staffNotesHead = [];


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
 
% for i=1:size(rowStaffLine,1)
%     %row
%     row1=rowStaffLine(i,:);
%     row1=row1(find(row1~=0));
%     %column
%     column1=columnStaffLine(i,:);
%     column1=column1(find(column1~=0));
% 
%     for j=1:size(row1,2)
%         a = max(1,row1(j)-spaceHeight);
%         b = min(row1(j)+spaceHeight,size(imgOutput,1));
%         c = max(1,column1(j)-2*lineHeight);
%         d = min(column1(j)+2*lineHeight,size(imgOutput,2));
% 
%         imgOutput(a:b,c:d) = 0.5;
%     end
% end
% imwrite(imgOutput,'imgOutput.png','png')


% imgOutput(notehead(1):notehead(2),notehead(3):notehead(4)) = 0.5;
% imwrite(imgOutput,'imgOutput.png','png')

setrows = [];
if (notehead(2)-notehead(1)) < spaceHeight*6
    symbolNoteHead = notehead;
    control = 0;

else
    %Chords
    img=imgOutput';
    [img, stem]=removeSTEM_new(img,2*lineHeight);
    img = img';

    [symbolNoteHead]=findNoteHeads(img,val_NoteHeads1, val_NoteHeads2,val_NoteHeads3);
    control = 1;
end


if size(symbolNoteHead,1)~=0

    %Find the position in the staff
    column1=symbolNoteHead(1,3);

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

    newsymbolNoteHead = [];
    for k=1:size(symbolNoteHead,1)
        obj1 = symbolNoteHead(k,3:4);

        %Verify width  -> remove possible beams
        if diff(obj1)+1 >= 2*spaceHeight %spaceHeight-lineHeight
            obj2 = symbolNoteHead(k,1:2);
            %Verify height -> remove possible beams
            if diff(obj2)+1 >= 2*spaceHeight   %spaceHeight-lineHeight
                [newsymbolNoteHead, flag] = saveStaffNotesHead(newsymbolNoteHead, symbolNoteHead, setrows, spaceHeight, lineHeight, k, symbolNoteHead(k,:),numberOfstaff,control);
                if flag == 1
                    break;
                end
            end
        else
            [newsymbolNoteHead, flag] = saveStaffNotesHead(newsymbolNoteHead,symbolNoteHead, setrows, spaceHeight, lineHeight, k,symbolNoteHead(k,:),numberOfstaff,control);
            
            if flag == 1
                break;
            end
        end
        
    end

end

staffNotesHead = newsymbolNoteHead;