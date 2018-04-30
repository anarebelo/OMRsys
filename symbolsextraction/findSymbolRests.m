function restSymbols = findSymbolRests(image,lineHeight,spaceHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff)
global visitedMatrix


[h,w]=size(image);
visitedMatrix=ones([h,w]);
value = spaceHeight;

vect = 1:numberLines:size(dataY,1);
vect1 = vect(numberOfstaff);

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
dataY12 = dataY(vect1+(numberLines-1),:);
dataX12 = dataX(vect1+(numberLines-1),:);

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

dataY = dataY(vect1:vect1+(numberLines-1),:);
dataX = dataX(vect1:vect1+(numberLines-1),:);

possibleRest = zeros(1,4);
restSymbols = [];
valueXAux=dataX(1,1);


%For each staffline
for i=1:size(dataY,2)
    %column
    valueX=dataX(1,i);
    column = valueX-valueXAux;
    
    if column-lineHeight < possibleRest(4)
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


    a = max(1,row1-2*value);
    b = min(row2+2*value,size(image,1));
    c = max(1,column);
    d = min(column+2*lineHeight,size(image,2));

    img = image(a:b,c:d);
        
%     image(a:b,c:d) = 0.5;
    
    if size(find(img(:)==0),1)~=0
        [rr cc]=find(img==0);
        point=[rr(1)+a-1 cc(1)+c-1];

        width = 0;
        threshold = 1;
        while width < spaceHeight
            [object]=BreadthFirstSearch(point, w, h, image, threshold);

            if size(object,1)~=0
                [newSymbol]=findRests(object,spaceHeight,threshold,image);
                if size(newSymbol,1)~=0
                    %Procurar inicio e fim da pausa em linha
                    possibleSymbol = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)); 
%                     figure, imshow(img)
                    
                    symbolAuxInv = possibleSymbol';
                    [rw, cl1] = find(symbolAuxInv == 0,1);
                    symbolAuxInv1 = symbolAuxInv(:,end:-1:1);
                    [rw1, cl2] = find(symbolAuxInv1 == 0,1);
                    a21 = size(symbolAuxInv,2)-cl2;
                    
                    newSymbol = [cl1+newSymbol(1)-1 a21+newSymbol(1)-1 newSymbol(3) newSymbol(4) newSymbol(5) a21+newSymbol(1)-1-(cl1+newSymbol(1)-1)];
                    
%                     newSymbol
%                     threshold
%                     
%                     figure, imshow(img)
%                     figure, imshow(image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)))
%                     pause
%                     close all
                    
                    width = newSymbol(5);
                end
            end
            visitedMatrix=ones([h,w]);
            threshold = threshold+1;
            if threshold > spaceHeight
                newSymbol = [];
                possibleRest(4) = column + spaceHeight;
                break
            end
        end

        if size(newSymbol,1) ~= 0
%             figure, imshow(image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)))
%             newSymbol
%             threshold-1
            
            if newSymbol(6) < ((numberLines-1)*spaceHeight + numberLines*lineHeight)+spaceHeight & newSymbol(6) > (2*spaceHeight+lineHeight)
                possibleRest = newSymbol;
                imagePossibleRest = image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4));
%                 figure, imshow(imagePossibleRest)
                symbol = extractPointsRest(imagePossibleRest,threshold-1,spaceHeight);
%                 pause
%                 close

                image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)) = 1;
                
                if symbol == 1
                    restSymbols = [restSymbols; possibleRest];
                end
            else
                possibleRest = newSymbol;
                image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)) = 1;
            end

%             pause
%             close
        end
    end

end

% imwrite(image,'xx.png','png')


dataX1_1 = dataX1(1:numberLines,:);
dataY1_1 = dataY1(1:numberLines,:);

%ledger lines
possibleRest = zeros(1,4);
valueXAux = dataX1_1(1,1);
for i=1:size(dataY1_1,2)
    %column
    valueX=dataX1_1(1,i);
    column = valueX - valueXAux;    
    
    if column-lineHeight < possibleRest(4)
        continue
    end
        
    %initial row
    valueY=dataY1_1(1,i);
    if valueY == 0
        break
    end
    row1 = valueY - initialpositions(numberOfstaff);

    %final row
    valueY=dataY1_1(end,i);
    row2 = valueY - initialpositions(numberOfstaff);
    

    a = max(1,row2-spaceHeight);
    b = min(row1+2*spaceHeight,size(image,1));
    c = max(1,column);
    d = min(column+2*lineHeight,size(image,2));

    img = image(a:b,c:d);
    
    
    if size(find(img(:)==0),1)~=0
        [rr cc]=find(img==0);
        point=[rr(1)+a-1 cc(1)+c-1];

        width = 0;
        threshold = 1;
        while width < spaceHeight
            [object]=BreadthFirstSearch(point, w, h, image, threshold);

            if size(object,1)~=0
                [newSymbol]=findRests(object,spaceHeight,threshold,image);
                if size(newSymbol,1)~=0
                    %Procurar inicio e fim da pausa em linha
                    possibleSymbol = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)); 
