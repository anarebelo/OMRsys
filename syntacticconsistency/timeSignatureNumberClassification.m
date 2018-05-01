function [dataUp dataDown]= timeSignatureNumberClassification(img,typeofmodel)

switch typeofmodel
    case 'svm'
        dataUp=[];
        dataDown=[];
        
        [row, col] = size(img);
        a = round(row/2);
        imgUp = img(1:a,:);
        imgDown = img(a+1:end,:);
        
        
        projY = size(imgUp,1)-sum(imgUp);
        positionZero = find(projY==0);
        if length(positionZero) ~= 0
            aux = diff(positionZero);
            idx = find(aux~=1);
            
            vect = [];
            for j=1:size(idx,2)
                vect = [vect; positionZero(idx(j))+1 positionZero(idx(j)+1)-1];
            end
            maximus = [];
            maximusPos = [];
            for j=1:size(vect,1)
                [valueMax idx] = max(projY(vect(j,1):vect(j,2)));
                maximus = [maximus; valueMax];
                maximusPos = [maximusPos; idx+vect(j,1)-1];
            end
            
            if size(maximus,1) > 1
                %Split the image
                for j=1:size(vect,1)
                    imgUpSplit = imgUp(:,vect(j,1)-2:vect(j,2)+2);
                    datafeatures = geometricproperties(1-imgUpSplit);
                    valueMax=max(max(datafeatures));
                    valueMin=min(min(datafeatures));
                    datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                    datafeatures =[datafeatures blurred_shape_model(imgUpSplit)];
                    dataUp  = [dataUp; imgUpSplit(:)' datafeatures];
                end
            else
                datafeatures = geometricproperties(1-imgUp);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(imgUp)];
                dataUp  = [dataUp; imgUp(:)' datafeatures];
            end
        else
            datafeatures = geometricproperties(1-imgUp);
            valueMax=max(max(datafeatures));
            valueMin=min(min(datafeatures));
            datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
            datafeatures =[datafeatures blurred_shape_model(imgUp)];
            dataUp  = [dataUp; imgUp(:)' datafeatures];
        end
        projY = size(imgDown,1)-sum(imgDown);
        positionZero = find(projY==0);
        
        if length(positionZero) ~= 0
            aux = diff(positionZero);
            idx = find(aux~=1);
            
            vect = [];
            for j=1:size(idx,2)
                vect = [vect; positionZero(idx(j))+1 positionZero(idx(j)+1)-1];
            end
            maximus = [];
            maximusPos = [];
            for j=1:size(vect,1)
                [valueMax idx] = max(projY(vect(j,1):vect(j,2)));
                maximus = [maximus; valueMax];
                maximusPos = [maximusPos; idx+vect(j,1)-1];
            end
            
            if size(maximus,1) > 1
                %Split the image
                for j=1:size(vect,1)
                    imgDownSplit = imgDown(:,vect(j,1)-2:vect(j,2)+2);
                    datafeatures = geometricproperties(1-imgDownSplit);
                    valueMax=max(max(datafeatures));
                    valueMin=min(min(datafeatures));
                    datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                    datafeatures =[datafeatures blurred_shape_model(imgDownSplit)];
                    dataDown  = [dataDown; imgDownSplit(:)' datafeatures];
                end
            else
                datafeatures = geometricproperties(1-imgDown);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(imgDown)];
                dataDown  = [dataDown; imgDown(:)' datafeatures];
            end
        else
            datafeatures = geometricproperties(1-imgDown);
            valueMax=max(max(datafeatures));
            valueMin=min(min(datafeatures));
            datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
            datafeatures =[datafeatures blurred_shape_model(imgDown)];
            dataDown  = [dataDown; imgDown(:)' datafeatures];
        end
    case 'nn'
        dataUp=[];
        dataDown=[];
        
        [row, col] = size(img);
        a = round(row/2);
        imgUp = img(1:a,:);
        imgDown = img(a+1:end,:);
        
        
        projY = size(imgUp,1)-sum(imgUp);
        positionZero = find(projY==0);
        if length(positionZero) ~= 0
            aux = diff(positionZero);
            idx = find(aux~=1);
            
            vect = [];
            for j=1:size(idx,2)
                vect = [vect; positionZero(idx(j))+1 positionZero(idx(j)+1)-1];
            end
            maximus = [];
            maximusPos = [];
            for j=1:size(vect,1)
                [valueMax idx] = max(projY(vect(j,1):vect(j,2)));
                maximus = [maximus; valueMax];
                maximusPos = [maximusPos; idx+vect(j,1)-1];
            end
            
            if size(maximus,1) > 1
                %Split the image
                for j=1:size(vect,1)
                    imgUpSplit = imgUp(:,vect(j,1)-2:vect(j,2)+2);
                    imgUpSplit = imresize(imgUpSplit,[20 20]);
                    dataUp  = [dataUp imgUpSplit(:)];
                    
                end
            else
                imgUp = imresize(imgUp,[20 20]);
                dataUp  = [dataUp imgUp(:)];       
            end
        else
            imgUp = imresize(imgUp,[20 20]);
            dataUp  = [dataUp imgUp(:)]; 
        end
        projY = size(imgDown,1)-sum(imgDown);
        positionZero = find(projY==0);
        
        if length(positionZero) ~= 0
            aux = diff(positionZero);
            idx = find(aux~=1);
            
            vect = [];
            for j=1:size(idx,2)
                vect = [vect; positionZero(idx(j))+1 positionZero(idx(j)+1)-1];
            end
            maximus = [];
            maximusPos = [];
            for j=1:size(vect,1)
                [valueMax idx] = max(projY(vect(j,1):vect(j,2)));
                maximus = [maximus; valueMax];
                maximusPos = [maximusPos; idx+vect(j,1)-1];
            end
            
            if size(maximus,1) > 1
                %Split the image
                for j=1:size(vect,1)
                    imgDownSplit = imgDown(:,vect(j,1)-2:vect(j,2)+2);
                    imgDownSplit = imresize(imgDownSplit,[20 20]);
                    dataDown  = [dataDown imgDownSplit(:)];
                end
            else
                imgDown = imresize(imgDown,[20 20]);
                dataDown  = [dataDown imgDown(:)];
            end
        else
            imgDown = imresize(imgDown,[20 20]);
            dataDown  = [dataDown imgDown(:)];
        end
end
