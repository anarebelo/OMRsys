function [OpenNotehead]=findOpenNoteHeadsI(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,lineHeight,spaceHeight,dataY,dataX,...
    initialpositions,numberLines,numberOfstaff,data_staffinfo_sets,val_whitepixels)
global visitedMatrix

[h,w]=size(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals);
visitedMatrix=ones([h,w]);
value = round(spaceHeight/2);

vect = cumsum(data_staffinfo_sets);
if numberOfstaff == 1
    vect1=1;
else
    vect1 = vect(numberOfstaff-1)+1;
end

%First line
%reproduzir linhas suplementares a partir da primeira linha e usando
%spaceHeight
dataY11 = dataY(vect1,:);
dataX11 = dataX(vect1,:);

%Evitar que ultrapasse a altura da imagem
dataY11_aux = dataY11;
dataY11_aux(find(dataY11_aux == 0)) = [];
a = min(dataY11_aux);
t = floor((a-1)/spaceHeight);

%Significa que posso construir 5 linhas suplementares
if t > 5
    vv = 1:5;
    vv = vv*spaceHeight;
    vv = vv';
    dataY11 = repmat(dataY11,5,1) - repmat(vv,1,size(dataY11,2));
    dataX11 = repmat(dataX11,5,1) - repmat(vv,1,size(dataX11,2));
else
    vv = 1:t;
    vv = vv*spaceHeight;
    vv = vv';
    dataY11 = repmat(dataY11,t,1) - repmat(vv,1,size(dataY11,2));
    dataX11 = repmat(dataX11,t,1) - repmat(vv,1,size(dataX11,2));
end

%Last line
dataY12 = dataY(min(vect1+(numberLines-1),size(dataY,1)),:);
dataX12 = dataX(min(vect1+(numberLines-1),size(dataX,1)),:);

%Evitar que ultrapasse a altura da imagem
a = max(dataY12);
t = floor((a-1)/spaceHeight);

%Significa que posso construir 5 linhas suplementares
if t > 5
    vv = 1:5;
    vv = vv*spaceHeight;
    vv = vv';
    dataY12 = repmat(dataY12,5,1) + repmat(vv,1,size(dataY12,2));
    dataX12 = repmat(dataX12,5,1) + repmat(vv,1,size(dataX11,2));
else
    vv = 1:t;
    vv = vv*spaceHeight;
    vv = vv';
    dataY12 = repmat(dataY12,t,1) + repmat(vv,1,size(dataY12,2));
    dataX12 = repmat(dataX12,t,1) + repmat(vv,1,size(dataX12,2));
end

dataY1 = [dataY11; dataY12];
dataX1 = [dataX11; dataX12];

dataY = dataY(vect1:min(vect1+(numberLines-1),size(dataY,1)),:);
dataX = dataX(vect1:min(vect1+(numberLines-1),size(dataX,1)),:);

% xx = imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals;
sy = {};
%For each staffline
for i=1:size(dataY,1)
    %row
    valueY=dataY(i,:);
    valueY=valueY(find(valueY~=0));
    %column
    valueX=dataX(i,:);
    valueX=valueX(find(valueX~=0));
    th = valueX(1);

    sy1 = [];
    for j=1:size(valueY,2)

        row = valueY(j)-initialpositions(numberOfstaff);
        column = valueX(j)-th;

        a = max(1,row-value);
        b = min(row+value,size(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,1));
        c = max(1,column-2*lineHeight);
        d = min(column+2*lineHeight,size(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,2));

        img = imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals(a:b,c:d);
%         xx(a:b,c:d) = 0.5;
%                 imshow(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals)
        %         imwrite(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,'imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals.png','png')

        if size(find(img(:)==0),1)~=0
            [rr cc]=find(img==0);
            point=[rr(1)+a-1 cc(1)+c-1];

            [object]=BreadthFirstSearch(point, w, h, imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,2);
            if size(object,1)~=0
                [newSymbol]=findOpenNoteHeads_intI(object,lineHeight,spaceHeight);
                
                if size(newSymbol,1)~=0
%                     imshow(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)))

                    %Remove object with an height superior to 2*spaceHeight
                    if (newSymbol(6) < 2*spaceHeight)
                        sy1 = [sy1; newSymbol];
                    end

                    %                     figure,imshow(img)
                    %                     figure, imshow(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals(newSymbol(1):newSymbol(2), newSymbol(3):newSymbol(4)))
                    %                     pause
                    %                     close
                end
            end
        end

    end
    sy = [sy sy1];
end

% imwrite(xx,'imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals1.png','png')
% asdsdasad

% xx = imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals;

%ledger lines
for i=1:size(dataY1,1)
    %row
    valueY=dataY1(i,:);
    valueY=valueY(find(valueY~=0));
    %column
    valueX=dataX1(i,:);
    valueX=valueX(find(valueX~=0));
    th = valueX(1);

    sy1 = [];
    for j=1:size(valueY,2)

        row = valueY(j)-initialpositions(numberOfstaff);
        column = valueX(j)-th;

        a = max(1,row-value);
        b = min(row+value,size(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,1));
        c = max(1,column-2*lineHeight);
        d = min(column+2*lineHeight,size(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,2));

        img = imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals(a:b,c:d);
   
%         xx(a:b,c:d) = 0.5;

        if size(find(img(:)==0),1)~=0
            [rr cc]=find(img==0);
            point=[rr(1)+a-1 cc(1)+c-1];

            [object]=BreadthFirstSearch(point, w, h, imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,2);
            if size(object,1)~=0
                [newSymbol]=findOpenNoteHeads_intI(object,lineHeight,spaceHeight);

                if size(newSymbol,1)~=0
                    %Remove object with an height superior to 2*spaceHeight
                    if (newSymbol(6) < 2*spaceHeight)
                        sy1 = [sy1; newSymbol];
                    end
                end
            end
        end
    end
    sy = [sy sy1];
