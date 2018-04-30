function [data, symbolsposition] = datasetforclassification(symbols, type, score)
global typeofmodel
global specialsymbol

switch typeofmodel
    case 'svm'
        data  = [];
        symbolsposition = [];
        if strcmp('noteheads',type)
            for j=1:size(symbols,1)
                nH = cell2mat(symbols(j,1));
                stem = cell2mat(symbols(j,2));
                flag = cell2mat(symbols(j,4));
                
                k = stem(:,1:2);
                if size(k,1)>1
                    k = k(:)';
                end
                if size(flag,1) ==0
                    v = [nH(1:2) k];
                    v = sort(v);
                    symbol=[v(1) v(end) nH(3) nH(4) (nH(4)-nH(3)+1) (v(end)-v(1)+1)];
                else
                    v = [nH(1:2) k];
                    v = sort(v);
                    vv = [nH(3:4) flag(3:4)];
                    vv = sort(vv);
                    symbol=[v(1) v(end) vv(1) vv(end) (vv(end)-vv(1)+1) (v(end)-v(1)+1)];
                end
                a = max(symbol(3)-5,1);
                b = min(symbol(4)+5,size(score,2));
                
                img = score(symbol(1):symbol(2),a:b);
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(1) symbols(2) a b];
            end
        elseif strcmp('openNoteheads',type)
            for j=1:size(symbols,1)
                nH = cell2mat(symbols(j,1));
                stem = cell2mat(symbols(j,2));
                flag = cell2mat(symbols(j,4));
                
                k = stem(:,1:2);
                if size(k,1)>1
                    k = k(:)';
                end
                if size(flag,1) ==0
                    v = [nH(1:2) k];
                    v = sort(v);
                    symbol=[v(1) v(end) nH(3) nH(4) (nH(4)-nH(3)+1) (v(end)-v(1)+1)];
                else
                    v = [nH(1:2) k];
                    v = sort(v);
                    vv = [nH(3:4) flag(3:4)];
                    vv = sort(vv);
                    symbol=[v(1) v(end) vv(1) vv(end) (vv(end)-vv(1)+1) (v(end)-v(1)+1)];
                end
                %
                a = max(symbol(3)-5,1);
                b = min(symbol(4)+5,size(score,2));
                
                img = score(symbol(1):symbol(2),a:b);
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(1) symbols(2) a b];
            end
        elseif strcmp('beams',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('barlines',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('TimeSignature',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('accents',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('rests',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('wholerests',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('halfrests',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('doublewholerests',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('dots',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('keySignature',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('clefs',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('accidentals',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('openNoteheadsI',type)
            for i=1:size(symbols,1)
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                %Escalar dados entre [-1 1]
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                data  = [data; img(:)' datafeatures];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        end
    case 'nn'
        data  = [];
        symbolsposition = [];
        if strcmp('noteheads',type)
            for j=1:size(symbols,1)
                nH = cell2mat(symbols(j,1));
                stem = cell2mat(symbols(j,2));
                flag = cell2mat(symbols(j,4));
                
                k = stem(:,1:2);
                if size(k,1)>1
                    k = k(:)';
                end
                if size(flag,1) ==0
                    v = [nH(1:2) k];
                    v = sort(v);
                    symbol=[v(1) v(end) nH(3) nH(4) (nH(4)-nH(3)+1) (v(end)-v(1)+1)];
                else
                    v = [nH(1:2) k];
                    v = sort(v);
                    vv = [nH(3:4) flag(3:4)];
                    vv = sort(vv);
                    symbol=[v(1) v(end) vv(1) vv(end) (vv(end)-vv(1)+1) (v(end)-v(1)+1)];
                end
                a = max(symbol(3)-5,1);
                b = min(symbol(4)+5,size(score,2));
                
                img = score(symbol(1):symbol(2),a:b);
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbol(1) symbol(2) a b];
                specialsymbol = [specialsymbol; nH(1:4)];
            end
        elseif strcmp('openNoteheads',type)
            for j=1:size(symbols,1)
                nH = cell2mat(symbols(j,1));
                stem = cell2mat(symbols(j,2));
                flag = cell2mat(symbols(j,4));
                
                k = stem(:,1:2);
                if size(k,1)>1
                    k = k(:)';
                end
                if size(flag,1) ==0
                    v = [nH(1:2) k];
                    v = sort(v);
                    symbol=[v(1) v(end) nH(3) nH(4) (nH(4)-nH(3)+1) (v(end)-v(1)+1)];
                else
                    v = [nH(1:2) k];
                    v = sort(v);
                    vv = [nH(3:4) flag(3:4)];
                    vv = sort(vv);
                    symbol=[v(1) v(end) vv(1) vv(end) (vv(end)-vv(1)+1) (v(end)-v(1)+1)];
                end
                %
                a = max(symbol(3)-5,1);
                b = min(symbol(4)+5,size(score,2));
                
                img = score(symbol(1):symbol(2),a:b);
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition;  symbol(1) symbol(2) a b];
                specialsymbol = [specialsymbol; nH(1:4)];
            end
        elseif strcmp('beams',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('barlines',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('TimeSignature',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('accents',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('rests',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('wholerests',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('halfrests',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('doublewholerests',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('dots',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('keySignature',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('clefs',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('accidentals',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        elseif strcmp('openNoteheadsI',type)
            for i=1:size(symbols,1)
                if symbols(i,2) > size(score,1)
                    symbols(i,2) = size(score,1);
                end
                if symbols(i,4) > size(score,2)
                    symbols(i,4) = size(score,2);
                end
                img = score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                if islogical(img)==0
                    t=graythresh(img);
                    img=im2bw(img,t);
                end
                img= imresize(img, [20 20]);
                data  = [data img(:)];
                symbolsposition = [symbolsposition; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
                specialsymbol = [specialsymbol; symbols(i,1) symbols(i,2) symbols(i,3) symbols(i,4)];
            end
        end
end