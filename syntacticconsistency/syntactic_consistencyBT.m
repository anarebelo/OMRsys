function syntactic_consistencyBT
clc
clear all
global struct_timesignaturesL
global struct_timesignaturesN
global struct_rests
global struct_noteheadsflags
global struct_accents
global SVMStruct
global net
global typeofmodel
global spaceHeight
global lineHeight
global degree_barlines
global degree_clef
global imgWithoutSymbols
global specialsymbol

degrees = dlmread('confidencedegrees.txt',';');


degree_barlines = degrees(4,2);
degree_clef = degrees(11,2);


%% -------------------------------------Read models-------------------------------------
disp('1. Read models')
%load the classification models
typeofmodel = 'nn';

file = 'C:\Users\arebelo\Desktop\arebelo\PhD\Project - ano4\Matlab code\extraction\models\';
switch typeofmodel
    case 'svm'
        f = load(strcat(file,'Struct_geometricpropertiesbsm.mat'));
        SVMStruct = f.SVMStruct;
        f=load(strcat(file,'svmStruct_timesignaturesL.mat'));
        struct_timesignaturesL = f.SVMStruct;
        f=load(strcat(file,'svmStruct_timesignaturesN.mat'));
        struct_timesignaturesN = f.SVMStruct;
        f=load(strcat(file,'svmStruct_rests.mat'));
        struct_rests = f.SVMStruct;
        f=load(strcat(file,'svmStruct_noteheadsflags.mat'));
        struct_noteheadsflags = f.SVMStruct;
        f=load(strcat(file,'svmStruct_accents.mat'));
        struct_accents = f.SVMStruct;
    case 'nn'
        f = load(strcat(file,'networkspace.mat'));
        net = f.net;
        f=load(strcat(file,'networkspace_timesignaturesL.mat'));
        struct_timesignaturesL = f.net;
        f=load(strcat(file,'networkspace_timesignaturesN.mat'));
        struct_timesignaturesN = f.net;
        f=load(strcat(file,'networkspace_rests.mat'));
        struct_rests = f.net;
        f=load(strcat(file,'networkspace_noteheadsflags.mat'));
        struct_noteheadsflags = f.net;
        f=load(strcat(file,'networkspace_accents.mat'));
        struct_accents = f.net;
    otherwise
        disp('Choose a valid model')
end

local = 'C:\Users\arebelo\Desktop\arebelo\PhD\Project - ano4\Matlab code\tests\Second\dataBaseGlobalConstraints\';
typeofscore='scanned';

% Read data from the first file
files = strcat(local,'results_',typeofscore);
d=dir(files);
d=struct2cell(d);
names=d(1,3:end,:);

% Read data from the second file
files_second = strcat(local,'results_',typeofscore,'\second');
dfiles_second=dir(files_second);
dfiles_second=struct2cell(dfiles_second);
namesfiles_second=dfiles_second(1,3:end,:);

% Read data from the stafflines file
files_stafflines = strcat(local,'results_',typeofscore,'\stafflines');
dfiles_stafflines=dir(files_stafflines);
dfiles_stafflines=struct2cell(dfiles_stafflines);
namesfiles_stafflines=dfiles_stafflines(1,3:end,:);


% Read data from the staffinfo_sets file
filestaffinfo_sets = strcat(local,'results_',typeofscore,'\staffinfo_sets');
dfilestaffinfo_sets=dir(filestaffinfo_sets);
dfilestaffinfo_sets=struct2cell(dfilestaffinfo_sets);
namesfilestaffinfo_sets=dfilestaffinfo_sets(1,3:end,:);

% Read data from the staffinfo_sets file
results = strcat(local,'results_',typeofscore,'\references');
dresults=dir(results);
dresults=struct2cell(dresults);
namesfilesresults=dresults(1,3:end,:);

