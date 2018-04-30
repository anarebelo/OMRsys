function matrixPixelsSol = matrixCorrelation(imgInput)

[m,n] = size(imgInput);
if m<10 || n<5
   imgInput = imresize(imgInput,[10 5]); 
end

%Criar uma imagem 10 por 5
[row, column]=size(imgInput);

thresholdRow=row/10;
thresholdColumn=column/5;

vectRow = round(1:thresholdRow:row);
vectColumn = round(1:thresholdColumn:column);


matrixPixels = zeros(10,5);
for i=1:length(vectRow)-1
    for j=1:length(vectColumn)-1
        img = imgInput(vectRow(i):vectRow(i+1)-1,vectColumn(j):vectColumn(j+1)-1);
        pixelson = round((length(img(:))-sum(img(:)))/length(img(:))*100);
        matrixPixels(i,j) = pixelson;

        if vectColumn(end) ~= column
            if j == length(vectColumn)-1
                img = imgInput(vectRow(i):vectRow(i+1)-1,vectColumn(j+1):column-1);
                pixelson = round((length(img(:))-sum(img(:)))/length(img(:))*100);
                matrixPixels(i,5) = pixelson;
            end
        end
    end
    if vectRow(end) ~= row
        if i == length(vectRow)-1
            for j=1:length(vectColumn)-1
                img = imgInput(vectRow(i+1):row-1,vectColumn(j):vectColumn(j+1)-1);
                pixelson = round((length(img(:))-sum(img(:)))/length(img(:))*100);
                matrixPixels(10,j) = pixelson;
                if vectColumn(end) ~= column
                    if j == length(vectColumn)-1
                        img = imgInput(vectRow(i+1):row-1,vectColumn(j+1):column-1);
                        pixelson = round((length(img(:))-sum(img(:)))/length(img(:))*100);
                        matrixPixels(10,5) = pixelson;
                    end
                end
            end
        end
    end
end

matrixPixelsSol = matrixPixels;

