function [DATAPROB,data,BarLines] = read_barlines(BarLines,DATAPROB,originalscore)

global SVMStruct
global net
global typeofmodel
global spaceHeight
global lineHeight
global degree_barlines
global imgWithoutSymbols

data=[];
switch typeofmodel
    case 'svm'
        %Classify barlines
        if size(BarLines,1) ~= 0
            [data, class] = datasetforclassification(BarLines, 'barlines',originalscore);
            
            trg=ones(size(class,1),1);
            [predicted_label, accuracy, prob_estimates]= svmpredict(trg, data, SVMStruct,'-b 1');
            DATAPROB = setfield(DATAPROB, 'barlines', prob_estimates);
            
            %if probability is lower than confidence threshold then trust the results from the extraction phase
            idx = find(max(prob_estimates, [], 2) < degree_barlines);
            predicted_label(idx) = 2;
            
            %Because barlines are classified as dots and the difference between
            %both is the height it is necessary to distinguish them using this value
            idx = find(predicted_label == 4);
            for j=1:size(idx,1)
                if BarLines(idx(j),6) > spaceHeight
                    predicted_label(idx(j)) = 2;
                end
            end
        end
        disp(sprintf('Number of barlines: %d', size(predicted_label,1)))
    case 'nn'
        if size(BarLines,1) ~= 0
            [data, ~] = datasetforclassification(BarLines, 'barlines',originalscore);
            
            prob_estimates= sim(net,data);
            [~, predicted_label]=max(prob_estimates);
            
            %if probability is lower than confidence threshold then trust the results from the extraction phase
            idx = find(max(prob_estimates) < degree_barlines);
            predicted_label(idx) = 3;
            
            %Because barlines are classified as dots and the difference between
            %both is the height it is necessary to distinguish them using this value
            idx = find(predicted_label == 7);
            for j=1:size(idx,2)
                if BarLines(idx(j),6) > spaceHeight
                    predicted_label(idx(j)) = 2;
                end
            end
            disp(sprintf('Number of barlines: %d', size(predicted_label,2)))
        else
            disp(sprintf('Number of barlines: %d',0))
            BarLines = [];
            return
        end
        
end

%% --------------------------------find missed barlines----------------------------------
%Pos-processing

columnBarLines = BarLines(:,3)';
columnBarLinesfinal = BarLines(:,4)';
size_width_BarLines = median(columnBarLinesfinal - columnBarLines);

rowBarLines = median(BarLines(:,1));
diffcolumnBarLines = diff(columnBarLines);
medianvalue = median(diffcolumnBarLines);

idx = [1 find((diffcolumnBarLines-medianvalue)>2*spaceHeight)+1]; %in this way the median value is not influenced
BarLines = [BarLines(1,1) BarLines(1,2) 1 5 0 0; BarLines];
columnBarLines = [1 columnBarLines];

%between the barlines
newbarline = [];
for i=1:size(idx,2)
    img = imgWithoutSymbols(:,columnBarLines(idx(i)):columnBarLines(idx(i)+1));
    [~, stem]=removeSTEM(img,2*spaceHeight);
    
    b = zeros(1,size(stem,2));
    for j=1:size(stem,2)
        a = cell2mat(stem(j));
        b(j) = a(end);
    end
    b = [b inf];
    
    if size(b,2) == 1 & isinf(b) == 1
        newbarline = [];
        break
    end
    aux = diff(b);
    idx1 = find(aux~=1);
    size_width = [idx1(1) diff(idx1)];
    
    idxx = find(abs(size_width-size_width_BarLines) < lineHeight);
    idx11 = idx1(idxx);
    size_width = size_width(idxx);
    
    %for each stem
    for k = 1:size(idx11,2)
        id = idx11(k)-size_width(k)+1:idx11(k);
        row = [];
        rowend =[];
        for j=1:size(id,2)
            a = cell2mat(stem(id(j)));
            row = [row a(1:2:end-1)];
            rowend = [rowend a(2:2:end-1)];
        end
        row = min(row);
        rowend = max(rowend);
        
        if abs(row - rowBarLines)  < 2*lineHeight
            newbarline = [newbarline; row rowend a(end)-size_width(k)+columnBarLines(idx(i)) a(end)+columnBarLines(idx(i)) size_width(k) rowend-row];
        end
    end
end
BarLines = [BarLines; newbarline];
[~,id]=sort(BarLines(:,3));
BarLines = BarLines(id,:);


%last barline -> double barline
img = imgWithoutSymbols(:,BarLines(end,3):size(imgWithoutSymbols,2));
[~, stem]=removeSTEM(img,2*spaceHeight);

b = zeros(1,size(stem,2));
for j=1:size(stem,2)
    a = cell2mat(stem(j));
    b(j) = a(end);
end
b = [b inf];
if size(b,2) == 1 & isinf(b) == 1
    newbarline = [];
else
    aux = diff(b);
    idx1 = find(aux~=1);
    size_width = [idx1(1) diff(idx1)];
    
    idxx = find(abs(size_width-size_width_BarLines) > lineHeight);
    idx11 = idx1(idxx);
    size_width = size_width(idxx);
    
    %for each stem
    for k = 1:size(idx11,2)
        id = idx11(k)-size_width(k)+1:idx11(k);
        row = [];
        rowend =[];
        for j=1:size(id,2)
            a = cell2mat(stem(id(j)));
            row = [row a(1:2:end-1)];
            rowend = [rowend a(2:2:end-1)];
        end
        row = min(row);
        rowend = max(rowend);
        
        if abs(row - rowBarLines)  < 2*lineHeight
            newbarline = [row rowend a(end)-size_width(k)+BarLines(end,3) a(end)+BarLines(end,3) size_width(k) rowend-row];
        end
    end
end
BarLines = [BarLines; newbarline];

switch typeofmodel
    case 'svm'
        predicted_label = [predicted_label repmat(2,1,size(newbarline,1))];
        
        [data, class] = datasetforclassification(BarLines, 'barlines',originalscore);
        trg=ones(size(class,1),1);
        prob_estimates_=[];
        if size(data,2) ~=0
            [~, ~, prob_estimates_]= svmpredict(trg, data, SVMStruct,'-b 1');
        end
        
        a = zeros(20,1);
        a(3) = 1;
        DATAPROB = setfield(DATAPROB, 'barlines', [a prob_estimates prob_estimates_]);
    case 'nn'
        predicted_label = [predicted_label repmat(3,1,size(newbarline,1))];
        
        [data, ~] = datasetforclassification(newbarline, 'barlines',originalscore);
        prob_estimates_=[];
        if size(data,2) ~=0
            prob_estimates_= sim(net,data);
        end
        a = zeros(20,1);
        a(3) = 1;
        DATAPROB = setfield(DATAPROB, 'barlines', [a prob_estimates prob_estimates_]);
end

