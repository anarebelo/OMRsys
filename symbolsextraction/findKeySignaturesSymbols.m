function [keySignatureClass] = findKeySignaturesSymbols(scoreWithoutClefs,dataY,dataX,numberOfstaff,initialpositions,spaceHeight,lineHeight,numberLines,ClefsClass,data_staffinfo_sets)
keySignatureClass = [];
global visitedMatrix

%Close distance between key signatures
%Equal size

[h,w]=size(scoreWithoutClefs);
visitedMatrix=ones([h,w]);

vect = cumsum(data_staffinfo_sets);
if numberOfstaff == 1
    vect1=1;
else
    vect1 = vect(numberOfstaff-1)+1;
end

dataY = dataY(vect1:vect1+(numberLines-1),:);
dataX = dataX(vect1:vect1+(numberLines-1),:);

thresholdMax = spaceHeight/2;
thresholdMin = spaceHeight/3;
keySigCount = 0;
flag = 0;
flagcontrolsize = 0;
%For each staffline
for i=1:size(dataY,1)
    %row
    valueY=dataY(i,:);
    valueY=valueY(find(valueY~=0));
    %column
    valueX=dataX(i,:);
    valueX=valueX(find(valueX~=0));
    th = valueX(1);
    
    for j=1:size(valueY,2)

        row = valueY(j)-initialpositions(numberOfstaff);
        column = valueX(j)-th;

        if column < ClefsClass(4)
            continue
        end

        a = max(1,row-spaceHeight);
        b = min(row+spaceHeight,size(scoreWithoutClefs,1));
        c = max(1,column-2*lineHeight);
        d = min(column+2*lineHeight,size(scoreWithoutClefs,2));

        img1 = scoreWithoutClefs(a:b,c:d);
        
        if size(find(img1(:)==0),1)~=0
            [rr cc]=find(img1==0);
            point=[rr(1)+a-1 cc(1)+c-1];

            [object,flagcontrolsize]=BreadthFirstSearch_controlsize(point, w, h, scoreWithoutClefs, 3,spaceHeight);
			
			if flagcontrolsize == 1
% 				keySignatureClass = [];
				return
			end

            if size(object,1)~=0
                [newSymbol]=findTS(object,spaceHeight);
                
                if size(newSymbol,1)~=0
                    % distance between clef and symbol
                    if flag == 0
                        distance = newSymbol(3)-ClefsClass(4);                     
                        if distance < 3*spaceHeight && newSymbol(5) < 2*spaceHeight && newSymbol(6) < 4*spaceHeight+2*lineHeight % width and height  
                            keySignatureClass = [keySignatureClass; newSymbol];
                            keySigCount = keySigCount + 1;
                            %                             figure, imshow(scoreWithoutClefs(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)))
                        else
                            %Do not exist more key signatures symbols in this row
                            break
                        end
                        flag = 1;
                    else
                        % distance between objects
                        distance_aux = newSymbol(3)-keySignatureClass(end,4);
                        if distance_aux > 0
                            distance = distance_aux;
                        else
                            distance = keySignatureClass(end,3) - newSymbol(4);
                        end
                         
                        if distance < thresholdMax && newSymbol(5) < 2*spaceHeight && newSymbol(6) < 4*spaceHeight+2*lineHeight % width and height  
                            keySignatureClass = [keySignatureClass; newSymbol];
                            keySigCount = keySigCount + 1;
                            %                             figure, imshow(scoreWithoutClefs(newSymbol(1):newSymbol(2),newSymbol(3):newSymbol(4)))
                        else
                            %Do not exist more key signatures symbols in this row
                            break
                        end
                    end
                end
            end
        end
        if keySigCount > 6
            %Do not exist more key signatures symbols
            return
        end
    end
end

return