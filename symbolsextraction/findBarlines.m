function barLinesSymbols = findBarlines(image,spaceHeight,lineHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff,toleranceStaff,param1,data_staffinfo_sets)
global visitedMatrix

% imwrite(image,'xx.png','png')

th = (numberLines-1)*spaceHeight + numberLines*lineHeight;

[h,w]=size(image);
visitedMatrix=ones([h,w]);
value = round(spaceHeight/2);

vect = cumsum(data_staffinfo_sets);
if numberOfstaff == 1
    vect1=1;
else
    vect1 = vect(numberOfstaff-1)+1;
end


dataY = dataY(vect1:min(vect1+(numberLines-1),size(dataY,1)),:);
dataX = dataX(vect1:min(vect1+(numberLines-1),size(dataX,1)),:);

barlines = zeros(1,4);
previousSymbol = zeros(1,4);
barLinesSymbols = [];
valueXAux=dataX(1,1);
%For each staffline
for i=1:size(dataY,2)
    %column
    valueX=dataX(1,i);
    column = valueX-valueXAux;
    
    if column-lineHeight < barlines(4)
        continue
    end
    
    %initial row
    valueY=dataY(1,i);
    if valueY == 0
        break
    end
    row1 = valueY - initialpositions(numberOfstaff);
    
    %final row
    valueY=dataY(end,i);
    
    row2 = valueY - initialpositions(numberOfstaff);

    a = max(1,row1-value);
    b = min(row2+value,size(image,1));
    c = max(1,column);
    d = min(column+2*lineHeight,size(image,2));
    
    if c == d
        break;
    end
    img = image(a:b,c:d);
%     image(a:b,c:d) = 0.5;
    
    if size(find(img(:)==0),1)~=0
        [rr cc]=find(img==0);
        point=[rr(1)+a-1 cc(1)+c-1];
        threshold = 3;
        [object]=BreadthFirstSearch(point, w, h, image, threshold);
        
%         if column==929
%             object
%             imshow(visitedMatrix)
%             point
%             edas
%         end

        if size(object,1)~=0
            
            [newSymbol,flag]=findverticalLines(object,spaceHeight,th,threshold,image,previousSymbol);
%             newSymbol
%             pause
%             close

            if size(newSymbol,1)~=0
                %Procurar inicio e fim da pausa em linha
                possibleSymbol = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));  
         
                symbolAuxInv = possibleSymbol'; 
                [rw, cl1] = find(symbolAuxInv == 0,1);  
                symbolAuxInv1 = symbolAuxInv(:,end:-1:1);
                [rw1, cl2] = find(symbolAuxInv1 == 0,1);
                a21 = size(symbolAuxInv,2)-cl2+1;
                
                previousSymbol = newSymbol;
                barlines = [cl1+newSymbol(1)-1 a21+newSymbol(1)-1 newSymbol(3) newSymbol(4) newSymbol(5) a21+newSymbol(1)-1-(cl1+newSymbol(1)-1)];
%                 barlines
%                 imshow(image(barlines(1):barlines(2),barlines(3):barlines(4)))
%                 pause
%                 close
                
                %Bar lines starts in the beginning of the image
                if abs(1-barlines(1)) < 0.50*spaceHeight 
                    if flag == 0
                        barLinesSymbols  = [barLinesSymbols; barlines];
                    else
                        if size(barLinesSymbols,1)~=0
                            barLinesSymbols(end,:) = [];
                        end
                        barLinesSymbols  = [barLinesSymbols; barlines];
                    end
                    image(barlines(1):barlines(2),barlines(3):barlines(4)) = 1;
                    %Bar lines end up in the ending of the image
                elseif (size(image,1)-toleranceStaff-barlines(2)) > 0 &&  (size(image,1)-toleranceStaff-barlines(2)) < 0.70*spaceHeight
                    if flag == 0
                        barLinesSymbols  = [barLinesSymbols; barlines];
                    else
                        if size(barLinesSymbols,1)~=0
                            barLinesSymbols(end,:) = [];
                        end
                        barLinesSymbols  = [barLinesSymbols; barlines];
                    end
                    image(barlines(1):barlines(2),barlines(3):barlines(4)) = 1;        
                elseif (size(image,1)-toleranceStaff-barlines(2)) < 0
                    if flag == 0
                        barLinesSymbols  = [barLinesSymbols; barlines];
                    else
                        if size(barLinesSymbols,1)~=0
                            barLinesSymbols(end,:) = [];
                        end
                        barLinesSymbols  = [barLinesSymbols; barlines];
                    end
                    image(barlines(1):barlines(2),barlines(3):barlines(4)) = 1;
                elseif abs(row1-barlines(1)) < param1*spaceHeight && abs(row2-barlines(2)) < param1*spaceHeight
                    if flag == 0
                        barLinesSymbols  = [barLinesSymbols; barlines];
                    else
                        if size(barLinesSymbols,1)~=0
                            barLinesSymbols(end,:) = [];
                        end
                        barLinesSymbols  = [barLinesSymbols; barlines];
                    end
                    image(barlines(1):barlines(2),barlines(3):barlines(4)) = 1;
                end
                
