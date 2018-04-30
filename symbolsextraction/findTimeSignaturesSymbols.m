function [TimeSignatureClass] = findTimeSignaturesSymbols(scoreWithoutClefs,dataY,dataX,numberOfstaff,initialpositions,spaceHeight,lineHeight,numberLines,classSymbol,data_staffinfo_sets)
TimeSignatureClass = [];
global visitedMatrix

threshold1 = max(classSymbol(:,4));

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

flagcontrolsize = 0;
%For each staffline
val = round(size(dataY,1)/2);
for i=val:size(dataY,1)
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

        if column < threshold1
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

            [object,flagcontrolsize]=BreadthFirstSearch_controlsize(point, w, h, scoreWithoutClefs, spaceHeight,spaceHeight);
		
			if flagcontrolsize == 1
% 				TimeSignatureClass = [];
				return
			end

            if size(object,1)~=0
                [newSymbol]=findTS(object,spaceHeight);
                newSymbol = [newSymbol(1)  newSymbol(2) newSymbol(3)+spaceHeight newSymbol(4)-spaceHeight newSymbol(4)-spaceHeight-(newSymbol(3)+spaceHeight)+1 newSymbol(6)];
                
                if size(newSymbol,1)~=0
                    distance = newSymbol(3)-threshold1;
                    if distance < 2*spaceHeight && newSymbol(5) < 3*spaceHeight % width
                        TimeSignatureClass = [TimeSignatureClass; newSymbol];
                        return
                    else
                        return
                    end
                end
            end
        end
    end
end

return