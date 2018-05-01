function [imgWithoutStem]=removeLegerLines(imgWithoutStem,spaceHeight,lineHeight,dataY,dataX,numberLines,numberOfstaff,initialpositions,data_staffinfo_sets)



value = round(spaceHeight/2);

vect = cumsum(data_staffinfo_sets);
if numberOfstaff == 1
    vect1=1;
else
    vect1 = vect(numberOfstaff-1)+1;
end

% vect = 1:numberLines:size(dataY,1);
% vect1 = vect(numberOfstaff);

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


%ledger lines
for i=1:size(dataY1,1)
    %row
    valueY=dataY1(i,:);
    valueY=valueY(find(valueY>0));
    %column
    valueX=dataX1(i,:);
    valueX=valueX(find(valueX>0));
    th = valueX(1);
    
    if size(valueY,2) > size(valueX,2)
        valueX = [valueX valueX(end):valueX(end)+(size(valueY,2)-size(valueX,2))];
%         valueX = [valueX repmat(valueX(end),1,size(valueY)-size(valueX))];
    elseif size(valueX,2) > size(valueY,2)
        valueY = [valueY repmat(valueY(end),1,size(valueX,2)-size(valueY,2))];
    end
   
    
    for j=1:size(valueY,2)
 
        row = valueY(j)-initialpositions(numberOfstaff);
        column = min(valueX(j)-th,size(imgWithoutStem,2));

        a = max(1,row-value);
        b = min(row+value,size(imgWithoutStem,1));
        c = max(1,round(column-1.5*spaceHeight));
        d = min(round(column+1.5*spaceHeight),size(imgWithoutStem,2));
        
%         imgWithoutStem(a:b,c:d) = 0.5;
        img = imgWithoutStem(a:b,c:d);
        
        if size(find(img(:)==0),1)~=0
            %Find black run sequence (stem of the note)
            [newImage, st]=removeSTEM(img,size(img,1)-lineHeight);
            if size(st,1) ~= 0
                auxCol = [];
                for m=1:size(st,2)
                    aux = cell2mat(st(m));
                    auxCol = [auxCol aux(end)];
                end
%                 imshow(img)
%                 pause
%                 close
                columnStem = auxCol(end);
                sizeImg = size(img,1);
                initialRow = max(1,round(sizeImg/2)-2*lineHeight);
                finalRow = min(round(sizeImg/2)+2*lineHeight,size(img,1));
                for k=initialRow:finalRow
                    row=img(k,:);
                    col=find(row==0);
                    for m=1:length(col)
                        valueI=max(1,(k-round(3/2*lineHeight)));
                        aux=img(valueI:k,col(m));
                        above=size(aux,1)-sum(aux);
                        valueF=min(size(img,1),k+round(3/2*lineHeight));
                        aux1=img(k:valueF,col(m));
                        under=size(aux1,1)-sum(aux1);
                        %blacksize = above + under;
                        if  (above<=lineHeight && under<=lineHeight) && (abs(col(m)-columnStem) <= 2*spaceHeight)
                            valueI=max(1,k-lineHeight);
                            valueF=min(size(img,1),k+lineHeight);
                            img(valueI:valueF,col(m))=1;
                        end
                    end
                end
                imgWithoutStem(a:b,c:d) = img;
            end
        end
    end
%     filename=sprintf('symbol%d.png',111);
%     filename=strcat('lixo\',filename);
%     imwrite(imgWithoutStem, filename,'png')
%     aaadsadssad
end
