function [DATAPROB,DATA] = read_clefs(Clefs,DATAPROB,originalscore)

global SVMStruct
global net
global typeofmodel
global degree_clef

DATA=[];
switch typeofmodel
    case 'svm'
        %Clefs
        if size(Clefs,1) == 0
            %if the process did not detect any clef sign then consider the
            %trebleclef
            typeclef = 20;
            disp(sprintf('Clef: Treble'))
            DATA = Clefs;
        else
            [data, class] = datasetforclassification(Clefs, 'clefs', originalscore,typeofmodel);
            
            trg=ones(size(class,1),1);
            [predicted_label, accuracy, prob_estimates]= svmpredict(trg, data, SVMStruct,'-b 1');
            DATAPROB = setfield(DATAPROB, 'Clefs', prob_estimates);
            DATA = Clefs;
            
            %if probability is lower than confidence threshold then trust the results from the extraction phase
            idx = find(max(prob_estimates, [], 2) < degree_clef);
            if size(idx, 1) ~= 0
                %Select the probabilities from altoclef, bassclef and trebleclef
                for j=1:size(idx,1)
                    %            [value, idx1] = max([prob_estimates(idx(j), 2),prob_estimates(idx(j), 4),prob_estimates(idx(j), 20)]);
                    [value, idx1] = max([prob_estimates(idx(j), 1),prob_estimates(idx(j), 9),prob_estimates(idx(j), 20)]);
                    if idx1 == 1
                        predicted_label(idx) = 1; %2;
                        disp(sprintf('Clef: Alto'))
                    elseif idx1 == 2
                        predicted_label(idx) = 9; %4;
                        disp(sprintf('Clef: Bass'))
                    else
                        predicted_label(idx) = 20;
                        disp(sprintf('Clef: Treble'))
                    end
                end
            end
        end
    case 'nn'
        %Clefs
        if size(Clefs,1) == 0
            %if the process did not detect any clef sign then consider the
            %trebleclef
            typeclef = 20;
            disp(sprintf('Clef: Treble'))
            DATA = Clefs;
        else
            [data, ~] = datasetforclassification(Clefs, 'clefs', originalscore);
            
            prob_estimates= sim(net,data);
            [~, predicted_label]=max(prob_estimates);
            DATAPROB = setfield(DATAPROB, 'Clefs', prob_estimates);
            DATA = Clefs;
            
            %if probability is lower than confidence threshold then trust the results from the extraction phase
            idx = find(max(prob_estimates) < degree_clef);
            %Select the probabilities from altoclef, bassclef and trebleclef
            for j=1:size(idx,2)
                [value, idx1] = max([prob_estimates(2, idx(j)),prob_estimates(4,idx(j)),prob_estimates(20,idx(j))]);
                if idx1 == 1
                    predicted_label(idx) = 1; %2;
                    disp(sprintf('Clef: Alto'))
                elseif idx1 == 2
                    predicted_label(idx) = 9; %4;
                    disp(sprintf('Clef: Bass'))
                else
                    predicted_label(idx) = 20;
                    disp(sprintf('Clef: Treble'))
                end
            end
        end
end