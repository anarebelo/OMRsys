function restsClass = findSymbolRestsBackup(image,lineHeight,spaceHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff,vectorParametersRests,data_staffinfo_sets)
global visitedMatrix

value = spaceHeight;

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
t1 = floor((a-1)/spaceHeight);

%Significa que posso construir 5 linhas suplementares
if t1 > 5
    vv = 1:5;
    vv = vv*spaceHeight;
    vv = vv';
    dataY11 = repmat(dataY11,5,1) - repmat(vv,1,size(dataY11,2));
    dataX11 = repmat(dataX11,5,1) - repmat(vv,1,size(dataX11,2));
else
    vv = 1:t1;
    vv = vv*spaceHeight;
    vv = vv';
    dataY11 = repmat(dataY11,t1,1) - repmat(vv,1,size(dataY11,2));
    dataX11 = repmat(dataX11,t1,1) - repmat(vv,1,size(dataX11,2));
end


%Last line
dataY12 = dataY(min(vect1+(numberLines-1),size(dataY,1)),:);
dataX12 = dataX(min(vect1+(numberLines-1),size(dataX,1)),:);

%Evitar que ultrapasse a altura da imagem
a = max(dataY12);
t2 = floor((a-1)/spaceHeight);

%Significa que posso construir 5 linhas suplementares
if t2 > 5
    vv = 1:5;
    vv = vv*spaceHeight;
    vv = vv';
    dataY12 = repmat(dataY12,5,1) + repmat(vv,1,size(dataY12,2));
    dataX12 = repmat(dataX12,5,1) + repmat(vv,1,size(dataX11,2));
else
    vv = 1:t2;
    vv = vv*spaceHeight;
    vv = vv';
    dataY12 = repmat(dataY12,t2,1) + repmat(vv,1,size(dataY12,2));
    dataX12 = repmat(dataX12,t2,1) + repmat(vv,1,size(dataX12,2));
end

dataY1 = [dataY11; dataY12];
dataX1 = [dataX11; dataX12];

dataY = dataY(vect1:min(vect1+(numberLines-1),size(dataY,1)),:);
dataX = dataX(vect1:min(vect1+(numberLines-1),size(dataX,1)),:);

% size(image)
% pause

possibleRest = zeros(1,4);
valueXAux=dataX(1,1);
restsClass = [];
%For each staffline
for i=1:size(dataY,2)
    %column
    valueX=dataX(1,i);
    column = valueX-valueXAux;

    if column-lineHeight < possibleRest(end,4)
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


    a = max(1,row1);
    b = min(row2,size(image,1));
    c = max(1,column);
    d = min(column+2*spaceHeight,size(image,2));
    
    img = image(a:b,c:d);  
%     image_aux = image;
%     image_aux(a:b,c:d) = 0.5;
    
    zerosimg = find(img(:)==0);
    if size(zerosimg,1)~=0 && length(zerosimg) > 2*spaceHeight
        [rr cc]=find(img==0);
        point=[rr(1)+a-1 cc(1)+c-1];

        threshold = spaceHeight;
        [h,w]=size(image);
        visitedMatrix=ones([h,w]);
        [object,flagcontrolsize]=BreadthFirstSearch_controlsize(point, w, h, image, threshold,spaceHeight);

        if flagcontrolsize == 1
            possibleRest(4) = column+6*spaceHeight;
            continue
        end
        
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
                img = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
                
                
                yProjRef = (size(img,2)-sum(img'))';
                if size(yProjRef,1) == 0
                    continue
                end

                len = rle(ismember(yProjRef,0)');
                white = len(1:2:end);
                position = find(white>spaceHeight/2);
                idxinitial = [];
                idxfinal = [];
                if length(position)~=0  
                    for j=1:size(position,2);
                        value = white(position(j));
                        aux = find(value == len);
                        idxinitial = [idxinitial len(aux-1)];
                        idxfinal = [idxfinal len(aux)+len(aux-1)];
                    end
                end
                if size(idxfinal,2) == 1
                    if abs(size(img,1) - idxfinal(j)) > spaceHeight
                        newSymbol = [newSymbol(1)+idxfinal(1) newSymbol(2) newSymbol(3) newSymbol(4)];
                        img = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
                    else
                        newSymbol = [newSymbol(1) newSymbol(2)-idxinitial(1) newSymbol(3) newSymbol(4)];
                        img = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
                    end
                elseif size(idxfinal,2) == 2
                    newSymbol = [newSymbol(1)+idxfinal(1) newSymbol(2)-idxinitial(2) newSymbol(3) newSymbol(4)];
                    img = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
                end
                
                corrMax = 0;
                c = 1;
                column = size(img,2);
%                 column = 1;

                %Procurar pausas usando correlação
                while corrMax < 0.3
%                     d = min(column+spaceHeight,size(img,2));
                    d = max(1,column);

                    imgInput = img(:,c:d);
                    %Before applied the matrix correlation function join
                    %the split symbols
%                     imshow(imgInput)
                    [imgInput, thresholdparam]=joinsymbols(imgInput,spaceHeight);
%                     figure, imshow(imgInput)
                    if size(imgInput,1) == 0 || size(imgInput,2) == 0
                        break
                    end
                    matrixPixels = matrixCorrelation(imgInput);

                    quarter  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(1))));
                    quaver = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(2))));
                    semiquaver   = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(3))));
                    demisemiquaver  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(4))));
                    hemidemisemiquaver  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(5))));

                    corrMax = max([quarter,quaver,semiquaver,demisemiquaver,hemidemisemiquaver]);