end

% imwrite(xx,'imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals1.png','png')


setOpenNotehead = [];

threshold =  round(value*0.60);
for i=1:size(sy,2)
    A = cell2mat(sy(i));

    if size(A,1) > 2
        j=1;
        while j~=size(A,1)-1
            B  = A(j,:);
            B1 = A(j+1,:);
            lastcolumn = B(4);
            firstcolumn = B1(3);

            %If they are closed
            if (firstcolumn - lastcolumn) < spaceHeight
                widthfirst = B(5);
                widthsecond = B1(5);

                heightfirst = B(6);
                heightsecond = B1(6);

                if abs(widthfirst - widthsecond) < threshold && abs(heightfirst - heightsecond) < threshold
                    a = [B(1:2) B1(1:2)];
                    a = sort(a);
                    b = [B(3:4) B1(3:4)];
                    b = sort(b);
                    setOpenNotehead = [setOpenNotehead; a(1) a(end) b(1) b(end) a(end)-a(1)+1 b(end)-b(1)+1];
                    j = j+2;
                else
                    j=j+1;
                end
            else
                if B(5) > spaceHeight+3*lineHeight && B1(5) > spaceHeight+3*lineHeight
                    setOpenNotehead = [setOpenNotehead; B; B1];
                    j=j+2;
                elseif  B(5) > spaceHeight+3*lineHeight && B1(5) < spaceHeight+3*lineHeight
                    setOpenNotehead = [setOpenNotehead; B];
                    j=j+1;
                elseif B1(5) > spaceHeight+3*lineHeight && B(5) < spaceHeight+3*lineHeight
                    setOpenNotehead = [setOpenNotehead; B1];
                    j=j+1;
                else
                    j = j+1;
                end              
            end

            if j == size(A,1)-1
                B  = A(j,:);
                B1 = A(size(A,1),:);
                lastcolumn = B(4);
                firstcolumn = B1(3);

                %If they are closed
                if (firstcolumn - lastcolumn) < spaceHeight
                    widthfirst = B(5);
                    widthsecond = B1(5);

                    heightfirst = B(6);
                    heightsecond = B1(6);

                    if abs(widthfirst - widthsecond) < threshold && abs(heightfirst - heightsecond) < threshold
                        a = [B(1:2) B1(1:2)];
                        a = sort(a);
                        b = [B(3:4) B1(3:4)];
                        b = sort(b);
                        setOpenNotehead = [setOpenNotehead; a(1) a(end) b(1) b(end) a(end)-a(1)+1 b(end)-b(1)+1];
                    end
                elseif (firstcolumn - lastcolumn) > spaceHeight 
                    if B(5) > spaceHeight+3*lineHeight
                        setOpenNotehead = [setOpenNotehead; B];
                    end
                    if B1(5) > spaceHeight+3*lineHeight
                        setOpenNotehead = [setOpenNotehead; B1];
                    end
                end
                break;

            elseif j == size(A,1) || j == size(A,1) + 1
                break;
            end
        end
    elseif size(A,1) == 2
        B  = A(1,:);
        B1 = A(2,:);
        lastcolumn = B(4);
        firstcolumn = B1(3);

        %If they are closed
        if (firstcolumn - lastcolumn) < spaceHeight
            widthfirst = B(5);
            widthsecond = B1(5);

            heightfirst = B(6);
            heightsecond = B1(6);

            if abs(widthfirst - widthsecond) < threshold && abs(heightfirst - heightsecond) < threshold
                a = [B(1:2) B1(1:2)];
                a = sort(a);
                b = [B(3:4) B1(3:4)];
                b = sort(b);
                setOpenNotehead = [setOpenNotehead; a(1) a(end) b(1) b(end) a(end)-a(1)+1 b(end)-b(1)+1];
            end
        elseif (firstcolumn - lastcolumn) > spaceHeight
            if B(5) > spaceHeight+3*lineHeight
                setOpenNotehead = [setOpenNotehead; B];
            end
            if B1(5) > spaceHeight+3*lineHeight
                setOpenNotehead = [setOpenNotehead; B1];
            end
        end
    elseif size(A,1) == 1
        B  = A(1,:);
        if B(5) > spaceHeight+3*lineHeight
            setOpenNotehead = [setOpenNotehead; B];
        end
    end
end

OpenNotehead = [];
%Verificar o numero de pixeis brancos
for i=1:size(setOpenNotehead,1)
   newSymbol = setOpenNotehead(i,:);
   img = imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));   
   numberWhitePixels = sum(img(:));
   sImage = length(img(:));
   %numberBlackPixels =  sImage - numberWhitePixels;
   
   %70% do tamanho da imagem tem de ser constituida por brancos
   %30% do tamanho da imagem tem de ser constituida por pretos
   if numberWhitePixels > round(sImage*val_whitepixels) 
       OpenNotehead = [OpenNotehead; newSymbol];
   end
end

% imwrite(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,'imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals.png','png')
% for i=1:size(sy,2)
%     sy1 = cell2mat(sy(i));
%     for j=1:size(sy1,1)
%         imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals(sy1(j,1):sy1(j,2), sy1(j,3):sy1(j,4)) = 0.5;
%     end
% end
% imwrite(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals,'imgWithoutBeam
% sOpenNoteHeadsStemsFlagsAccidentals1.png','png')