function [clefs] = findClefsSymbols(img,dataY,dataX,numberOfstaff,initialpositions,spaceHeight,lineHeight,numberLines,controlParameters,data_staffinfo_sets,brace)
global visitedMatrix

flagcontrolsize = 0;
if size(controlParameters,1) == 0
    vect = cumsum(data_staffinfo_sets);
    if numberOfstaff == 1
        vect1=1;
    else
        vect1 = vect(numberOfstaff-1)+1;
    end

    dataY = dataY(vect1:min(vect1+(numberLines-1),size(dataY,1)),:);
    dataX = dataX(vect1:min(vect1+(numberLines-1),size(dataX,1)),:);
    
    %diminuir threshold
    flag = 0;
    %Remove high vertical black runs in the beginning of the score
    %tam = round(size(img,1)/2)
    tam = dataY(1,round(numberLines/2))-initialpositions(numberOfstaff);
    [~,positioncolumn] = find(img(tam,:) == 0,1);

    if brace == 0
        img1 = img(:,positioncolumn:positioncolumn+round(spaceHeight/2));
        [img1, stem]=removeSTEM(img1,2*spaceHeight); 
        img(:,positioncolumn:positioncolumn+round(spaceHeight/2)) = img1;
    else
        img1 = img(:,positioncolumn:positioncolumn+spaceHeight);
        [img1, stem]=removeSTEM(img1,2*spaceHeight); 
        img(:,positioncolumn:positioncolumn+spaceHeight) = img1;
    end
    
    [h,w]=size(img);
    visitedMatrix=ones([h,w]);

    clefs = [];
    width = 0;
    %For each staffline
    
    for i=1:round(size(dataY,1))
        %row
        valueY=dataY(i,:);
        valueY=valueY(find(valueY~=0));
        %column
        valueX=dataX(i,:);
        valueX=valueX(find(valueX~=0));
        th = valueX(1);
        
        
        for j=1:round(size(valueY,2))

            row = valueY(j)-initialpositions(numberOfstaff);
            column = valueX(j)-th;

            a = max(1,row-spaceHeight);
            b = min(row+spaceHeight,size(img,1));
            c = max(1,column-2*lineHeight);
            d = min(column+2*lineHeight,size(img,2));

            img1 = img(a:b,c:d);

            if size(find(img1(:)==0),1)~=0
                [rr cc]=find(img1==0);
                point=[rr(1)+a-1 cc(1)+c-1];
                
                count = 0;
                threshold = spaceHeight/2;
                while width < 3*spaceHeight
                    [object,flagcontrolsize]=BreadthFirstSearch_controlsize(point, w, h, img, threshold,spaceHeight);
					
					if flagcontrolsize == 1
% 						clefs = []; 
						return
					end
                    if size(object,1)~=0
                        [newSymbol,flag]=findClefs(object,spaceHeight,flag);
                        
                        if size(newSymbol,1)~=0
                            width = newSymbol(5);
                        end
                    end
                    
                    visitedMatrix=ones([h,w]);
                    if flag == 0
                        threshold = threshold+5;
                    elseif flag == 1
                        threshold = threshold-1;
                        if threshold <0
                            threshold = 0;
                            count = count+1;
                        end
                    end
                    if count == 2
                        clefs = newSymbol;
                        return
                    end 
                end
                clefs = newSymbol;
                return
            end
        end
    end
else
    %Remove high vertical black runs in the beginning of the score
    img1 = img(:,1:round(spaceHeight/2));
    [img1, stem]=removeSTEM(img1,2*spaceHeight);
    
    img(:,1:round(spaceHeight/2)) = img1;
    
    [h,w]=size(img);
    visitedMatrix=ones([h,w]);

    vect = cumsum(data_staffinfo_sets);
    if numberOfstaff == 1
        vect1=1;
    else
        vect1 = vect(numberOfstaff-1)+1;
    end
    dataY = dataY(vect1:min(vect1+(numberLines-1),size(dataY,1)),:);
    dataX = dataX(vect1:min(vect1+(numberLines-1),size(dataX,1)),:);
    
    
    %initial row
    valueY=dataY(1,:);
    valueY=valueY(find(valueY~=0,1));
    row1 = valueY - initialpositions(numberOfstaff);
    
    %final row
    valueY=dataY(end,:);
    valueY=valueY(find(valueY~=0,1));
    row2 = valueY - initialpositions(numberOfstaff);
    
    %column   
    a = max(1,round(row1-3/2*spaceHeight));
    b = min(round(row2+3/2*spaceHeight),size(img,1));
    c = 1;
    column = c;
    corrMax = 0;
    
    
    stopCrit = 0;
    %Procurar a clave usando correlação
    while corrMax < 0.5
        d = min(column+spaceHeight,size(img,2));
        
        imgInput = img(a:b,c:d);  
        if size(find(imgInput(:) == 0),1)~=0
            matrixPixels = matrixCorrelation(imgInput);
            
            rTreble  = abs(corr2(matrixPixels,cell2mat(controlParameters(1))));
            rBass = abs(corr2(matrixPixels,cell2mat(controlParameters(2))));
            rDo   = abs(corr2(matrixPixels,cell2mat(controlParameters(3))));
            
            corrMax = max([rTreble,rBass,rDo]);
            column = column + spaceHeight;
            
            stopCrit = stopCrit + 1;
            if stopCrit > size(img,2)*0.2
                clefs = [];
                return;
            end
        else
            c = d;
            column = column + spaceHeight;
        end   
        if column > 7*spaceHeight
           clefs = [];
           return;
        end
    end
    
    if isnan(corrMax) == 1
         clefs = [];
         return;
    end
    
    %Procurar inicio e fim da clave em coluna
    aux = round(size(imgInput,1)/2);
    newImg = imgInput(aux-2*spaceHeight:aux+2*spaceHeight,:);
    [rw, cl] = find(newImg == 0,1);
    newImg1 = newImg(:,end:-1:1);
    [rw1, cl1] = find(newImg1 == 0,1);
    a2 = size(newImg,2)-cl1;
    symbol = imgInput(:,cl:a2);
    
    %Procurar inicio e fim da clave em linha
    symbolAuxInv = symbol'; 
    [rw, cl1] = find(symbolAuxInv == 0,1);
    symbolAuxInv1 = symbolAuxInv(:,end:-1:1);
    [rw1, cl2] = find(symbolAuxInv1 == 0,1);
    a21 = size(symbolAuxInv,2)-cl2;
    
    
%     clef = symbol(cl1:a21,:);
    clefs = [cl1+a-1 a21+a-1 cl+c-1 a2+c-1 a2+c-1-(cl+c-1) a21+a-1-(cl1+a-1)];
end

return