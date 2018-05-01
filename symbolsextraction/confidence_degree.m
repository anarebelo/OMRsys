function degree = confidence_degree(typeofsymbol,models,img,typeofclass,flag)

if flag == 1
    degree = [];
    alpha = ones(1,size(models,1));
    for i = 1:size(typeofsymbol,1)
        symbolpositions = typeofsymbol(i,:);
        imgInput = img(symbolpositions(1):symbolpositions(2),symbolpositions(3):symbolpositions(4));
        matrixPixels = matrixCorrelation(imgInput);
        
        %Compute the correlation scores between each model and symbol
        C_k_s = zeros(size(models,1),1);
        if strcmp('clefs',typeofclass)
            alpha(1:3) = [0.3 0.3 0.5];
        elseif strcmp('rests',typeofclass)
            alpha(4:8) = [0.3 0.3 0.3 0.5 0.7];
        elseif strcmp('keySignature',typeofclass)
            alpha(9:11) = [0.3 0.3 0.3];
        elseif strcmp('accidentals',typeofclass)
            alpha(9:11) = [0.3 0.3 0.3];
        elseif strcmp('TimeSignatureN',typeofclass)
            alpha(12:21) = [0.3 0.5 0.5 0.5 0.5 0.5 0.5 0.7 0.7 0.7];
        elseif strcmp('TimeSignatureL',typeofclass)
            alpha(22:23) = [0.3 0.3];
        elseif strcmp('semibreve_breve',typeofclass)
            alpha(24:25) = [0.5 0.5];
        elseif strcmp('dots',typeofclass)
            alpha(26) = 0.5;
        elseif strcmp('accents',typeofclass)
            alpha(27:36) = 0.5;
        elseif strcmp('barlines',typeofclass)
            alpha(37) = 0.7;
        elseif strcmp('whole',typeofclass)
            alpha(38) = 0.5;
        elseif strcmp('half',typeofclass)
            alpha(38) = 0.5;
        elseif strcmp('doublewhole',typeofclass)
            alpha(39) = 0.5;
        elseif strcmp('beams',typeofclass)
            alpha(40:43) = [0.3 0.3 0.5 0.7];
        elseif strcmp('notes',typeofclass)
            alpha(44:53) = [0.3 0.3 0.3 0.3 0.5 0.5 0.5 0.5 0.5 0.5];
        elseif strcmp('opennotes',typeofclass)
            alpha(54:55) = [0.5 0.5];
        end
        for j = 1: size(models,1)
            M = cell2mat(models(j));
            C_k_s(j) = abs(corr2(matrixPixels,M));
        end
        
        C_k_s(C_k_s<=0.5) = 0;
        recognition_hypotheses = C_k_s./alpha';
        
        ID = symbolpositions(1:4);
        
        if size(recognition_hypotheses,1) ~= 0
             degree = [degree; {ID recognition_hypotheses}];
        end
    end
else
    degree = [];
    for i = 1:size(typeofsymbol,1)
        symbolpositions = typeofsymbol(i,:);
        imgInput = img(symbolpositions(1):symbolpositions(2),symbolpositions(3):symbolpositions(4));
        matrixPixels = matrixCorrelation(imgInput);
        C_k_s = zeros(size(models,1),1);
        for j = 1: size(models,1)
            M = cell2mat(models(j));
            C_k_s(j) = abs(corr2(matrixPixels,M));
        end
        C_k_s(C_k_s<=0.5) = 0;
        recognition_hypotheses = C_k_s;
        ID = symbolpositions(1:4);
        if size(recognition_hypotheses,1) ~= 0
            degree = [degree; {ID recognition_hypotheses}];
        end
    end
end