%                 row1
%                 row2
%                 abs(row1-barlines(1))
%                 param1*spaceHeight
%                 abs(row2-barlines(2))
%                 param1*spaceHeight
%                 disp('---------------------------------')
%                 size(image,1)
%                 toleranceStaff
%                 (size(image,1)-toleranceStaff-barlines(2))
%                 0.70*spaceHeight
%                 
%                 pause
%                 close
            end
        end
    end

end
% for i=1:size(barLinesSymbols,1)
%     image(barLinesSymbols(i,1):barLinesSymbols(i,2),barLinesSymbols(i,3):barLinesSymbols(i,4)) = 0.5;
% end
% imwrite(image,'xx1.png','png')


if size(barLinesSymbols,1)~=0
    %Find dots associated with bar lines
    idx = find(barLinesSymbols(:,5) > spaceHeight);
    dot=[];
    newBarlines = [];
    for i=1:length(idx)
        bl =  barLinesSymbols(idx,:);

        %before
        c = max(1,bl(3)-spaceHeight);
        img = image(bl(1):bl(2),c:bl(4));
%             figure, imshow(img)
        [rw, cl1] = find(img == 0,1);
        if size(rw,1)~=0
            %     figure,imshow(img(:,cl1:end))

            symbolAuxInv1 = img(:,end:-1:1);
            [rw1, cl2] = find(symbolAuxInv1 == 0,1);
            cl2 = size(img,2)-cl2+1;
            %     figure,imshow(img(:,cl1:cl2))

            symbolAuxInv = img';
            [rw, cl3] = find(symbolAuxInv == 0,1);
            cl3 = size(img,1)-cl3+1;
            %     figure,imshow(img(1:cl3,cl1:cl2))

            symbolAuxInv1 = symbolAuxInv(:,end:-1:1);
            [rw1, cl4] = find(symbolAuxInv1 == 0,1);
            %     figure,imshow(img(cl4:cl3,cl1:cl2))

            possibleDot = [cl4+bl(1) cl3+bl(1) cl1+c cl2+c cl2+c-(cl1+c)+1 cl3+bl(1)-(cl4+bl(1))+1];
            
            if size(possibleDot,1) ~= 0
                %width and height
                if possibleDot(5) < spaceHeight && possibleDot(6) < 3*spaceHeight
                    dot = [dot; possibleDot];
                    %         figure,imshow(image(possibleDot(1):possibleDot(2),possibleDot(3):possibleDot(4)))
                end
            end
        end

        %After
        c = min(size(image,2),bl(4)+spaceHeight);
        img = image(bl(1):bl(2),bl(4):c);
%             imshow(img)
        [rw, cl1] = find(img == 0,1);
        if size(rw,1)~=0
            %     figure,imshow(img(:,cl1:end))

            symbolAuxInv1 = img(:,end:-1:1);
            [rw1, cl2] = find(symbolAuxInv1 == 0,1);
            cl2 = size(img,2)-cl2+1;
            %     figure,imshow(img(:,cl1:cl2))

            symbolAuxInv = img';
            [rw, cl3] = find(symbolAuxInv == 0,1);
            cl3 = size(img,1)-cl3+1;
            %     figure,imshow(img(1:cl3,cl1:cl2))

            symbolAuxInv1 = symbolAuxInv(:,end:-1:1);
            [rw1, cl4] = find(symbolAuxInv1 == 0,1);
            %     figure,imshow(img(cl4:cl3,cl1:cl2))

            possibleDot = [cl4+bl(1)-1 cl3+bl(1) cl1+bl(4)-1 cl2+bl(4) cl2+bl(4)-(cl1+bl(4))+1 cl3+bl(1)-(cl4+bl(1))+1];
            
            if size(possibleDot,1) ~=0
                %width and height
                if possibleDot(5) < spaceHeight && possibleDot(6) < 3*spaceHeight
                    dot = [dot; possibleDot];
                    %         figure,imshow(image(possibleDot(1):possibleDot(2),possibleDot(3):possibleDot(4)))
                end
            end
        end
        if size(dot,1)~=0
            a = [dot(:,1); bl(1)];
            b = [dot(:,2); bl(2)];
            c = [dot(:,3); bl(3)];
            d = [dot(:,4); bl(4)];

            newBarlines = [newBarlines; min(a) max(b) min(c) max(d) max(d)-min(c)+1 max(b)-min(a)+1];
        end
    end
    barLinesSymbols(idx,:) = [];
    barLinesSymbols =[barLinesSymbols; newBarlines];
end
% for i=1:size(barLinesSymbols,1)
%     image(barLinesSymbols(i,1):barLinesSymbols(i,2),barLinesSymbols(i,3):barLinesSymbols(i,4)) = 0.5;
% end
% imwrite(image,'xx1.png','png')


% imwrite(img,'xx.png','png')
%
% imgdeskewing = staffinclinationremoval(img);
%
% imwrite(imgdeskewing,'xx1.png','png')
%
%
% %erosao seguida de uma dilacao
% st = strel('square',3);
% img_open = imopen(imgdeskewing,st);
% imwrite(img_open,'xx2.png','png')
%
% %th = (numberLines-1)*spaceHeight + numberLines*lineHeight;
% st = strel('rectangle',[spaceHeight lineHeight]);
% %dilacao seguida de uma erosao
% img_close = imclose(img_open,st);
% imwrite(img_close,'xx3.png','png')
%
% %dilacao seguida de uma erosao
% img_close = imclose(img,st);
%
% imwrite(img_close,'xx4.png','png')

