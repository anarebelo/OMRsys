function [setOpenNoteheadstem]=findOpenNoteHeads(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,setOpenNoteheadstem,lineHeight,spaceHeight,row,col,val_WidthHeightDiag)
global visitedMatrix


rowStem = row;
%Search to the right
a = max(1,row(1)-5*lineHeight);
b = min(row(2)+5*lineHeight,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,1));
c = max(1,col+2*lineHeight);
d = min(col+(spaceHeight+2*lineHeight),size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,2));
newImage = imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(a:b,c:d);


if size(newImage,1) ~= 0
    [noteheadsObject]=findOpenNoteHeads_int(newImage,lineHeight,spaceHeight);
    
    if size(noteheadsObject,1)~=0
        %     figure, imshow(newImage)
        
        for j=1:size(noteheadsObject,1)
            a1 = max(1,noteheadsObject(1,1)+a);
            b1 = min(noteheadsObject(1,2)+a,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,1));
            c1 = max(1,noteheadsObject(1,3)+c);
            d1 = min(noteheadsObject(1,4)+c,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,2));
            
            newSymbol = [a1 b1 c1 d1 noteheadsObject(1,5) noteheadsObject(1,6)];
            img = imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
            
            
            %remove threshold added in the floodfill
            %First zero in row
            idx=-1;
            for k=1:size(img,1)
                row = img(k,:);
                idx = find(row == 0,1);
                if idx~=-1
                    break;
                end
            end
            x = k;
            idx=-1;
            %Last zero in row
            for k=size(img,1):-1:1
                row = img(k,:);
                idx = find(row == 0,1);
                if idx~=-1
                    break;
                end
            end
            y = k;
            idx=-1;
            %First zero in column
            for k=1:size(img,2)
                row = img(:,k);
                idx = find(row == 0,1);
                if idx~=-1
                    break;
                end
            end
            z = k;
            idx=-1;
            %Last zero in column
            for k=size(img,2):-1:1
                row = img(:,k);
                idx = find(row == 0,1);
                if idx~=-1
                    break;
                end
            end
            w=k;
            
            
            newSymbol = [newSymbol(1)+x newSymbol(1)+y-1 newSymbol(3)+z newSymbol(3)+w-1 (y-x+1) (w-z+1)];
            if size(newSymbol,2)<6 || size(find(newSymbol<0,1),2)~=0
                continue
            end
            
            
            %Verification of the width and height
            heightOpenNoteHead = newSymbol(5);
            widthOpenNoteHead = newSymbol(6);
            if heightOpenNoteHead < 2*spaceHeight & widthOpenNoteHead < 2*spaceHeight
                %Verification of the distance of the symbol to the stem
                width = newSymbol(4) - col;
                %If the distance is 2*lineHeight then the object is broken.
                %We need to join it to the stem
                if width > 2*lineHeight
                    aux1 = abs(rowStem(1)-newSymbol(1));
                    aux2 = abs(rowStem(2)-newSymbol(2));
                    
                    %We need to join some pixeis in the height of the object
                    %stem down
                    if aux1 < aux2
                        aa = max(1,newSymbol(1)-2*lineHeight);
                        newSymbol = [aa newSymbol(2) col newSymbol(4) (newSymbol(2)-aa)+1 width];
                    elseif aux2 < aux1
                        %stem up
                        aa = min(newSymbol(2)+2*lineHeight,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,1));
                        newSymbol = [newSymbol(1) aa col newSymbol(4) (aa-newSymbol(1))+1 width];
                    end
                end
            else
                continue
            end
            
            
            %Noteheads rejected because its width and height
            [noteHead,exclNotehead]=WidthHeightDiag(newSymbol,val_WidthHeightDiag);
            
            %         imshow(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(noteHead(1):noteHead(2),noteHead(3):noteHead(4)))
            
            %Accepted
            if size(noteHead,1)~=0
                st = [rowStem(1) rowStem(2) col];
                %             noteHead
                
                %Verify if the notehead is closed to stem
                a = st(1) - noteHead(1);
                b = st(1) - noteHead(2);
                c = st(2) - noteHead(1);
                d = st(2) - noteHead(2);
                
                accepted = 0;
                if (a > 0 && b > 0) || (c < 0 && d < 0)
                    v = min(abs(b),abs(c));
                    if v <= spaceHeight
                        [accept]=restrictedMinim(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(noteHead(1):noteHead(2),noteHead(3):noteHead(4)));
                        if accept == 1
                            accepted = 1;
                        end
                    end
                elseif (a > 0 && b < 0) || (c > 0 && d < 0)
                    v = min(abs(a),abs(d));
                    if v <= noteHead(6)
                        [accept]=restrictedMinim(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(noteHead(1):noteHead(2),noteHead(3):noteHead(4)));
                        if accept == 1
                            accepted = 1;
                        end
                    end
                elseif (a < 0 && b < 0) || (c > 0 && d > 0)
                    v = min(abs(a),abs(d));
                    if v <= spaceHeight
                        [accept]=restrictedMinim(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(noteHead(1):noteHead(2),noteHead(3):noteHead(4)));
                        if accept == 1
                            accepted = 1;
                        end
                    end
                end
                if accepted == 1
                    %                 v = min(abs(a),abs(b))
                    %                 if v <= spaceHeight
                    %                 disp('Definitivamente aceite!')
                    %                 st
                    %                 noteHead
                    %                     pause
                    setOpenNoteheadstem = setfield(setOpenNoteheadstem, 'OpenNoteheadstem', [setOpenNoteheadstem.OpenNoteheadstem; {noteHead st [] []}]);
                    %                 end
                end
            end
            %         disp('--------------------------------------')
            %                 pause
            %                 close all
        end
    end
    % disp('-------------------------------------')
    % pause
