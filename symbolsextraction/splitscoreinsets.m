function [musicalScores,initialpositions,initialpositionsFinal,toleranceStaff] = splitscoreinsets(data_staffinfo_sets,dataY,dataX,imageWithoutLines,spaceHeight,numberSpaces)
tolerance = spaceHeight*numberSpaces;
count1=1;
numbersetprevious=0;
toleranceStaff = [];
initialpositions = [];
initialpositionsFinal=[];
musicalScores={};
valueYF = -1;  

for i=1:size(data_staffinfo_sets,2)
    valueYF_previous = valueYF;
    
    numberset = data_staffinfo_sets(i);
    
    dataYY = dataY(count1:numbersetprevious+numberset,:);
    dataXX = dataX(count1:numbersetprevious+numberset,:);
    
    %initial row
    valueY=dataYY(1,:);
    valueYI=valueY(find(valueY~=0));
    
    %final row
    valueY=dataYY(end,:);
    valueYF=valueY(find(valueY~=0));
    
    if length(valueYI) < length(valueYF)
        valueYI_aux = repmat(valueYI(end),1,length(valueYF)-length(valueYI));
        valueYI = [valueYI valueYI_aux];
    else
        valueYF_aux = repmat(valueYF(end),1,length(valueYI)-length(valueYF));
        valueYF = [valueYF valueYF_aux];
    end
    
    %initial column
    valueX=dataXX(1,:);
    valueX=valueX(find(valueX~=0));
    
    if length(valueX) < length(valueYI)
        valueX_aux = valueX(end)+1:(valueX(end)+1)+(length(valueYI)-length(valueX));
        valueX =[valueX valueX_aux];
    end
    
    if i~=1
        newValueY=valueYF_previous;
        if size(newValueY,2)<size(valueYF,2)
            newValueY=[newValueY newValueY(end)*ones(1,size(valueYF,2)-size(newValueY,2))];
        else
            newValueY = newValueY(:,1:size(valueYF,2));
        end
    else
        newValueY=ones(1,length(valueYI));
    end
    
    a = max(1,valueYI - round((valueYI-newValueY+1)./2));
    b = min(valueYF+tolerance,size(imageWithoutLines,1));
    
    img = ones(size(imageWithoutLines));
    for j=1:length(valueYI)
        img(a(j):b(j),valueX(j))=imageWithoutLines(a(j):b(j),valueX(j));
    end
    img = img(min(a):max(b),valueX(1):valueX(end));
    
    musicalScores=[musicalScores img];
    initialpositions=[initialpositions min(a)];
    initialpositionsFinal = [initialpositionsFinal; min(a) valueX(1)];
    %Pautas com inclinação. Saber a distância de um ponto da ultima linha
    %a outro ponto da mesma linha
    toleranceStaff=[toleranceStaff max(b)-min(b)+1];
    
%                 filename=sprintf('symbol%d.png',r);
%                 filename=strcat('lixo\',filename);
%                 imwrite(img, filename,'png')
%                 r=r+1;
%     
    numbersetprevious = numbersetprevious+numberset;
    count1=1+numbersetprevious;
end