%                     imshow(possibleSymbol)
%                     pause
%                     close
                    
                    symbolAuxInv = possibleSymbol';
                    [rw, cl1] = find(symbolAuxInv == 0,1);
                    symbolAuxInv1 = symbolAuxInv(:,end:-1:1);
                    [rw1, cl2] = find(symbolAuxInv1 == 0,1);
                    a21 = size(symbolAuxInv,2)-cl2;
                    
                    newSymbol = [cl1+newSymbol(1)-1 a21+newSymbol(1)-1 newSymbol(3) newSymbol(4) newSymbol(5) a21+newSymbol(1)-1-(cl1+newSymbol(1)-1)];
                    width = newSymbol(5);
                end
            end
            visitedMatrix=ones([h,w]);
            threshold = threshold+1;
            if threshold > spaceHeight
                newSymbol = [];
                possibleRest(4) = column + spaceHeight;
                break
            end
        end

        if size(newSymbol,1) ~= 0           
            if newSymbol(6) < ((numberLines-1)*spaceHeight + numberLines*lineHeight)+spaceHeight & newSymbol(6) > (2*spaceHeight + lineHeight);
                possibleRest = newSymbol;
                imagePossibleRest = image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4));
%                 imshow(imagePossibleRest)
                symbol = extractPointsRest(imagePossibleRest,threshold-1,spaceHeight);
%                 pause
%                 close

                image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)) = 1;
                
                if symbol == 1
                    restSymbols = [restSymbols; possibleRest];
                end
            else
                possibleRest = newSymbol;
                image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)) = 1;
            end
        end
    end    
end


dataX1_2 = dataX1(numberLines+1:end,:);
dataY1_2 = dataY1(numberLines+1:end,:);

%ledger lines
possibleRest = zeros(1,4);
valueXAux = dataX1_2(1,1);
for i=1:size(dataY1_2,2)
    %column
    valueX=dataX1_2(1,i);
    column = valueX-valueXAux;    
    
    if column-lineHeight < possibleRest(4)
        continue
    end
        
    %initial row
    valueY=dataY1_2(1,i);
    if valueY == 0
        break
    end
    row1 = valueY - initialpositions(numberOfstaff);

    %final row
    valueY=dataY1_2(end,i);
    row2 = valueY - initialpositions(numberOfstaff);
    

    a = max(1,row1-spaceHeight);
    b = min(row2+2*spaceHeight,size(image,1));
    c = max(1,column);
    d = min(column+2*lineHeight,size(image,2));

    img = image(a:b,c:d);
    
    if size(find(img(:)==0),1)~=0
        [rr cc]=find(img==0);
        point=[rr(1)+a-1 cc(1)+c-1];

        width = 0;
        threshold = 1;
        while width < spaceHeight
            [object]=BreadthFirstSearch(point, w, h, image, threshold);

            if size(object,1)~=0
                [newSymbol]=findRests(object,spaceHeight,threshold,image);
                if size(newSymbol,1)~=0
                    %Procurar inicio e fim da pausa em linha
                    possibleSymbol = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)); 
                    symbolAuxInv = possibleSymbol';
                    [rw, cl1] = find(symbolAuxInv == 0,1);
                    symbolAuxInv1 = symbolAuxInv(:,end:-1:1);
                    [rw1, cl2] = find(symbolAuxInv1 == 0,1);
                    a21 = size(symbolAuxInv,2)-cl2;
                    
                    newSymbol = [cl1+newSymbol(1)-1 a21+newSymbol(1)-1 newSymbol(3) newSymbol(4) newSymbol(5) a21+newSymbol(1)-1-(cl1+newSymbol(1)-1)];
                    width = newSymbol(5);
                end
            end
            visitedMatrix=ones([h,w]);
            threshold = threshold+1;
            if threshold > spaceHeight
                newSymbol = [];
                possibleRest(4) = column + spaceHeight;
                break
            end
        end

        if size(newSymbol,1) ~= 0           
            if newSymbol(6) < ((numberLines-1)*spaceHeight + numberLines*lineHeight)+spaceHeight & newSymbol(6) > (2*spaceHeight + lineHeight)
                possibleRest = newSymbol;
                imagePossibleRest = image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4));
                symbol = extractPointsRest(imagePossibleRest,threshold-1,spaceHeight);

                image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)) = 1;
                
                if symbol == 1
                    restSymbols = [restSymbols; possibleRest];
                end
            else
                possibleRest = newSymbol;
                image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)) = 1;
            end
        end
    end    
end