end


%Search to the left
a = max(1,rowStem(1)-5*lineHeight);
b = min(rowStem(2)+5*lineHeight,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,1));
c = max(1,col-(spaceHeight+2*lineHeight));
d = min(col-2*lineHeight,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,2));
newImage = imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(a:b,c:d);


% figure, imshow(newImage)
% pause
if size(newImage,1) == 0
    return
end
[noteheadsObject]=findOpenNoteHeads_int(newImage,lineHeight,spaceHeight);

if size(noteheadsObject,1)~=0
    %     figure, imshow(newImage)
    
    for j=1:size(noteheadsObject,1)
        a1 = max(1,noteheadsObject(1,1)+a);
        b1 = min(noteheadsObject(1,2)+a,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,1));
        c1 = max(1,noteheadsObject(1,3)+c);
        d1 = min(noteheadsObject(1,4)+c,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,2));
        
        newSymbol = [a1 b1 c1 d1 noteheadsObject(1,5) noteheadsObject(1,6)];
        img = imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
        
        %remove threshold added in the floodfill
        %First zero in row
        idx=-1;
        for k=1:size(img,1)
            row = img(k,:);
            idx = find(row == 0,1);
            if idx~=-1
                break;
            end
        end
        x = k;
        idx=-1;
        %Last zero in row
        for k=size(img,1):-1:1
            row = img(k,:);
            idx = find(row == 0,1);
            if idx~=-1
                break;
            end
        end
        y = k;
        idx=-1;
        %First zero in column
        for k=1:size(img,2)
            row = img(:,k);
            idx = find(row == 0,1);
            if idx~=-1
                break;
            end
        end
        z = k;
        idx=-1;
        %Last zero in column
        for k=size(img,2):-1:1
            row = img(:,k);
            idx = find(row == 0,1);
            if idx~=-1
                break;
            end
        end
        w=k;
        
        
        newSymbol = [newSymbol(1)+x newSymbol(1)+y-1 newSymbol(3)+z newSymbol(3)+w-1 (y-x+1) (w-z+1)];
        if size(newSymbol,2)<6 || size(find(newSymbol<0,1),2)~=0
            continue
        end
        
        %Verification of the width and height
        heightOpenNoteHead = newSymbol(5);
        widthOpenNoteHead = newSymbol(6);
        if heightOpenNoteHead < 2*spaceHeight & widthOpenNoteHead < 2*spaceHeight
            %Verification of the distance of the symbol to the stem
            width = col - newSymbol(3);
            %If the distance is 2*lineHeight then the object is broken.
            %We need to join it to the stem
            if width > 2*lineHeight
                aux1 = abs(rowStem(1)-newSymbol(1));
                aux2 = abs(rowStem(2)-newSymbol(2));
                
                %We need to join some pixeis in the height of the object
                %stem down
                if aux1 < aux2
                    aa = max(1,newSymbol(1)-2*lineHeight);
                    newSymbol = [aa newSymbol(2) newSymbol(3) col (newSymbol(2)-aa)+1 width];
                elseif aux2 < aux1
                    %stem up
                    aa = min(newSymbol(2)+2*lineHeight,size(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals,1));
                    newSymbol = [newSymbol(1) aa newSymbol(3) col (aa-newSymbol(1))+1 width];
                end
            end
        else
            continue
        end
        
        %Noteheads rejected because its width and height
        [noteHead,exclNotehead]=WidthHeightDiag(newSymbol,val_WidthHeightDiag);
        
        %Accepted
        if size(noteHead,1)~=0
            st = [rowStem(1) rowStem(2) col];
            
            %Verify if the notehead is closed to stem
            a = st(1) - noteHead(1);
            b = st(1) - noteHead(2);
            c = st(2) - noteHead(1);
            d = st(2) - noteHead(2);
            
            accepted = 0;
            if (a > 0 && b > 0) || (c < 0 && d < 0) || (a < 0 && b < 0) || (c > 0 && d > 0)
                v = min(abs(b),abs(c));
                if v <= spaceHeight
                    [accept]=restrictedMinim(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(noteHead(1):noteHead(2),noteHead(3):noteHead(4)));
                    if accept == 1
                        accepted = 1;
                    end
                end
            elseif (a > 0 && b < 0) || (c > 0 && d < 0)
                v = min(abs(a),abs(d));
                if v <= noteHead(6)
                    [accept]=restrictedMinim(imgWithoutBeamsNoteHeadsStemsFlagsAccidentals(noteHead(1):noteHead(2),noteHead(3):noteHead(4)));
                    if accept == 1
                        accepted = 1;
                    end
                end
            end
            if accepted == 1
                setOpenNoteheadstem = setfield(setOpenNoteheadstem, 'OpenNoteheadstem', [setOpenNoteheadstem.OpenNoteheadstem; {noteHead st [] []}]);
            end
        end
    end
end