%                     pause
%                     close all
                    column = column - spaceHeight;
%                     column = column + spaceHeight;
                    if d <= spaceHeight/2
%                     if d == size(img,2)
                        break;
                    end
                end

                if corrMax >= 0.3
                    possibleRest = [newSymbol(1) newSymbol(2) newSymbol(3) newSymbol(3)+d (newSymbol(3)+d-newSymbol(3)+1) (newSymbol(2)-newSymbol(1)+1)];
                    if possibleRest(2) <= possibleRest(1) || possibleRest(4)<= possibleRest(4)
                        possibleRest(4) = column+2*spaceHeight;
                    else
                        symbol = extractPointsRest(image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)),thresholdparam-1,spaceHeight);
                        if symbol == 1
                            restsClass = [restsClass; possibleRest];
                        end
                        image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)) = 1;
                    end
                else
                    image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)) = 1;
                    possibleRest = zeros(1,4);
                    possibleRest(4) = column+newSymbol(4);
                end   
            else
                possibleRest(4) = column+2*spaceHeight;
            end
        else
            possibleRest(4) = column+2*spaceHeight;
        end
    end
    
end

% imwrite(image,'xx.png','png')

if t1 ~= 0
    if t2 == 0
        dataX1_1 = dataX1;
        dataY1_1 = dataY1;
    else
        dataX1_1 = dataX1(1:numberLines,:);
        dataY1_1 = dataY1(1:numberLines,:);
    end
    N = size(dataY1_1,2);
    valueXAux = dataX1_1(1,1);
else
    N = 0;
end