ALLSYMBOLS = struct();
%For each image
for idxnames=1:length(names)
    aux = names{idxnames};
    name = aux(1:end-4);
    format = aux(end-3:end);
    
    data1 = names{idxnames};
    if ( strcmp(data1,'second') == 1 ) || ( strcmp(data1,'stafflines') == 1 ) || ( strcmp(data1,'references') == 1 ) || ( strcmp(data1,'imgs') == 1 ) ...
            || ( strcmp(data1,'staffinfo_sets') == 1 )
        continue
    end
    data2 = search_for_mat(name,namesfiles_second,2);
    disp( sprintf('%s <-> %s',data1,data2));
    
    data3 = search_for(name,namesfiles_stafflines,2);
    disp( sprintf('%s <-> %s',data1,data3));
    
    data4 = search_for(name,namesfilestaffinfo_sets,2);
    disp( sprintf('%s <-> %s',data1,data4));
    
    data5 = namesfilesresults{idxnames};
    disp( sprintf('%s <-> %s',data1,data5));
    data_reference_classes = dlmread(strcat(results,'\',data5));
    

    if data_reference_classes(1,end) == 0
        data_reference_classes(:,end) = [];
    end
    barlines= data_reference_classes(find(data_reference_classes(:,end) == 37),:);        
    
    [~,idx] = sort(barlines(:,1));
    barlines = barlines(idx,:); 
    
    [name_aux ~]= strtok(name,'-');
    
    if strcmp('real',typeofscore) == 1
        if strcmp('img009',name_aux) == 1
            numerator_ = [6 6 6 6 3 3 6 6 3 3 3 3];
            denominator_ = [8 8 8 8 4 4 8 8 4 4 4 4];
            numberbarlines = [4 4 4 4 5 3 4 4 4 4 4 4];
        elseif strcmp('img010',name_aux) == 1
            numerator_ = [3 3 6 6 6 6 3 3 3 3 6 6];
            denominator_ = [4 4 8 8 8 8 4 4 4 4 8 8]; 
            numberbarlines = [5 5 5 5 5 5 5 5 5 5 5 5];
        elseif strcmp('img014',name_aux) == 1
            numerator_ = [4 4 4 4 4 4 4 4 4 4];
            denominator_ = [4 4 4 4 4 4 4 4 4 4];
            numberbarlines = [0 3 2 2 2 3 3 3 2 2];
        elseif strcmp('img033',name_aux) == 1
            numerator_ = [2 2 2 2 2 2 2 2 2 2];
            denominator_ = [2 2 2 2 2 2 2 2 2 2]; 
            numberbarlines = [0 5 5 4 3 8 0 0 0 0];
        elseif strcmp('img036',name_aux) == 1
            numerator_ = [3 3 3 3 3 3 3 3 3 3];
            denominator_ = [4 4 4 4 4 4 4 4 4 4];
            numberbarlines = [4 5 6 6 6 6 5 5 5 5];
        elseif strcmp('img46',name_aux) == 1
            numerator_ = [3 3 4 6 6 6 6 6 4 4 6 6];
            denominator_ = [4 4 4 8 8 8 8 8 4 4 8 8]; 
            numberbarlines = [8 8 7 7 7 7 6 6 6 6 6 6];
        end
    elseif strcmp('scanned',typeofscore) == 1
        if strcmp('img004',name_aux) == 1
            numerator_ = [4 4 4 4 4 4 4 4];
            denominator_ = [4 4 4 4 4 4 4 4];
            numberbarlines = [6 5 6 4 6 5 6 4];
        elseif strcmp('img006',name_aux) == 1
            numerator_ = [3 3 3 3 3 3 3 3 2 2 2 2];
            denominator_ = [8 8 8 8 8 8 8 8 4 4 4 4]; 
            numberbarlines = [12 12 11 11 11 11 10 10 6 6 7 7];
        elseif strcmp('img023_21',name_aux) == 1
            numerator_ = [2 2 2 2 2 2 2 2 2 2 2 2 2 2];
            denominator_ = [2 2 2 2 2 2 2 2 2 2 2 2 2 2];
            numberbarlines = [4 4 3 4 5 4 5 5 5 5 7 7 7 9];
        elseif strcmp('img024_22',name_aux) == 1
            numerator_ = [2 2 2 2 2 2 2 2 2 2 2 2 2 2];
            denominator_ = [2 2 2 2 2 2 2 2 2 2 2 2 2 2]; 
            numberbarlines = [9 7 4 4 4 6 4 11 6 6 7 8 7 6];
        elseif strcmp('img025_23',name_aux) == 1
            numerator_ = [2 2 2 2 2 2 2 2 2 2 2 2 2 2];
            denominator_ = [2 2 2 2 2 2 2 2 2 2 2 2 2 2];
            numberbarlines = [7 6 6 4 5 5 6 7 5 6 7 6 5 7];
        elseif strcmp('img028',name_aux) == 1
            numerator_ = [2 2 2 2 2 2 2 2];
            denominator_ = [4 4 4 4 4 4 4 4];
            numberbarlines = [5 5 5 5 5 5 5 5];
        elseif strcmp('img043',name_aux) == 1
            numerator_ = [2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];
            denominator_ = [2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2];
            numberbarlines = [7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7];
        elseif strcmp('img058',name_aux) == 1
            numerator_ = [6 6 6 6 6 6 6 6 6 6];
            denominator_ = [8 8 8 8 8 8 8 8 8 8];
            numberbarlines = [3 3 3 3 3 3 3 3 2 3];
        elseif strcmp('img065',name_aux) == 1
            numerator_ = [4 4 4 4 4 4 2 2 2 2 2 2];
            denominator_ = [4 4 4 4 4 4 2 2 2 2 2 2];
            numberbarlines = [7 7 7 7 7 7 7 7 7 7 5 5];
        end
    end
    

    %Read stafflines
    if strcmp(data3(end-2:end),'csv')==1
        data3=strcat(files_stafflines,'\',data3);
        datastafflines = dlmread(data3,';');
    elseif strcmp(data3(end-2:end),'txt')==1
        data3=strcat(files_stafflines,'\',data3);
        datastafflines = dlmread(data3,',');
    end
    dataX=datastafflines(:,1:2:end);
    dataY=datastafflines(:,2:2:end);
    
    %Read staffinfo
    data4=strcat(filestaffinfo_sets,'\',data4);
    data_staffinfo_sets = dlmread(data4,';');
    data_staffinfo_sets(end) = [];
    numberLines = mode(data_staffinfo_sets);
    
    %Split the stafflines data
    [initialpositions] = splitscoreinsets(data_staffinfo_sets,dataY,dataX);

    data1 = strcat(local,'results_',typeofscore,'\',data1);
    data2 = strcat(local,'results_',typeofscore,'\second\',data2);
    
    data1 = load(data1);
    data2 = load(data2);
    
    MUSICSYMBOLS = struct();
    %For each staff of an image
    allstaffs = data1.setOfSymbols;
    allstaffs_second = data2.setOfSymbols_Second;
    
    vbarlines = 1;
    previousbarlines = 0;
    previousstafflines = 1;
    sum_data_staffinfo_sets = cumsum(data_staffinfo_sets);
    
    
    if size(numerator_,2) < size(allstaffs,2)
        numerator_ = [numerator_ repmat(numerator_(end), size(allstaffs,2)-size(numerator_,2), 1)];
        denominator_ = [denominator_ repmat(denominator_(end), size(allstaffs,2)-size(denominator_,2), 1)];
        numberbarlines = [numberbarlines repmat(0, size(allstaffs,2)-size(numberbarlines,2), 1)];
    end

    for numberofstaffs=1:size(allstaffs,2)
        setOfSymbols = cell2mat(allstaffs(numberofstaffs));
        setOfSymbols_second = cell2mat(allstaffs_second(numberofstaffs));
        
        %% -----------------------------Read data from the first file----------------------------
        disp('2. Read data from the first file')
        originalscore = setOfSymbols.img_original;
        imgWithoutSymbols = setOfSymbols.img_final;
        %imwrite(originalscore,'originalscore.png','png')
        %imwrite(imgWithoutSymbols,'imgWithoutSymbols.png','png')
        
        
        aux = setOfSymbols.StaffInfo;
        spaceHeight = aux(1);
        lineHeight = aux(2);
        
        ScoreID                           = setOfSymbols.ScoreID;
        Rests_first                       = setOfSymbols.Rests;
        TimeSignatures_first              = setOfSymbols.TimeSignatures;
        Dots_first                        = setOfSymbols.Dots;
        OpenNoteHeadWithoutStem_first     = setOfSymbols.OpenNoteHeadWithoutStem;
        Accidental_first                  = setOfSymbols.Accidental;
        if size(Accidental_first,1)~=0
            Accidental_first              = [Accidental_first repmat(0,size(Accidental_first,1),2)];
        end
        Clefs_first                       = setOfSymbols.Clefs;
        Keys_first                        = setOfSymbols.Keys;
        BarLines_first                    = setOfSymbols.BarLines;
        Accent_first                      = setOfSymbols.Accent;
        Beams_first                       = setOfSymbols.Beams;
        if size(Beams_first,1)~=0
            Beams_first                   = [Beams_first repmat(0,size(Beams_first,1),2)];
        end
        OpenNoteheadstem_first            = setOfSymbols.OpenNoteheadStem.OpenNoteheadstem;
        noteheadstem_first                = setOfSymbols.NoteheadStem.noteheadstem;
        WholeRest_first                   = setOfSymbols.WholeRest;
        HalfRest_first                    = setOfSymbols.HalfRest;
        DoubleWholeRest_first             = setOfSymbols.DoubleWholeRest;
        %degree_first                      = setOfSymbols.degrees;
        disp('3. Read confidence degree data')
        %degree_first = read_confidencedegree(degree_first);
        
        %% -----------------------------Read data from the second file----------------------------
        disp('4. Read data from the second file')
        % Read data from the second file
        if size(setOfSymbols_second,1) ~= 0
            Rests_second                       = setOfSymbols_second.Rests;
            TimeSignatures_second              = setOfSymbols_second.TimeSignatures;
            Dots_second                        = setOfSymbols_second.Dots;
            OpenNoteHeadWithoutStem_second     = setOfSymbols_second.OpenNoteHeadWithoutStem;
            Accidental_second                  = setOfSymbols_second.Accidental;
            if size(Accidental_second,1)~=0
                Accidental_second              = [Accidental_second repmat(0,size(Accidental_second,1),2)];
            end
            Clefs_second                       = setOfSymbols_second.Clefs;
            Keys_second                        = setOfSymbols_second.Keys;
            BarLines_second                    = setOfSymbols_second.BarLines;
            Accent_second                      = setOfSymbols_second.Accent;
            Beams_second                       = setOfSymbols_second.Beams;
            if size(Beams_second,1)~=0
                Beams_second                   = [Beams_second repmat(0,size(Beams_second,1),2)];
            end
            OpenNoteheadstem_second            = setOfSymbols_second.OpenNoteheadStem.OpenNoteheadstem;
            noteheadstem_second                = setOfSymbols_second.NoteheadStem.noteheadstem;
            WholeRest_second                   = setOfSymbols_second.WholeRest;
            HalfRest_second                    = setOfSymbols_second.HalfRest;
            DoubleWholeRest_second             = setOfSymbols_second.DoubleWholeRest;
            %degree_second = setOfSymbols_second.degrees;
            disp('5. Read confidence degree data')
            %degree_second = read_confidencedegree(degree_second);
        end
        
        Rests                   = [Rests_first; Rests_second];
        TimeSignatures          = [TimeSignatures_first; TimeSignatures_second];
        Dots                    = [Dots_first; Dots_second];
        OpenNoteHeadWithoutStem = [OpenNoteHeadWithoutStem_first; OpenNoteHeadWithoutStem_second];
        Accidental              = [Accidental_first; Accidental_second];
        Clefs                   = [Clefs_first; Clefs_second];
        Keys                    = [Keys_first; Keys_second];
        BarLines                = [BarLines_first; BarLines_second];
        Accent                  = [Accent_first; Accent_second];
        Beams                   = [Beams_first; Beams_second];
        OpenNoteheadstem        = [OpenNoteheadstem_first; OpenNoteheadstem_second];
        noteheadstem            = [noteheadstem_first; noteheadstem_second];
        WholeRest               = [WholeRest_first; WholeRest_second];
        HalfRest                = [HalfRest_first; HalfRest_second];
        DoubleWholeRest         = [DoubleWholeRest_first; DoubleWholeRest_second];
        %degrees                 = [degree_first; degree_second];
        
        %Pos-processing: Find position of the notes in the staff
        idx = [];
        for j=1:size(noteheadstem,1)
            a = noteheadstem(j,1);
            noteheadstem1 = cell2mat(a);
            pitch = findnotepositionstaff(noteheadstem1, spaceHeight, dataX, dataY, numberLines, numberofstaffs,initialpositions,data_staffinfo_sets);
            if isinf(pitch)
                idx = [idx, j];
            end
        end
        noteheadstem(idx,:) = [];
        idx = [];
        for j=1:size(OpenNoteheadstem,1)
            a = OpenNoteheadstem(j,1);
            noteheadstem1 = cell2mat(a);
            pitch = findnotepositionstaff(noteheadstem1, spaceHeight, dataX, dataY, numberLines, numberofstaffs,initialpositions,data_staffinfo_sets);
            if isinf(pitch)
                idx = [idx, j];
            end
        end
        OpenNoteheadstem(idx,:) = [];
        
        DATAPROB = {};
        DATA = [];
        symbolsposition_all = [];
        
        %% --------------------------------Time Signature----------------------------------
        disp('6. Time Signature')
        
        %[numerator,denominator,DATAPROB,data_time] = read_timesignatures(TimeSignatures,DATAPROB,originalscore);
        numerator = numerator_(numberofstaffs);
        denominator = denominator_(numberofstaffs);
        disp(sprintf('Numerator: %d', numerator))
        disp(sprintf('Denominator: %d', denominator))
        
        %% --------------------------------Clef----------------------------------
        disp('7. Clef')
        [DATAPROB,data_clef] = read_clefs(Clefs,DATAPROB,originalscore);
        
        %% --------------------------------Barlines----------------------------------
        disp('8. Barlines')
        %[DATAPROB,data_Barlines,BarLines] = read_barlines(BarLines,DATAPROB,originalscore);          
        
        BarLines = barlines(vbarlines:previousbarlines+numberbarlines(numberofstaffs),:);
        vbarlines = previousbarlines+numberbarlines(numberofstaffs)+1;
        previousbarlines = previousbarlines+numberbarlines(numberofstaffs);
          
        [~,idx] = sort(BarLines(:,3));
        BarLines = BarLines(idx,:);        

        if size(BarLines,1) == 0
            continue
        end

        if BarLines(1,3) - dataX(previousstafflines,1) > size(originalscore,2)*0.15
            BarLines = [BarLines(1,1:2) dataX(previousstafflines,1) dataX(previousstafflines,1)+5 37; BarLines];
        end
        BarLines(:,end) = [];
        
        a = dataX(previousstafflines,:);
        a(find(a == 0 )) = [];
        if max(barlines(:,4)) - BarLines(end,4) >  size(originalscore,2)*0.15
            BarLines = [BarLines; BarLines(end,1:2) a(end)-5 a(end)];
        end
        previousstafflines = 1 + sum_data_staffinfo_sets(numberofstaffs);


        specialsymbol = [];
        %% -------------------------------- Symbols Classification ---------------------------------
        disp('9. Symbols Classification')
        switch typeofmodel
            case 'svm'
                [data, symbolsposition] = datasetforclassification(Rests, 'rests', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(OpenNoteHeadWithoutStem, 'openNoteheadsI', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(Accidental, 'accidentals', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(Keys, 'keySignature', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(Accent, 'accents', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(Beams, 'beams', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(OpenNoteheadstem, 'openNoteheads', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(noteheadstem, 'noteheads', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(WholeRest, 'wholerests', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(HalfRest, 'halfrests', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                [data, symbolsposition] = datasetforclassification(DoubleWholeRest, 'doublewholerests', originalscore);
                DATA =[DATA; data];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                
                trg=ones(size(DATA,1),1);
                [predicted_label, ~, prob_estimates]= svmpredict(trg, DATA, SVMStruct,'-b 1');
                
                %% --------------------------------sub classes----------------------------------
                disp('10. Sub classes')
                
            case 'nn'
                [data_rests, symbolsposition] = datasetforclassification(Rests, 'rests', originalscore);
                DATA =[DATA data_rests];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                
                [data_OpenNoteHeadWithoutStem, symbolsposition] = datasetforclassification(OpenNoteHeadWithoutStem, 'openNoteheadsI', originalscore);
                DATA =[DATA data_OpenNoteHeadWithoutStem];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                
                [data_Accidental, symbolsposition] = datasetforclassification(Accidental, 'accidentals', originalscore);
                DATA =[DATA data_Accidental];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                idx_key = size(DATA,2);
                
                [data_Keys, symbolsposition] = datasetforclassification(Keys, 'keySignature', originalscore);
                idx_key = idx_key+1:(idx_key+size(data_Keys,2));
                DATA =[DATA data_Keys];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                
                [data_Accent, symbolsposition] = datasetforclassification(Accent, 'accents', originalscore);
                DATA =[DATA data_Accent];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                
                [data_OpenNoteheadstem, symbolsposition] = datasetforclassification(OpenNoteheadstem, 'openNoteheads', originalscore);
                DATA =[DATA data_OpenNoteheadstem];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                idx_notes = size(DATA,2);
                
                [data_noteheadstem, symbolsposition] = datasetforclassification(noteheadstem, 'noteheads', originalscore);
                idx_notes = idx_notes+1:(idx_notes+size(data_noteheadstem,2));
                DATA =[DATA data_noteheadstem];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                symbolsposition1 = symbolsposition;
                
                [data_WholeRest, symbolsposition] = datasetforclassification(WholeRest, 'wholerests', originalscore);
                DATA =[DATA data_WholeRest];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                
                [data_HalfRest, symbolsposition] = datasetforclassification(HalfRest, 'halfrests', originalscore);
                DATA =[DATA data_HalfRest];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                
                [data_DoubleWholeRest, symbolsposition] = datasetforclassification(DoubleWholeRest, 'doublewholerests', originalscore);
                DATA =[DATA data_DoubleWholeRest];
                symbolsposition_all =[symbolsposition_all; symbolsposition];
                
                prob_estimates= sim(net,DATA);
                [~, predicted_label]=max(prob_estimates);
                
                setBreve = symbolsposition_all(find(predicted_label == 6),:);
                if size(setBreve,2)~=0
                    DATAPROB = setfield(DATAPROB, 'Breve', prob_estimates(:,find(predicted_label == 6)));
                end
                setSemibreve = symbolsposition_all(find(predicted_label == 16),:);
                if size(setSemibreve,2)~=0
                    DATAPROB = setfield(DATAPROB, 'Semibreve', prob_estimates(:,find(predicted_label == 16)));
                end
                setMinim = symbolsposition_all(find(predicted_label == 12),:);
                setMinim_special = specialsymbol(find(predicted_label == 12),:);
                pbr = prob_estimates(:,find(predicted_label == 12));
                
                %Pos-processing: possibility of having more than one voice
                colI = setMinim_special(:,3);
                colF = setMinim_special(:,4);
                ind = [];
                for j=2:size(colI,1)
                    a = repmat(colI(j),size(colI,1),1);
                    b = repmat(colF(j),size(colF,1),1);
                    val1 = abs(a-colI);
                    val2 = abs(b-colF);
                    idx = find(val1<spaceHeight & val2<spaceHeight);
                    if length(idx) > 1
                        notes = setMinim_special(idx,:);
                        pitch = [];
                        for k=1:size(notes,1)
                            pitch = [pitch findnotepositionstaff(notes(k,:), spaceHeight, dataX, dataY, numberLines, numberofstaffs,initialpositions,data_staffinfo_sets)];
                        end
                        id = find(pitch == inf | pitch>13 | pitch < 0);
                        ind = [ind idx(id)'];
                    end
                    colI(j) = inf;
                    colF(j) = inf;
                end
                setMinim_special(ind,:) = [];
                setMinim(ind,:) = [];
                pbr(:,ind) = [];
                DATAPROB = setfield(DATAPROB, 'Minim', pbr);
                
                %% --------------------------------sub classes----------------------------------
                disp('10a. Sub classes -> Rests')
                setRests = symbolsposition_all(find(predicted_label == 15),:);
                setRests_ = DATA(:,find(predicted_label == 15));
                if size(setRests,2)~=0
                    prob_estimates_rests= sim(struct_rests,setRests_);
                    [~, predicted_label_rests]=max(prob_estimates_rests);
                    if size(prob_estimates_rests,2)~=0
                        DATAPROB = setfield(DATAPROB, 'Thirty_secondrest', prob_estimates_rests(:,find(predicted_label_rests == 1)));
                        DATAPROB = setfield(DATAPROB, 'doublewhole_rest', prob_estimates_rests(:,find(predicted_label_rests == 2)));
                        DATAPROB = setfield(DATAPROB, 'halfwhole_rest', prob_estimates_rests(:,find(predicted_label_rests == 3)));
                        DATAPROB = setfield(DATAPROB, 'Sixty_fourthrest', prob_estimates_rests(:,find(predicted_label_rests == 4)));
                        DATAPROB = setfield(DATAPROB, 'Eighth_rest', prob_estimates_rests(:,find(predicted_label_rests == 5)));
                        DATAPROB = setfield(DATAPROB, 'Sixteenth_rest', prob_estimates_rests(:,find(predicted_label_rests == 6)));
                    end
                end
                
                setRests1 = symbolsposition_all(find(predicted_label == 14),:);
                if size(setRests1,2)~=0
                    DATAPROB = setfield(DATAPROB, 'Quarter_rest', prob_estimates(:,find(predicted_label == 14)));
                end
                
                disp('10b. Sub classes -> Accents')
                setAccents = symbolsposition_all(find(predicted_label == 1),:);
                setAccents_ = DATA(:,find(predicted_label == 1));
                if size(setAccents,2)~=0
                    prob_estimates_accents= sim(struct_accents,setAccents_);
                    [~, predicted_label_accents]=max(prob_estimates_accents);
                    if size(prob_estimates_accents,2)~=0
                        DATAPROB = setfield(DATAPROB, 'dynamic', prob_estimates_accents(:,find(predicted_label_accents == 1)));
                        DATAPROB = setfield(DATAPROB, 'fermata', prob_estimates_accents(:,find(predicted_label_accents == 2)));
                        DATAPROB = setfield(DATAPROB, 'Harmonic', prob_estimates_accents(:,find(predicted_label_accents == 3)));
                        DATAPROB = setfield(DATAPROB, 'marcato', prob_estimates_accents(:,find(predicted_label_accents == 4)));
                        DATAPROB = setfield(DATAPROB, 'mordent', prob_estimates_accents(:,find(predicted_label_accents == 5)));
                        DATAPROB = setfield(DATAPROB, 'staccatissimo', prob_estimates_accents(:,find(predicted_label_accents == 6)));
                        DATAPROB = setfield(DATAPROB, 'staccato', prob_estimates_accents(:,find(predicted_label_accents == 7)));
                        DATAPROB = setfield(DATAPROB, 'stopped', prob_estimates_accents(:,find(predicted_label_accents == 8)));
                        DATAPROB = setfield(DATAPROB, 'Tenuto', prob_estimates_accents(:,find(predicted_label_accents == 9)));
                        DATAPROB = setfield(DATAPROB, 'turn', prob_estimates_accents(:,find(predicted_label_accents == 10)));
                    end
                end
                
                disp('10c. Sub classes -> Noteheadsflags')
                setFlags = symbolsposition_all(find(predicted_label == 11),:);
                setFlags_special = specialsymbol(find(predicted_label == 11),:);
                setFlags_ = DATA(:,find(predicted_label == 11));
                
                %Pos-processing: possibility of having more than one voice
                colI = setFlags_special(:,3);
                colF = setFlags_special(:,4);
                ind = [];
                for j=2:size(colI,1)
                    a = repmat(colI(j),size(colI,1),1);
                    b = repmat(colF(j),size(colF,1),1);
                    val1 = abs(a-colI);
                    val2 = abs(b-colF);
                    idx = find(val1<spaceHeight & val2<spaceHeight);
                    if length(idx) > 1
                        notes = setFlags_special(idx,:);
                        pitch = [];
                        for k=1:size(notes,1)
                            pitch = [pitch findnotepositionstaff(notes(k,:), spaceHeight, dataX, dataY, numberLines, numberofstaffs,initialpositions,data_staffinfo_sets)];
                        end
                        id = find(pitch == inf | pitch>13 | pitch < 0);
                        ind = [ind idx(id)'];
                    end
                    colI(j) = inf;
                    colF(j) = inf;
                end
                setFlags_special(ind,:) = [];
                setFlags(ind,:) = [];
                setFlags_(:,ind) = [];
                prob_estimates_flags= sim(struct_noteheadsflags,setFlags_);
                [~, predicted_label_flags]=max(prob_estimates_flags);
                DATAPROB = setfield(DATAPROB, 'Thirty_second_note', prob_estimates_flags(:,find(predicted_label_flags == 1)));
                DATAPROB = setfield(DATAPROB, 'Sixty_fourth_note', prob_estimates_flags(:,find(predicted_label_flags == 2)));
                DATAPROB = setfield(DATAPROB, 'Eighth_note', prob_estimates_flags(:,find(predicted_label_flags == 3)));
                DATAPROB = setfield(DATAPROB, 'Sixteenth_note', prob_estimates_flags(:,find(predicted_label_flags == 4)));
                
                
                disp('10d. Sub classes -> Notes and Beams')
                setFlagsBeams_special  = [];
                setFlagsBeams          = [];
                beams                  = [];
                prob_estimates_beams   = [];
                prob_estimates_beams_1 = [];
                prob_estimates_beams_2 = [];
                prob_estimates_beams_3 = [];
                prob_estimates_beams_4 = [];
                setQuarter_special     = [];
                setQuarter             = [];
                idx = find(predicted_label == 10);
                if size(idx,2) ~= 0
                    idx_=ismember(idx,idx_notes);
                    
                    idx_n = idx(idx_);
                    idx_real_noteheadstem = idx_n-idx_notes(1)+1;
                    set_noteheadstem_all = noteheadstem(idx_real_noteheadstem,:);
                    
                    possiblebeams = set_noteheadstem_all(:,3);
                    idx_withoutbeams=find(cellfun('isempty',possiblebeams) ~= 0);
                    %idx_begin = idx_real_noteheadstem(idx_withoutbeams)+idx_n(1)-1;
                    idx_begin = idx_n(idx_withoutbeams);
                    %without beams
                    idx(idx_) = [];
                    
                    pbr = [prob_estimates(:,idx) prob_estimates(:,idx_begin)];
                    setQuarter = symbolsposition_all([idx idx_begin],:);
                    setQuarter_special = specialsymbol([idx idx_begin],:);
                    
                    %Pos-processing: possibility of having more than one voice
                    colI = setQuarter_special(:,3);
                    colF = setQuarter_special(:,4);
                    ind = [];
                    for j=2:size(colI,1)
                        a = repmat(colI(j),size(colI,1),1);
                        b = repmat(colF(j),size(colF,1),1);
                        val1 = abs(a-colI);
                        val2 = abs(b-colF);
                        idx = find(val1<spaceHeight & val2<spaceHeight);
                        if length(idx) > 1
                            notes = setQuarter_special(idx,:);
                            pitch = [];
                            for k=1:size(notes,1)
                                pitch = [pitch findnotepositionstaff(notes(k,:), spaceHeight, dataX, dataY, numberLines, numberofstaffs,initialpositions,data_staffinfo_sets)];
                            end
                            id = find(pitch == inf | pitch>13 | pitch < 0);
                            ind = [ind idx(id)'];
                        end
                        colI(j) = inf;
                        colF(j) = inf;
                    end
                    setQuarter_special(ind,:) = [];
                    setQuarter(ind,:) = [];
                    pbr(:,ind) = [];
                    DATAPROB = setfield(DATAPROB, 'Quarter_note', pbr);
                    
                    %with beams
                    idx_withbeams = find(cellfun('isempty',possiblebeams) == 0);
                    set_noteheadstem_beams = set_noteheadstem_all(idx_withbeams,:);
                    beams = cell2mat(set_noteheadstem_beams(:,3));
                    
                    setFlagsBeams_special = [];
                    setFlagsBeams = [];
                    if size(beams,1)~=0
                        [data_beams, ~] = datasetforclassification(beams, 'beams', originalscore);
                        prob_estimates_beams= sim(net,data_beams);
                        [~, predicted_label_beams]=max(prob_estimates_beams);
                        
                        %idx_beams = idx_withbeams(find(predicted_label_beams == 5));
                        %idx_begin = idx_real_noteheadstem(idx_beams)+idx_n(1)-1
                        idx_begin = idx_n(idx_withbeams);
                        setFlagsBeams = symbolsposition_all(idx_begin,:);
                        setFlagsBeams_special = specialsymbol(idx_begin,:);
                        
                        idx_nbeams = idx_withbeams(find(predicted_label_beams ~= 5));
                        %idx_begin = idx_real_noteheadstem(idx_nbeams)+idx_n(1)-1;
                        idx_begin = idx_n(idx_nbeams);
                        
                        setFlagsBeams = [setFlagsBeams; symbolsposition_all(idx_begin,:)];
                        aux = specialsymbol(idx_begin,:);
                        setFlagsBeams_special = [setFlagsBeams_special; aux];
                        
                        %beams = beams(find(predicted_label_beams == 5),:);
                        %prob_estimates_beams = prob_estimates_beams(:,find(predicted_label_beams == 5));
                    else
                        beams = [];
                        prob_estimates_beams = [];
                    end
                    
                    prob_estimates_beams_1 = [];
                    prob_estimates_beams_2 = [];
                    prob_estimates_beams_3 = [];
                    prob_estimates_beams_4 = [];
                    for j=1:size(beams,1)
                        img = originalscore(beams(j,1):beams(j,2), beams(j,3):beams(j,4));
                        [runsblack]=numberBlackRuns(img,spaceHeight);
                        if runsblack == 3
                            prob_estimates_beams_1 = [prob_estimates_beams_1; 0.7 0.1 0.1 0.1];
                        elseif runsblack == 4
                            prob_estimates_beams_2 = [prob_estimates_beams_2; 0.1 0.7 0.1 0.1];
                        elseif runsblack == 1
                            prob_estimates_beams_3 = [prob_estimates_beams_3; 0.1 0.1 0.7 0.1];
                        elseif runsblack == 2
                            prob_estimates_beams_4 = [prob_estimates_beams_4; 0.1 0.1 0.1 0.7];
                        end
                        prob_estimates_beams_3 = [prob_estimates_beams_3; repmat([0.1 0.1 0.7 0.1],size(aux,1),1)];
                    end
                    DATAPROB = setfield(DATAPROB, 'Thirty_second_noteflag', prob_estimates_beams_1');
                    DATAPROB = setfield(DATAPROB, 'Sixty_fourth_noteflag', prob_estimates_beams_2');
                    DATAPROB = setfield(DATAPROB, 'Eighth_noteflag', prob_estimates_beams_3');
                    DATAPROB = setfield(DATAPROB, 'Sixteenth_noteflag', prob_estimates_beams_4');
                end
                
                %% --------------------------------Key and Accidentals----------------------------------
                disp('11. Key and Accidentals')
                idx_flat = find(predicted_label == 8);
                idx_key_flat = ismember(idx_flat,idx_key); %Extraction phase
                setKeyFlat = symbolsposition_all(idx_flat(idx_key_flat),:);
                DATAPROB = setfield(DATAPROB, 'Flat_key', prob_estimates(:,idx_flat(idx_key_flat)));
                idx_flat(idx_key_flat) = [];
                setFlat = symbolsposition_all(idx_flat,:);
                DATAPROB = setfield(DATAPROB, 'Flat_accidental', prob_estimates(:,idx_flat));
                
                idx_natural = find(predicted_label == 9);
                idx_key_natural = ismember(idx_natural,idx_key);
                setKeyNatural = symbolsposition_all(idx_natural(idx_key_natural),:);
                DATAPROB = setfield(DATAPROB, 'Natural_key', prob_estimates(:,idx_natural(idx_key_natural)));
                idx_natural(idx_key_natural) = [];
                setNatural = symbolsposition_all(idx_natural,:);
                DATAPROB = setfield(DATAPROB, 'Natural_accidental', prob_estimates(:,idx_natural));
                
                idx_sharp = find(predicted_label == 17);
                idx_key_sharp = ismember(idx_sharp,idx_key);
                setKeySharp = symbolsposition_all(idx_sharp(idx_key_sharp),:);
                DATAPROB = setfield(DATAPROB, 'Sharp_key', prob_estimates(:,idx_sharp(idx_key_sharp)));
                idx_sharp(idx_key_sharp) = [];
                setSharp = symbolsposition_all(idx_sharp,:);
                DATAPROB = setfield(DATAPROB, 'Sharp_accidental', prob_estimates(:,idx_sharp));
                
                %% --------------------------------Dots----------------------------------
                disp('12. Dots')
                
                note_Dots = Dots(:,7:end);
                
                id = find(ismember(setFlags_special,note_Dots,'rows')==1);
                id1 = find(ismember(setFlags_special,note_Dots,'rows')~=1);
                if size(id,1)~=0
                    data = [DATAPROB.Thirty_second_note...
                        DATAPROB.Sixty_fourth_note ...
                        DATAPROB.Eighth_note...
                        DATAPROB.Sixteenth_note]';
                    [v,idx]=max(data,[],2);
                    
                    %without dot / with dot
                    PROB_1 = zeros(size(data,1),size(data,2)*2);
                    aux = 0;
                    for i=1:size(id,1)
                        row = id(i);
                        col = idx(row)+aux;
                        PROB_1(row,col) = v(row)*0.1;
                        PROB_1(row,col+1) = v(row)*0.9;
                        if col == 1
                            PROB_1(row, 3:2:8) = data(row,2:4);
                        elseif col == 2
                            PROB_1(row, 1) = data(row,1);
                            PROB_1(row, 5:2:8) = data(row,3:4);
                        elseif col == 3
                            PROB_1(row, 1:2:4) = data(row,1:2);
                            PROB_1(row, 7) = data(row,4);
                        elseif col == 4
                            PROB_1(row, 1:2:6) = data(row,1:3);
                        end
                        aux = aux + 1;
                    end
                    for i=1:size(id1,1)
                        PROB_1(id1(i),1:2:8) = data(id1(i),:);
                    end
                else
                    if size(setFlags_special,1)~=0
                        data = [DATAPROB.Thirty_second_note...
                            DATAPROB.Sixty_fourth_note ...
                            DATAPROB.Eighth_note...
                            DATAPROB.Sixteenth_note]';
                        PROB_1 = zeros(size(data,1),size(data,2)*2);
                        PROB_1(:,1:2:8) = data;
                    else
                        PROB_1 = [];
                    end
                end
                id = find(ismember(setFlagsBeams_special,note_Dots,'rows')==1);
                id1 = find(ismember(setFlagsBeams_special,note_Dots,'rows')~=1);
                if size(id,1)~=0
                    data = [DATAPROB.Thirty_second_noteflag...
                        DATAPROB.Sixty_fourth_noteflag ...
                        DATAPROB.Eighth_noteflag...
                        DATAPROB.Sixteenth_noteflag]';
                    [v,idx]=max(data,[],2);
                    
                    %without dot / with dot
                    PROB_2 = zeros(size(data,1),size(data,2)*2);
                    aux = 0;
                    for i=1:size(id,1)
                        row = id(i);
                        col = idx(row)+aux;
                        PROB_2(row,col) = v(row)*0.1;
                        PROB_2(row,col+1) = v(row)*0.9;
                        if col == 1
                            PROB_2(row, 3:2:8) = data(row,2:4);
                        elseif col == 2
                            PROB_2(row, 1) = data(row,1);
                            PROB_2(row, 5:2:8) = data(row,3:4);
                        elseif col == 3
                            PROB_2(row, 1:2:4) = data(row,1:2);
                            PROB_2(row, 7) = data(row,4);
                        elseif col == 4
                            PROB_2(row, 1:2:6) = data(row,1:3);
                        end
                        aux = aux + 1;
                    end
                    for i=1:size(id1,1)
                        PROB_2(id1(i),1:2:8) = data(id1(i),:);
                    end
                else
                    if size(setFlagsBeams_special,1)~=0
                        data = [DATAPROB.Thirty_second_noteflag...
                            DATAPROB.Sixty_fourth_noteflag ...
                            DATAPROB.Eighth_noteflag...
                            DATAPROB.Sixteenth_noteflag]';
                        
                        PROB_2 = zeros(size(data,1),size(data,2)*2);
                        PROB_2(:,1:2:8) = data;
                    else
                        PROB_2 = [];
                    end
                end
                id = find(ismember(setQuarter_special,note_Dots,'rows')==1);
                id1 = find(ismember(setQuarter_special,note_Dots,'rows')~=1);
                if size(id,1)~=0
                    data = DATAPROB.Quarter_note';
                    [v,idx]=max(data,[],2);
                    
                    %without dot / with dot
                    PROB_3 = zeros(size(data,1),size(data,2)*2);
                    for i=1:size(id,1)
                        row = id(i);
                        PROB_3(row,19) = v(row)*0.1;
                        PROB_3(row,20) = v(row)*0.9;
                        
                        PROB_3(row, 1:2:18) = data(row,1:9);
                        PROB_3(row, 21:2:40) = data(row,11:20);
                        
                    end
                    for i=1:size(id1,1)
                        PROB_3(id1(i),1:2:40) = data(id1(i),:);
                    end
                else
                    if size(setQuarter_special,1)~=0
                        data = DATAPROB.Quarter_note';
                        PROB_3 = zeros(size(data,1),size(data,2)*2);
                        PROB_3(:,1:2:40) = data;
                    else
                        PROB_3 = [];
                    end
                end
                id = find(ismember(setRests1,note_Dots,'rows')==1);
                id1 = find(ismember(setRests1,note_Dots,'rows')~=1);
                if size(id,1)~=0
                    data = DATAPROB.Quarter_rest';
                    [v,idx]=max(data,[],2);
                    
                    %without dot / with dot
                    PROB_4 = zeros(size(data,1),size(data,2)*2);
                    for i=1:size(id,1)
                        row = id(i);
                        PROB_4(row,27) = v(row)*0.1;
                        PROB_4(row,28) = v(row)*0.9;
                        
                        PROB_4(row, 1:2:26) = data(row,1:13);
                        PROB_4(row, 29:2:40) = data(row,15:20);
                        
                    end
                    for i=1:size(id1,1)
                        PROB_4(id1(i),1:2:40) = data(id1(i),:);
                    end
                else
                    if size(setRests1,1) ~= 0
                        data = DATAPROB.Quarter_rest';
                        PROB_4 = zeros(size(data,1),size(data,2)*2);
                        PROB_4(:,1:2:40) = data;
                    else
                        PROB_4 = [];
                    end
                end
                id = find(ismember(setRests,note_Dots,'rows')==1);
                id1 = find(ismember(setRests,note_Dots,'rows')~=1);
                if size(id,1)~=0
                    data = [DATAPROB.Thirty_secondrest...
                        DATAPROB.doublewhole_rest ...
                        DATAPROB.halfwhole_rest...
                        DATAPROB.Sixty_fourthrest...
                        DATAPROB.Eighth_rest...
                        DATAPROB.Sixteenth_rest]';
                    [v,idx]=max(data,[],2);
                    
                    %without dot / with dot
                    PROB_5 = zeros(size(data,1),size(data,2)*2);
                    aux = 0;
                    for i=1:size(id,1)
                        row = id(i);
                        col = idx(row)+aux;
                        PROB_5(row,col) = v(row)*0.1;
                        PROB_5(row,col+1) = v(row)*0.9;
                        if col == 1
                            PROB_5(row, 3:2:12) = data(row,2:6);
                        elseif col == 2
                            PROB_5(row, 1) = data(row,1);
                            PROB_5(row, 5:2:12) = data(row,3:6);
                        elseif col == 3
                            PROB_5(row, 1:2:4) = data(row,1:2);
                            PROB_5(row, 7:2:12) = data(row,4:6);
                        elseif col == 4
                            PROB_5(row, 1:2:6) = data(row,1:3);
                            PROB_5(row, 9:2:12) = data(row,5:6);
                        elseif col == 5
                            PROB_5(row, 1:2:8) = data(row,1:4);
                            PROB_5(row, 11) = data(row,6);
                        elseif col == 6
                            PROB_5(row, 1:2:10) = data(row,1:5);
                        end
                        aux = aux + 1;
                    end
                    for i=1:size(id1,1)
                        PROB_5(id1(i),1:2:12) = data(id1(i),:);
                    end
                else
                    if size(setRests,1) ~= 0
                        data = [DATAPROB.Thirty_secondrest...
                            DATAPROB.doublewhole_rest ...
                            DATAPROB.halfwhole_rest...
                            DATAPROB.Sixty_fourthrest...
                            DATAPROB.Eighth_rest...
                            DATAPROB.Sixteenth_rest]';
                        PROB_5 = zeros(size(data,1),size(data,2)*2);
                        PROB_5(:,1:2:12) = data;
                    else
                        PROB_5 = [];
                    end
                end
                id = find(ismember(setBreve,note_Dots,'rows')==1);
                id1 = find(ismember(setBreve,note_Dots,'rows')~=1);
                if size(id,1)~=0
                    data = DATAPROB.Breve';
                    [v,idx]=max(data,[],2);
                    
                    %without dot / with dot
                    PROB_6 = zeros(size(data,1),size(data,2)*2);
                    for i=1:size(id,1)
                        row = id(i);
                        PROB_6(row,11) = v(row)*0.1;
                        PROB_6(row,12) = v(row)*0.9;
                        
                        PROB_6(row, 1:2:10) = data(row,1:5);
                        PROB_6(row, 13:2:40) = data(row,7:20);
                        
                    end
                    for i=1:size(id1,1)
                        PROB_6(id1(i),1:2:40) = data(id1(i),:);
                    end
                else
                    if size(setBreve,1)~=0
                        data = DATAPROB.Breve';
                        PROB_6 = zeros(size(data,1),size(data,2)*2);
                        PROB_6(:,1:2:40) = data;
                    else
                        PROB_6 = [];
                    end
                end
                id = find(ismember(setSemibreve,note_Dots,'rows')==1);
                id1 = find(ismember(setSemibreve,note_Dots,'rows')~=1);
                if size(id,1)~=0
                    data = DATAPROB.Semibreve';
                    [v,idx]=max(data,[],2);
                    
                    %without dot / with dot
                    PROB_7 = zeros(size(data,1),size(data,2)*2);
                    for i=1:size(id,1)
                        row = id(i);
                        PROB_7(row,31) = v(row)*0.1;
                        PROB_7(row,32) = v(row)*0.9;
                        
                        PROB_7(row, 1:2:30) = data(row,1:15);
                        PROB_7(row, 33:2:40) = data(row,17:20);
                        
                    end
                    for i=1:size(id1,1)
                        PROB_7(id1(i),1:2:40) = data(id1(i),:);
                    end
                else
                    if size(setSemibreve,1)~=0
                        data = DATAPROB.Semibreve';
                        PROB_7 = zeros(size(data,1),size(data,2)*2);
                        PROB_7(:,1:2:40) = data;
                    else
                        PROB_7 = [];
                    end
                end
                id = find(ismember(setMinim_special,note_Dots,'rows')==1);
                id1 = find(ismember(setMinim_special,note_Dots,'rows')~=1);
                if size(id,1)~=0
                    data = DATAPROB.Minim';
                    [v,idx]=max(data,[],2);
                    
                    %without dot / with dot
                    PROB_8 = zeros(size(data,1),size(data,2)*2);
                    for i=1:size(id,1)
                        row = id(i);
                        PROB_8(row,23) = v(row)*0.1;
                        PROB_8(row,24) = v(row)*0.9;
                        
                        PROB_8(row, 1:2:22) = data(row,1:11);
                        PROB_8(row, 25:2:40) = data(row,13:20);
                        
                    end
                    for i=1:size(id1,1)
                        PROB_8(id1(i),1:2:40) = data(id1(i),:);
                    end
                else
                    if size(setMinim_special,1)~=0
                        data = DATAPROB.Minim';
                        PROB_8 = zeros(size(data,1),size(data,2)*2);
                        PROB_8(:,1:2:40) = data;
                    else
                        PROB_8 = [];
                    end
                end
        end
        
        %% --------------------------------global constraints----------------------------------
        disp('12. Global constraints')
        
        alpha = [0 0 0 0 2 2+2*1/2 1 1+1*1/2 1/2 1/2+1/2*1/2 1/4 1/4+1/4*1/2 1/8 1/8+1/8*1/2 1/16 1/16+1/16*1/2 1/32 1/32+1/32*1/2 1/64 1/64+1/64*1/2 ...
            2 2+2*1/2 1 1+1*1/2 1/2 1/2+1/2*1/2 1/4 1/4+1/4*1/2 1/8 1/8+1/8*1/2 1/16 1/16+1/16*1/2 1/32 1/32+1/32*1/2 1/64 1/64+1/64*1/2];
        
        SYMBOLS = [];
        previous = BarLines(1,3);
        for i=1:size(BarLines,1)-1
            begining = previous;
            ending = BarLines(i+1,3);
            previous = ending;
            
            disp(sprintf('Number of barlines: %d %d', begining, ending))
            
            MATRIXPROB = [];
            MATRIXSYMBOLS = [];
            if size(setBreve,1)~=0
                columns = setBreve(:,3);
                idx = find(columns >= begining & columns < ending);
                PROB = PROB_6(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setBreve(idx,:)];
                auxMatrixProb = [PROB(:,15) PROB(:,17) PROB(:,33) PROB(:,1) PROB(:,11:12) PROB(:,31:32) PROB(:,23:24) PROB(:,19:20) PROB(:,21:22) ...
                    PROB(:,21:22) PROB(:,21:22) PROB(:,21:22) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30) PROB(:,27:28) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30)...
                    PROB(:,29:30)];
                matrixDegree = [repmat((1-degrees(19,2))/34,size(PROB,1),4) repmat(degrees(19,2),size(PROB,1),2) repmat((1-degrees(19,2))/34,size(PROB,1),30)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degree(19,2)
            end
            if size(setSemibreve,1)~=0
                columns = setSemibreve(:,3);
                idx = find(columns >= begining & columns < ending);
                PROB = PROB_7(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setSemibreve(idx,:)];
                auxMatrixProb = [PROB(:,15) PROB(:,17) PROB(:,33) PROB(:,1) PROB(:,11:12) PROB(:,31:32) PROB(:,23:24) PROB(:,19:20) PROB(:,21:22) ...
                    PROB(:,21:22) PROB(:,21:22) PROB(:,21:22) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30) PROB(:,27:28) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30)...
                    PROB(:,29:30)];
                matrixDegree = [repmat((1-degrees(20,2))/34,size(PROB,1),6) repmat(degrees(20,2),size(PROB,1),2) repmat((1-degrees(20,2))/34,size(PROB,1),28)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degree(20,2)
            end
            if size(setMinim,1)~=0
                columns = setMinim(:,3);
                idx = find(columns >= begining & columns < ending);
                PROB = PROB_8(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setMinim(idx,:)];
                auxMatrixProb = [PROB(:,15) PROB(:,17) PROB(:,33) PROB(:,1) PROB(:,11:12) PROB(:,31:32) PROB(:,23:24) PROB(:,19:20) PROB(:,21:22) ...
                    PROB(:,21:22) PROB(:,21:22) PROB(:,21:22) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30) PROB(:,27:28) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30)...
                    PROB(:,29:30)];
                matrixDegree = [repmat((1-degrees(8,2))/34,size(PROB,1),8) repmat(degrees(8,2),size(PROB,1),2) repmat((1-degrees(8,2))/34,size(PROB,1),26)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degree(8,2)
            end
            if size(setRests,1)~=0
                columns = setRests(:,3);
                idx = find(columns >= begining & columns < ending);
                PROB = PROB_5(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setRests(idx,:)];
                MATRIXPROB = [MATRIXPROB; repmat(0,size(PROB,1),20) PROB(:,3:4) PROB(:,5:6) PROB(:,5:6) repmat(0,size(PROB,1),2) PROB(:,9:10) PROB(:,11:12)...
                    PROB(:,1:2) PROB(:,7:8)];
            end
            if size(setRests1,1)~=0
                columns = setRests1(:,3);
                idx = find(columns >= begining & columns < ending);
                PROB = PROB_4(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setRests1(idx,:)];
                MATRIXPROB = [MATRIXPROB; PROB(:,15) PROB(:,17) PROB(:,33) PROB(:,1) PROB(:,11:12) PROB(:,31:32) PROB(:,23:24) PROB(:,19:20) PROB(:,21:22) ...
                    PROB(:,21:22) PROB(:,21:22) PROB(:,21:22) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30) PROB(:,27:28) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30)...
                    PROB(:,29:30)];
            end
            if size(setAccents,1) ~=0
                columns = setAccents(:,3);
                idx = find(columns >= begining & columns < ending);
                if size(idx,1) ~= 0
                    prob = prob_estimates_accents(:,idx)';
                    PROB = mean(max(prob,[],2));
                    MATRIXSYMBOLS = [MATRIXSYMBOLS; setAccents(idx,:)];
                    auxMatrixProb = [repmat(0,size(prob,1),3) repmat(PROB,size(prob,1),1) repmat(0,size(prob,1),32)];
                    matrixDegree = [repmat((1-degrees(10,2))/35,size(prob,1),4) repmat(degrees(10,2),size(prob,1),1) repmat((1-degrees(10,2))/35,size(prob,1),31)];
                    MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                    %degrees(10,2)
                end
            end
            if size(setFlags,1)~=0
                columns = setFlags(:,3);
                idx = find(columns >= begining & columns < ending);
                PROB = PROB_1(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setFlags(idx,:)];
                auxMatrixProb = [repmat(0,size(PROB,1),12) PROB(:,5:6) PROB(:,7:8) PROB(:,1:2) PROB(:,3:4) repmat(0,size(PROB,1),16)];
                matrixDegree = [repmat((1-degrees(7,2))/28,size(PROB,1),12) repmat(degrees(7,2),size(PROB,1),8) repmat((1-degrees(7,2))/28,size(PROB,1),16)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degrees(7,2)
            end
            if size(setFlagsBeams,1)~=0
                columns = setFlagsBeams(:,3);
                idx = find(columns >= begining & columns < ending);
                PROB = PROB_2(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setFlagsBeams(idx,:)];
                auxMatrixProb = [repmat(0,size(PROB,1),12) PROB(:,5:6) PROB(:,7:8) PROB(:,1:2) PROB(:,3:4) repmat(0,size(PROB,1),16)];
                matrixDegree = [repmat((1-degrees(7,2))/28,size(PROB,1),12) repmat(degrees(7,2),size(PROB,1),8) repmat((1-degrees(7,2))/28,size(PROB,1),16)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degrees(7,2)
            end
            if size(setQuarter,1)~=0
                columns = setQuarter(:,3);
                idx = find(columns >= begining & columns < ending);
                PROB = PROB_3(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setQuarter(idx,:)];
                auxMatrixProb = [PROB(:,15) PROB(:,17) PROB(:,33) PROB(:,1) PROB(:,11:12) PROB(:,31:32) PROB(:,23:24) PROB(:,19:20) PROB(:,21:22) ...
                    PROB(:,21:22) PROB(:,21:22) PROB(:,21:22) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30) PROB(:,27:28) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30)...
                    PROB(:,29:30)];
                matrixDegree = [repmat((1-degrees(6,2))/34,size(PROB,1),10) repmat(degrees(6,2),size(PROB,1),2) repmat((1-degrees(6,2))/34,size(PROB,1),24)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degrees(6,2)
            end
            if size(setFlat,1)~=0
                columns = setFlat(:,3);
                idx = find(columns >= begining & columns < ending);
                data = DATAPROB.Flat_accidental';
                PROB_9 = zeros(size(data,1),size(data,2)*2);
                PROB_9(:,1:2:40) = data;
                PROB = PROB_9(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setFlat(idx,:)];
                auxMatrixProb = [PROB(:,15) PROB(:,17) PROB(:,33) PROB(:,1) PROB(:,11:12) PROB(:,31:32) PROB(:,23:24) PROB(:,19:20) PROB(:,21:22) ...
                    PROB(:,21:22) PROB(:,21:22) PROB(:,21:22) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30) PROB(:,27:28) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30)...
                    PROB(:,29:30)];
                matrixDegree = [repmat(degrees(1,2),size(PROB,1),1) repmat((1-degrees(1,2))/35,size(PROB,1),35)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degrees(1,2)
            end
            if size(setNatural,1)~=0
                columns = setNatural(:,3);
                idx = find(columns >= begining & columns < ending);
                data = DATAPROB.Natural_accidental';
                PROB_10 = zeros(size(data,1),size(data,2)*2);
                PROB_10(:,1:2:40) = data;
                PROB = PROB_10(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setNatural(idx,:)];
                auxMatrixProb = [PROB(:,15) PROB(:,17) PROB(:,33) PROB(:,1) PROB(:,11:12) PROB(:,31:32) PROB(:,23:24) PROB(:,19:20) PROB(:,21:22) ...
                    PROB(:,21:22) PROB(:,21:22) PROB(:,21:22) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30) PROB(:,27:28) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30)...
                    PROB(:,29:30)];
                matrixDegree = [repmat((1-degrees(1,2))/35,size(PROB,1),1) repmat(degrees(1,2),size(PROB,1),1) repmat((1-degrees(1,2))/35,size(PROB,1),34)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degrees(1,2)
            end
            if size(setSharp,1)~=0
                columns = setSharp(:,3);
                idx = find(columns >= begining & columns < ending);
                data = DATAPROB.Sharp_accidental';
                PROB_11 = zeros(size(data,1),size(data,2)*2);
                PROB_11(:,1:2:40) = data;
                PROB = PROB_11(idx,:);
                MATRIXSYMBOLS = [MATRIXSYMBOLS; setSharp(idx,:)];
                auxMatrixProb = [PROB(:,15) PROB(:,17) PROB(:,33) PROB(:,1) PROB(:,11:12) PROB(:,31:32) PROB(:,23:24) PROB(:,19:20) PROB(:,21:22) ...
                    PROB(:,21:22) PROB(:,21:22) PROB(:,21:22) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30) PROB(:,27:28) PROB(:,29:30) PROB(:,29:30) PROB(:,29:30)...
                    PROB(:,29:30)];
                matrixDegree = [repmat((1-degrees(1,2))/35,size(PROB,1),2) repmat(degrees(1,2),size(PROB,1),1) repmat((1-degrees(1,2))/35,size(PROB,1),33)];
                MATRIXPROB = [MATRIXPROB; auxMatrixProb.*matrixDegree];
                %degrees(1,2)
            end
            
            disp('12a. Global constraints: doing the binary integer programming')
            if size(MATRIXPROB,1) == 0
                continue
            end
            N = numerator;
            D = denominator;
            
            newx = binprogramming(MATRIXPROB,alpha, N, D);
            if size(newx,1) ~= 0
                [row, col] = find(newx==1);
                [value, idx] = sort(row);
                classes = col(idx);
                vec = 1:size(MATRIXPROB,1);
                idxtoremove = find(ismember(vec,row)==0);
                % sum(alpha(col))*D
                
                MATRIXSYMBOLS(idxtoremove,:) = [];
                
                %             b = BarLines(i,:);
                %             for j=1:size(b,1)
                %                 originalscore(b(j,1):b(j,2),b(j,3):b(j,4))=0.5;
                %             end
                %             imwrite(originalscore,'xx3.png','png')
                
                a = MATRIXSYMBOLS(:,1:2);
                newsymbols = [a + repmat(initialpositions(numberofstaffs),size(a)) MATRIXSYMBOLS(:,3:4)];
                
                %             for j=1:size(newsymbols_,1)
                %                 img_all(newsymbols_(j,1):newsymbols_(j,2),newsymbols_(j,3):newsymbols_(j,4))=0.5;
                %             end
                %             imwrite(img_all,'xx1.png','png')
                
                SYMBOLS = [SYMBOLS; newsymbols classes value alpha(classes)' diag(MATRIXPROB(value,classes))];
            end
        end
        a_ = BarLines(:,1:2);
        newsymbols_ = [a_ + repmat(initialpositions(numberofstaffs),size(a_)) BarLines(:,3:4)];
        SYMBOLS = [SYMBOLS; newsymbols_ repmat(37, size(newsymbols_,1),1) repmat(0, size(newsymbols_,1),3)];
        
        MUSICSYMBOLS = setfield(MUSICSYMBOLS, ['staff' num2str(numberofstaffs)], SYMBOLS);
    end
    ALLSYMBOLS = setfield(ALLSYMBOLS, ['score' num2str(idxnames)], MUSICSYMBOLS);
end

save ALLSYMBOLS_scanned_cd
















