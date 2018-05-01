function [numerator,denominator,DATAPROB,DATA,typeTime] = read_timesignatures(TimeSignatures,DATAPROB,originalscore)

global struct_timesignaturesL
global struct_timesignaturesN
global SVMStruct
global net
global typeofmodel

DATA = [];
if size(TimeSignatures,1) == 0
    numerator = 4;
    denominator = 4;
    typeTime = 1;
else
    symbols = TimeSignatures;
    switch typeofmodel
        case 'svm'
            [data, class] = datasetforclassification(TimeSignatures, 'TimeSignature', originalscore);
            
            trg=ones(size(class,1),1);
            [predicted_label, accuracy, prob_estimates]= svmpredict(trg, data, SVMStruct,'-b 1');
            
            
            classlabel = predicted_label;
            if classlabel == 6
                img = originalscore(symbols(1,1):symbols(1,2),symbols(1,3):symbols(1,4));
                img= imresize(img, [20 20]);
                datafeatures = geometricproperties(1-img);
                valueMax=max(max(datafeatures));
                valueMin=min(min(datafeatures));
                datafeatures=2*(datafeatures-valueMin)/(valueMax-valueMin)-1;
                datafeatures =[datafeatures blurred_shape_model(img)];
                dataset  = [img(:)' datafeatures];
                [predicted_label, accuracy, prob_estimates]= svmpredict(trg, dataset, struct_timesignaturesL,'-b 1');
                DATAPROB = setfield(DATAPROB, 'TimeSignatureL', prob_estimates);
                
                DATA =[DATA; TimeSignatures];
                if predicted_label == 1
                    numerator = 2;
                    denominator = 2;
                else
                    numerator = 4;
                    denominator = 4;
                end
                typeTime = 0;
            elseif classlabel == 7
                img = originalscore(symbols(1,1):symbols(1,2),symbols(1,3):symbols(1,4));
                img= imresize(img, [20 20]);
                [datasetUp, datasetDown] = timeSignatureNumberClassification(img,typeofmodel);
                %DATA =[DATA; datasetUp];
                
                trg=ones(size(datasetUp,1),1);
                [predicted_label, accuracy, prob_estimates]= svmpredict(trg, datasetUp, struct_timesignaturesN,'-b 1');
                DATAPROB = setfield(DATAPROB, 'TimeSignatureN', prob_estimates);
                numerator = predicted_label-1;
                
                %DATA =[DATA; datasetDown];
                trg=ones(size(datasetDown,1),1);
                [predicted_label, accuracy, prob_estimates]= svmpredict(trg, datasetDown, struct_timesignaturesN,'-b 1');
                DATAPROB = setfield(DATAPROB, 'TimeSignatureN', prob_estimates);
                denominator = predicted_label-1;
                
                DATA =[DATA; TimeSignatures];
                typeTime = 1;
            else
                DATAPROB = setfield(DATAPROB, 'TimeSignatureN', prob_estimates);
                numerator = 4;
                denominator = 4;
                
                DATA =[DATA; TimeSignatures];
                typeTime = 1;
            end
        case 'nn'
            [data, class] = datasetforclassification(TimeSignatures, 'TimeSignature', originalscore);
            
            
            prob_estimates= sim(net,data);
            [~, predicted_label]=max(prob_estimates);
   
            classlabel = predicted_label;
            if classlabel == 18
                img = originalscore(symbols(1,1):symbols(1,2),symbols(1,3):symbols(1,4));
                img= imresize(img, [20 20]);
                dataset  = img(:);
                prob_estimates= sim(struct_timesignaturesL,dataset);
                [~, predicted_label]=max(prob_estimates);
                DATAPROB = setfield(DATAPROB, 'TimeSignatureL', prob_estimates);
                
                DATA =[DATA; TimeSignatures];
                if predicted_label == 1
                    numerator = 2;
                    denominator = 2;
                else
                    numerator = 4;
                    denominator = 4;
                end
                typeTime = 0;
            elseif classlabel == 19
                img = originalscore(symbols(1,1):symbols(1,2),symbols(1,3):symbols(1,4));
                img= imresize(img, [20 20]);
                [datasetUp, datasetDown] = timeSignatureNumberClassification(img,typeofmodel);
                %DATA =[DATA; datasetUp];
                
                prob_estimates= sim(struct_timesignaturesN,datasetUp);
                [~, predicted_label]=max(prob_estimates);
                DATAPROB = setfield(DATAPROB, 'TimeSignatureN', prob_estimates);
                numerator = predicted_label-1;
                
                %DATA =[DATA; datasetDown];
                prob_estimates= sim(struct_timesignaturesN,datasetDown);
                [~, predicted_label]=max(prob_estimates);
                DATAPROB = setfield(DATAPROB, 'TimeSignatureN', prob_estimates);
                denominator = predicted_label-1;
                
                DATA =[DATA; TimeSignatures];
                typeTime = 1;
            else
                DATAPROB = setfield(DATAPROB, 'TimeSignatureN', prob_estimates);
                numerator = 4;
                denominator = 4;
                
                DATA =[DATA; TimeSignatures];
                typeTime = 1;
            end
    end
end