%ledger lines
possibleRest = zeros(1,4);
for i=1:N
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
  
    zerosimg = find(img(:)==0);
    if size(zerosimg,1)~=0 && length(zerosimg) > 2*spaceHeight
        [rr cc]=find(img==0);
        point=[rr(1)+a-1 cc(1)+c-1];

        threshold = spaceHeight;
        [h,w]=size(image);
        visitedMatrix=ones([h,w]);
        [object,flagcontrolsize]=BreadthFirstSearch_controlsize(point, w, h, image, threshold,spaceHeight);
        
        if flagcontrolsize == 1
            possibleRest(4) = column+6*spaceHeight;
            continue
        end
        
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
                img = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
                
                corrMax = 0;
                c = 1;
                column = size(img,2);
                %Procurar pausas usando correlação
                while corrMax < 0.3
                    d = max(1,column);

                    imgInput = img(:,c:d);
                    [imgInput, thresholdparam]=joinsymbols(imgInput,spaceHeight);
                    if size(imgInput,1) == 0 || size(imgInput,2) == 0
                        break
                    end
                    matrixPixels = matrixCorrelation(imgInput);

                    quarter  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(1))));
                    quaver = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(2))));
                    semiquaver   = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(3))));
                    demisemiquaver  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(4))));
                    hemidemisemiquaver  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(5))));

                    corrMax = max([quarter,quaver,semiquaver,demisemiquaver,hemidemisemiquaver]);
                    column = column - spaceHeight;

                    if d == spaceHeight/2 || column < 0
                        break;
                    end
                end
  
                if corrMax >= 0.3
                    possibleRest = [newSymbol(1) newSymbol(2) newSymbol(3) newSymbol(3)+d (newSymbol(3)+d-newSymbol(3)+1) (newSymbol(2)-newSymbol(1)+1)];
                    if possibleRest(2) <= possibleRest(1) || possibleRest(4)<= possibleRest(4)
                        possibleRest(4) = column+d;
                    else
                    symbol = extractPointsRest(image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)),thresholdparam-1,spaceHeight);
                    if symbol == 1
                        restsClass = [restsClass; possibleRest];
                    end
                    image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)) = 1;      
                    end
                else
                    image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)) = 1;
                    possibleRest = zeros(1,4);
                    possibleRest(4) = column+newSymbol(4);
                end  
            else
                possibleRest(4) = column+d;
            end
        else
            possibleRest(4) = column+d;
        end
    end    
end



if t2 ~= 0
    if t1==0
        dataX1_2 = dataX1;
        dataY1_2 = dataY1;
    else
        dataX1_2 = dataX1(numberLines+1:end,:);
        dataY1_2 = dataY1(numberLines+1:end,:);
    end
    N = size(dataY1_2,2);
    valueXAux = dataX1_2(1,1);
else
    N = 0;
end

%ledger lines
possibleRest = zeros(1,4);
for i=1:N
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
    
    zerosimg = find(img(:)==0);
    if size(zerosimg,1)~=0 && length(zerosimg) > 2*spaceHeight
        [rr cc]=find(img==0);
        point=[rr(1)+a-1 cc(1)+c-1];

        [h,w]=size(image);
        visitedMatrix=ones([h,w]);
        threshold = spaceHeight;
        [object,flagcontrolsize]=BreadthFirstSearch_controlsize(point, w, h, image, threshold,spaceHeight);
        
        if flagcontrolsize == 1
            possibleRest(4) = column+6*spaceHeight;
            continue
        end
        
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
                img = image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4));
                        
                corrMax = 0;
                c = 1;
                column = size(img,2);
                %Procurar pausas usando correlação
                while corrMax < 0.3
                    d = max(1,column);

                    imgInput = img(:,c:d); 
                    [imgInput, thresholdparam]=joinsymbols(imgInput,spaceHeight);
                    if size(imgInput,1) == 0 || size(imgInput,2) == 0
                        break
                    end
                    matrixPixels = matrixCorrelation(imgInput);

                    quarter  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(1))));
                    quaver = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(2))));
                    semiquaver   = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(3))));
                    demisemiquaver  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(4))));
                    hemidemisemiquaver  = abs(corr2(matrixPixels,cell2mat(vectorParametersRests(5))));

                    corrMax = max([quarter,quaver,semiquaver,demisemiquaver,hemidemisemiquaver]);
                    column = column - spaceHeight;
                    
                    if d == spaceHeight/2 || column < 0
                        break;
                    end
                end
                
                if corrMax >= 0.3
                    possibleRest = [newSymbol(1) newSymbol(2) newSymbol(3) newSymbol(3)+d (newSymbol(3)+d-newSymbol(3)+1) (newSymbol(2)-newSymbol(1)+1)];
                    if possibleRest(2) <= possibleRest(1) || possibleRest(4)<= possibleRest(4)
                        possibleRest(4) = column+d;
                    else
                        symbol = extractPointsRest(image(possibleRest(1):possibleRest(2),possibleRest(3):possibleRest(4)),thresholdparam-1,spaceHeight);
                        if symbol == 1
                            restsClass = [restsClass; possibleRest];
                        end
                        image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)) = 1;
                    end
                else
                    image(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)) = 1;
                    possibleRest = zeros(1,4);
                end          
            end
        end
    end
end




