function systemaccuracy
clc
clear all

confidence_degrees = 'no';
syntactic_consisteny = 'yes';
type = 'other';

switch syntactic_consisteny
    case 'no'
        switch confidence_degrees
            case 'no'
                
                typeofmodel = 'nn';
                scoretype = 'real';
                
                
                % Read data from the first file
                local = 'dataBaseEvaluation\';
                files = strcat(local,'results_',scoretype);
                d=dir(files);
                d=struct2cell(d);
                names=d(1,3:end,:);
                
                % Read data from the second file
                files_second = strcat(files,'\second');
                dfiles_second=dir(files_second);
                dfiles_second=struct2cell(dfiles_second);
                namesfiles_second=dfiles_second(1,3:end,:);
                
                % Read data from the stafflines file
                files_stafflines = strcat(files,'\stafflines');
                dfiles_stafflines=dir(files_stafflines);
                dfiles_stafflines=struct2cell(dfiles_stafflines);
                namesfiles_stafflines=dfiles_stafflines(1,3:end,:);
                
                % Read data from the staffinfo_sets file
                filestaffinfo_sets = strcat(files,'\staffinfo_sets');
                dfilestaffinfo_sets=dir(filestaffinfo_sets);
                dfilestaffinfo_sets=struct2cell(dfilestaffinfo_sets);
                namesfilestaffinfo_sets=dfilestaffinfo_sets(1,3:end,:);
                
                % Read data from the staffinfo file
                files_staffinfo = strcat(files,'\staffinfo');
                dfiles_staffinfo=dir(files_staffinfo);
                dfiles_staffinfo=struct2cell(dfiles_staffinfo);
                namesfiles_staffinfo=dfiles_staffinfo(1,3:end,:);
                
                % Read reference classes
                refclasses = strcat(files,'\references\classes');
                drefclasses=dir(refclasses);
                drefclasses=struct2cell(drefclasses);
                namesfilesclasses=drefclasses(1,3:end,:);
                
                resultsnostafflines = strcat(files,'\references\nostafflines');
                dresultsnostafflines=dir(resultsnostafflines);
                dresultsnostafflines=struct2cell(dresultsnostafflines);
                namesfilesresultsnostafflines=dresultsnostafflines(1,3:end,:);
                
                resultssymbols = strcat(files,'\references\symbols');
                dresultssymbols=dir(resultssymbols);
                dresultssymbols=struct2cell(dresultssymbols);
                namesfilesresultssymbols=dresultssymbols(1,3:end,:);
                
                % Read original images
                foimgs = strcat(files,'\imgs');
                doimgs=dir(foimgs);
                doimgs=struct2cell(doimgs);
                namesfilesoriginalimgs=doimgs(1,3:end,:);
                
                filename = 'test_real.txt';
                fid = fopen(filename, 'w');
                
                accuracy_all = zeros(1,length(names)-6);
                precision_all = accuracy_all;
                recall_all = accuracy_all;
                accuracy__class_all = accuracy_all;
                true_positive_all = accuracy_all;
                true_negative_all = accuracy_all;
                false_positive_all = accuracy_all;
                false_negative_all = accuracy_all;
                for idxnames=1:length(names)
                    aux = names{idxnames};
                    name = aux(1:end-4);
                    format = aux(end-3:end);
                    
                    data1 = names{idxnames};
                    if ( strcmp(data1,'second') == 1 ) || ( strcmp(data1,'stafflines') == 1 ) || ( strcmp(data1,'references') == 1 ) || ( strcmp(data1,'imgs') == 1 ) ...
                            || ( strcmp(data1,'staffinfo') == 1 ) || ( strcmp(data1,'staffinfo_sets') == 1 )
                        continue
                    end
                    data2 = search_for_mat(name,namesfiles_second,2);
                    disp( sprintf('%s <-> %s',data1,data2));
                    
                    data3 = search_for(name,namesfiles_stafflines,2);
                    disp( sprintf('%s <-> %s',data1,data3));
                    
                    data4 = search_for(name,namesfilestaffinfo_sets,2);
                    disp( sprintf('%s <-> %s',data1,data4));
                    
                    data5 = search_for(name,namesfiles_staffinfo,2);
                    disp( sprintf('%s <-> %s',data1,data5));
                    
                    if strcmp('results_printed',files) == 1
                        data6 = search_for(name,namesfilesclasses,3);
                    else
                        data6 = search_for(name,namesfilesclasses,2);
                    end
                    disp( sprintf('%s <-> %s',data1,data6));
                    
                    data7 = search_for(name,namesfilesoriginalimgs,2);
                    disp( sprintf('%s <-> %s',data1,data7));
                    
                    imgnamenostafflines = namesfilesresultsnostafflines{idxnames};
                    imgnamesymbols = namesfilesresultssymbols{idxnames};
                    
                    disp( sprintf('%s <-> %s',name,imgnamenostafflines));
                    disp( sprintf('%s <-> %s',name,imgnamesymbols));
                    
                    
                    %Read classes
                    data_reference_classes = dlmread(strcat(refclasses,'\',data6));
                    
                    %Read original image
                    image_original = imread(strcat(foimgs,'\',data7));
                    if(size(image_original,3)>1)
                        image_original = rgb2gray(image_original);
                        t=graythresh(image_original);
                        image_original=double(im2bw(image_original,t));
                    else
                        image_original=image_original./255;
                        image_original=double(logical(image_original));
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
                    
                    
                    %Remove stafflines
                    data_staffinfo = dlmread(strcat(files_staffinfo,'\',data5),';');
                    lineHeight = data_staffinfo(1);
                    if lineHeight~=1
                        threshold=2*lineHeight;
                    else
                        threshold=4;
                    end
                    tolerance=1+ceil(lineHeight/3);
                    [h]=size(image_original,1);
                    [image_original]=removeLine(threshold,tolerance,dataY,dataX,image_original,h);
                    
                    %Read staffinfo
                    data4=strcat(filestaffinfo_sets,'\',data4);
                    data_staffinfo_sets = dlmread(data4,';');
                    data_staffinfo_sets(end) = [];
                    numberLines = mode(data_staffinfo_sets);
                    
                    %Split the stafflines data
                    [initialpositions] = splitscoreinsets(data_staffinfo_sets,dataY,dataX);
                    
                    data1 = strcat(files,'\',data1);
                    data2 = strcat(files,'\second\',data2);
                    
                    data1 = load(data1);
                    data2 = load(data2);
                    
                    %For each staff of an image
                    allstaffs = data1.setOfSymbols;
                    allstaffs_second = data2.setOfSymbols_Second;
                    DATA = [];
                    for numberofstaffs=1:size(allstaffs,2)
                        setOfSymbols = cell2mat(allstaffs(numberofstaffs));
                        setOfSymbols_second = cell2mat(allstaffs_second(numberofstaffs));
                        
                        aux = setOfSymbols.StaffInfo;
                        spaceHeight = aux(1);
                        lineHeight = aux(2);
                        
                        
                        %% -----------------------------Read data from the first file----------------------------
                        originalscore = setOfSymbols.img_original;
                        %imgWithoutSymbols = setOfSymbols.img_final;
                        %imwrite(originalscore,'originalscore.png','png')
                        %imwrite(imgWithoutSymbols,'imgWithoutSymbols.png','png')
                        
                        aux = setOfSymbols.StaffInfo;
                        Rests_first                       = setOfSymbols.Rests;
                        if size(Rests_first,1)~=0
                            Rests_first = Rests_first(:,1:4);
                        end
                        TimeSignatures_first              = setOfSymbols.TimeSignatures;
                        if size(TimeSignatures_first,1)~=0
                            TimeSignatures_first = TimeSignatures_first(:,1:4);
                        end
                        Dots_first                        = setOfSymbols.Dots;
                        if size(Dots_first,1)~=0
                            Dots_first = Dots_first(:,7:end);
                        end
                        OpenNoteHeadWithoutStem_first     = setOfSymbols.OpenNoteHeadWithoutStem;
                        if size(OpenNoteHeadWithoutStem_first,1)~=0
                            OpenNoteHeadWithoutStem_first = OpenNoteHeadWithoutStem_first(:,1:4);
                        end
                        Accidental_first                  = setOfSymbols.Accidental;
                        if size(Accidental_first,1)~=0
                            Accidental_first              = Accidental_first(:,1:4);
                        end
                        Clefs_first                       = setOfSymbols.Clefs;
                        if size(Clefs_first,1)~=0
                            Clefs_first = Clefs_first(:,1:4);
                        end
                        Keys_first                        = setOfSymbols.Keys;
                        if size(Keys_first,1)~=0
                            Keys_first = Keys_first(:,1:4);
                        end
                        BarLines_first                    = setOfSymbols.BarLines;
                        if size(BarLines_first,1)~=0
                            BarLines_first = BarLines_first(:,1:4);
                        end
                        Accent_first                      = setOfSymbols.Accent;
                        if size(Accent_first,1)~=0
                            Accent_first = Accent_first(:,1:4);
                        end
                        Beams_first                       = setOfSymbols.Beams;
                        if size(Beams_first,1)~=0
                            Beams_first                   = Beams_first(:,1:4);
                        end
                        OpenNoteheadstem_first            = setOfSymbols.OpenNoteheadStem.OpenNoteheadstem;
                        noteheadstem_first                = setOfSymbols.NoteheadStem.noteheadstem;
                        WholeRest_first                   = setOfSymbols.WholeRest;
                        if size(WholeRest_first,1)~=0
                            WholeRest_first = WholeRest_first(:,1:4);
                        end
                        HalfRest_first                    = setOfSymbols.HalfRest;
                        if size(HalfRest_first,1)~=0
                            HalfRest_first = HalfRest_first(:,1:4);
                        end
                        DoubleWholeRest_first             = setOfSymbols.DoubleWholeRest;
                        if size(DoubleWholeRest_first,1)~=0
                            DoubleWholeRest_first = DoubleWholeRest_first(:,1:4);
                        end
                        
                        
                        %% -----------------------------Read data from the second file----------------------------
                        % Read data from the second file
                        if size(setOfSymbols_second,1) ~= 0
                            Rests_second                       = setOfSymbols_second.Rests;
                            if size(Rests_second,1)~=0
                                Rests_second = Rests_second(:,1:4);
                            end
                            TimeSignatures_second              = setOfSymbols_second.TimeSignatures;
                            if size(TimeSignatures_second,1)~=0
                                TimeSignatures_second = TimeSignatures_second(:,1:4);
                            end
                            Dots_second                        = setOfSymbols_second.Dots;
                            if size(Dots_second,1)~=0
                                Dots_second = Dots_second(:,7:end);
                            end
                            OpenNoteHeadWithoutStem_second     = setOfSymbols_second.OpenNoteHeadWithoutStem;
                            if size(OpenNoteHeadWithoutStem_second,1)~=0
                                OpenNoteHeadWithoutStem_second = OpenNoteHeadWithoutStem_second(:,1:4);
                            end
                            Accidental_second                  = setOfSymbols_second.Accidental;
                            if size(Accidental_second,1)~=0
                                Accidental_second              = Accidental_second(:,1:4);
                            end
                            Clefs_second                       = setOfSymbols_second.Clefs;
                            if size(Clefs_second,1)~=0
                                Clefs_second = Clefs_second(:,1:4);
                            end
                            Keys_second                        = setOfSymbols_second.Keys;
                            if size(Keys_second,1)~=0
                                Keys_second = Keys_second(:,1:4);
                            end
                            BarLines_second                    = setOfSymbols_second.BarLines;
                            if size(BarLines_second,1)~=0
                                BarLines_second = BarLines_second(:,1:4);
                            end
                            Accent_second                      = setOfSymbols_second.Accent;
                            if size(Accent_second,1)~=0
                                Accent_second = Accent_second(:,1:4);
                            end
                            Beams_second                       = setOfSymbols_second.Beams;
                            if size(Beams_second,1)~=0
                                Beams_second                   = Beams_second(:,1:4);
                            end
                            OpenNoteheadstem_second            = setOfSymbols_second.OpenNoteheadStem.OpenNoteheadstem;
                            noteheadstem_second                = setOfSymbols_second.NoteheadStem.noteheadstem;
                            WholeRest_second                   = setOfSymbols_second.WholeRest;
                            if size(WholeRest_second,1)~=0
                                WholeRest_second = WholeRest_second(:,1:4);
                            end
                            HalfRest_second                    = setOfSymbols_second.HalfRest;
                            if size(HalfRest_second,1)~=0
                                HalfRest_second = HalfRest_second(:,1:4);
                            end
                            DoubleWholeRest_second             = setOfSymbols_second.DoubleWholeRest;
                            if size(DoubleWholeRest_second,1)~=0
                                DoubleWholeRest_second = DoubleWholeRest_second(:,1:4);
                            end
                        end
                        data = [];
                        data = [data; Rests_first; Rests_second];
                        data = [data; TimeSignatures_first; TimeSignatures_second];
                        data = [data; Dots_first; Dots_second];
                        data = [data; OpenNoteHeadWithoutStem_first; OpenNoteHeadWithoutStem_second];
                        data = [data; Accidental_first; Accidental_second];
                        data = [data; Clefs_first; Clefs_second];
                        data = [data; Keys_first; Keys_second];
                        data = [data; BarLines_first; BarLines_second];
                        data = [data; Accent_first; Accent_second];
                        data = [data; Beams_first; Beams_second];
                        data = [data; WholeRest_first; WholeRest_second];
                        data = [data; HalfRest_first; HalfRest_second];
                        data = [data; DoubleWholeRest_first; DoubleWholeRest_second];
                        
                        symbolsposition = [];
                        specialsymbol   = [];
                        symbols         = [OpenNoteheadstem_first; OpenNoteheadstem_second];
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
                            b = min(symbol(4)+5,size(originalscore,2));
                            symbolsposition = [symbolsposition; symbol(1) symbol(2) a b];
                            specialsymbol = [specialsymbol; nH(1:4)];
                        end
                        if size(specialsymbol,1) ~= 0
                            %Pos-processing: possibility of having more than one voice
                            colI = specialsymbol(:,3);
                            colF = specialsymbol(:,4);
                            ind = [];
                            for j=2:size(colI,1)
                                a = repmat(colI(j),size(colI,1),1);
                                b = repmat(colF(j),size(colF,1),1);
                                val1 = abs(a-colI);
                                val2 = abs(b-colF);
                                idx = find(val1<spaceHeight & val2<spaceHeight);
                                if length(idx) > 1
                                    notes = specialsymbol(idx,:);
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
                            symbolsposition(ind,:) = [];
                        end
                        data = [data; symbolsposition];
                        
                        
                        
                        symbolsposition = [];
                        specialsymbol   = [];
                        symbols         = [noteheadstem_first; noteheadstem_second];
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
                            b = min(symbol(4)+5,size(originalscore,2));
                            symbolsposition = [symbolsposition; symbol(1) symbol(2) a b];
                            specialsymbol = [specialsymbol; nH(1:4)];
                        end
                        if size(specialsymbol,1)~=0
                            %Pos-processing: possibility of having more than one voice
                            colI = specialsymbol(:,3);
                            colF = specialsymbol(:,4);
                            ind = [];
                            for j=2:size(colI,1)
                                a = repmat(colI(j),size(colI,1),1);
                                b = repmat(colF(j),size(colF,1),1);
                                val1 = abs(a-colI);
                                val2 = abs(b-colF);
                                idx = find(val1<spaceHeight & val2<spaceHeight);
                                if length(idx) > 1
                                    notes = specialsymbol(idx,:);
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
                            symbolsposition(ind,:) = [];
                        end
                        data = [data; symbolsposition];
                        
                        
                        a = data(:,1:2);
                        newsymbols = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                        DATA = [DATA; newsymbols];
                    end
                    %     imgxx = double(image_original);
                    %     for j=1:size(DATA,1)
                    %         imgxx(DATA(j,1):DATA(j,2),DATA(j,3):DATA(j,4))=0.5;
                    %     end
                    %     imwrite(imgxx,'xx.png','png')
                    
                    
                    symbols = DATA;
                    datatoclassify = [];
                    switch typeofmodel
                        case 'svm'
                            
                        case 'nn'
                            f = load('networkspace.mat');
                            net = f.net;
                            for i=1:size(symbols,1)
                                if symbols(i,2) > size(image_original,1)
                                    symbols(i,2) = size(image_original,1);
                                end
                                if symbols(i,4) > size(image_original,2)
                                    symbols(i,4) = size(image_original,2);
                                end
                                img = image_original(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                                if islogical(img)==0
                                    t=graythresh(img);
                                    img=im2bw(img,t);
                                end
                                img= imresize(img, [20 20]);
                                datatoclassify  = [datatoclassify img(:)];
                            end
                            prob_estimates= sim(net,datatoclassify);
                            [~, predicted_label]=max(prob_estimates);
                    end
                    
                    DATA = [DATA predicted_label'];
                    
                    %     image_ref = double(zeros(size(image_original)));
                    %     for j=1:size(data_reference_classes,1)
                    %         image_ref(data_reference_classes(j,1):data_reference_classes(j,2), data_reference_classes(j,3):data_reference_classes(j,4)) = 1;
                    %     end
                    %     imwrite(image_ref,'xx1.png','png')
                    
                    true_positive = 0;
                    true_positive_class = 0;
                    data_reference_classes_aux = data_reference_classes;
                    for i=1:size(DATA,1)
                        data = DATA(i,:);
                        idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                        
                        [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            abs(data(2) - data_reference_classes_aux(idx,2))...
                            abs(data(3) - data_reference_classes_aux(idx,3))...
                            abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                        
                        data_ref = data_reference_classes_aux(idx(idx1),:);
                        data_reference_classes_aux(idx(idx1),:) = [];
                        
                        if size(data_ref,1) ~= 0
                            true_positive = true_positive+1;
                            
                            aux1 = 0;
                            if data(end) == 1 %accents
                                aux = 27;
                            elseif data(end) == 2 || data(end) == 4 || data(end) == 20 %altoclef, basslef, trebleclef
                                aux = 1;
                            elseif data(end) == 3 %barlines
                                aux = 37;
                            elseif data(end) == 5 %beams
                                aux = 40;
                            elseif data(end) == 6 || data(end) == 16 %Breve, semibreve
                                aux = 24;
                            elseif data(end) == 7 %Dots
                                aux = 26;
                            elseif data(end) == 8 || data(end) == 9 || data(end) == 17 %flat, naturals, sharp
                                aux = 9;
                            elseif data(end) == 10 || data(end) == 11 %notes, notesflags
                                aux = 44;
                            elseif data(end) == 12 %notesopen
                                aux = 54;
                            elseif data(end) == 14 %rests1
                                aux = 4;
                            elseif data(end) == 15 %rests2, doublewhole, half and whole
                                aux1 = 4;
                            elseif data(end) == 18 %timeL
                                aux = 22;
                            elseif data(end) == 19 %timeN
                                aux = 12;
                            end
                            
                            if aux == data_ref(5)
                                true_positive_class = true_positive_class+1;
                            end
                            if aux1~=0
                                if data_ref(5) == 4 || data_ref(5) == 38 || data_ref(5) == 39
                                    true_positive_class = true_positive_class+1;
                                end
                            end
                            
                        end
                    end
                    
                    false_negative = size(data_reference_classes,1) - true_positive; %missing result
                    if false_negative < 0
                        false_negative = 0;
                    end
                    
                    false_positive = size(DATA,1)- size(data_reference_classes,1); %unexpected result
                    if false_positive < 0
                        false_positive = 0;
                    end
                    
                    imgnostafflines = imread(strcat(resultsnostafflines,'\',imgnamenostafflines));
                    if(size(imgnostafflines,3)>1)
                        %Otsu
                        imgnostafflines = rgb2gray(imgnostafflines);
                        t=graythresh(imgnostafflines);
                        imgnostafflines=im2bw(imgnostafflines,t);
                    else
                        %Otsu or BLIST
                        imgnostafflines=imgnostafflines./255;
                        imgnostafflines=logical(imgnostafflines);
                    end
                    
                    imgsymbols = imread(strcat(resultssymbols,'\',imgnamesymbols));
                    if(size(imgsymbols,3)>1)
                        %Otsu
                        imgsymbols = rgb2gray(imgsymbols);
                        t=graythresh(imgsymbols);
                        imgsymbols=im2bw(imgsymbols,t);
                    else
                        %Otsu or BLIST
                        imgsymbols=imgsymbols./255;
                        imgsymbols=logical(imgsymbols);
                    end
                    
                    img = 1-abs(imgnostafflines-imgsymbols);
                    img=double(img);
                    L = bwlabel(1-img);
                    s  = regionprops(L, 'BoundingBox');
                    BoundingBox = cat(1, s.BoundingBox);
                    BoundingBox=floor(BoundingBox);
                    noise = [BoundingBox(:,2) BoundingBox(:,2)+BoundingBox(:,4) BoundingBox(:,1) BoundingBox(:,1)+BoundingBox(:,3)];
                    [row,col]=find(noise == 0);
                    noise(row,col)=1;
                    [value idx]=sort(noise(:,1));
                    
                    true_negative = size(noise,1); %Correct absence of result
                    
                    accuracy = (true_positive + true_negative)/(true_positive + false_positive + false_negative + true_negative)*100;
                    precision = true_positive/(true_positive + false_positive) * 100;
                    recall = true_positive/(true_positive + false_negative) * 100;
                    accuracy_class = true_positive_class/true_positive*100;
                    
                    disp(['Accuracy = ', num2str(accuracy)])
                    disp(['Precision = ', num2str(precision)])
                    disp(['Recall = ', num2str(recall)])
                    disp(['Classification accuracy = ', num2str(accuracy_class)])
                    
                    
                    fprintf(fid, '%s %f %f %f %f \r\n', name, accuracy, precision, recall, accuracy_class);
                    %fprintf(fid, '%s %f %f %f \r\n', name, accuracy, precision, recall);
                    
                    accuracy_all(idxnames) = accuracy;
                    precision_all(idxnames) = precision;
                    recall_all(idxnames) = recall;
                    accuracy__class_all(idxnames) = accuracy_class;
                    
                    true_positive = recall;
                    false_positive = false_positive/(true_negative+false_positive)*100;
                    
                    true_negative = true_negative/(true_negative+false_positive)*100;
                    false_negative = false_negative/(true_positive+false_negative)*100;
                    
                    true_positive_all(idxnames) = true_positive;
                    true_negative_all(idxnames) = true_negative;
                    false_positive_all(idxnames) = false_positive;
                    false_negative_all(idxnames) = false_negative;
                end
                
                accuracy_all(isnan(accuracy_all)) = 0;
                precision_all(isnan(precision_all)) = 0;
                recall_all(isnan(recall_all)) = 0;
                accuracy__class_all(isnan(accuracy__class_all));

                meanaccuracy = mean(accuracy_all);
                meanprecision = mean(precision_all);
                meanrecall = mean(recall_all);
                meanaccuracyclass = mean(accuracy__class_all);
                
                true_positive_all(isnan(true_positive_all)) = 0;
                true_negative_all(isnan(true_negative_all)) = 0;
                false_positive_all(isnan(false_positive_all)) = 0;
                false_negative_all(isnan(false_negative_all)) = 0;
                
                meanatrue_positive = mean(true_positive_all);
                meantrue_negative = mean(true_negative_all);
                meanfalse_positive = mean(false_positive_all);
                meanfalse_negative = mean(false_negative_all);
                
                fprintf(fid, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                fprintf(fid, '%f %f %f %f \r\n', meanatrue_positive, meantrue_negative, meanfalse_positive, meanfalse_negative);
                fclose(fid);
                
            case 'yes'
                typeofmodel = 'nn';
                degrees = dlmread('confidencedegrees.txt',';');
                
                % Read data from the first file
                files = 'results_real';
                d=dir(files);
                d=struct2cell(d);
                names=d(1,3:end,:);
                
                % Read data from the second file
                files_second = strcat(files,'\second');
                dfiles_second=dir(files_second);
                dfiles_second=struct2cell(dfiles_second);
                namesfiles_second=dfiles_second(1,3:end,:);
                
                % Read data from the stafflines file
                files_stafflines = strcat(files,'\stafflines');
                dfiles_stafflines=dir(files_stafflines);
                dfiles_stafflines=struct2cell(dfiles_stafflines);
                namesfiles_stafflines=dfiles_stafflines(1,3:end,:);
                
                % Read data from the staffinfo_sets file
                filestaffinfo_sets = strcat(files,'\staffinfo_sets');
                dfilestaffinfo_sets=dir(filestaffinfo_sets);
                dfilestaffinfo_sets=struct2cell(dfilestaffinfo_sets);
                namesfilestaffinfo_sets=dfilestaffinfo_sets(1,3:end,:);
                
                % Read data from the staffinfo file
                files_staffinfo = strcat(files,'\staffinfo');
                dfiles_staffinfo=dir(files_staffinfo);
                dfiles_staffinfo=struct2cell(dfiles_staffinfo);
                namesfiles_staffinfo=dfiles_staffinfo(1,3:end,:);
                
                % Read reference classes
                refclasses = strcat(files,'\references\classes');
                drefclasses=dir(refclasses);
                drefclasses=struct2cell(drefclasses);
                namesfilesclasses=drefclasses(1,3:end,:);
                
                % Read original images
                foimgs = strcat(files,'\imgs');
                doimgs=dir(foimgs);
                doimgs=struct2cell(doimgs);
                namesfilesoriginalimgs=doimgs(1,3:end,:);
                
                filename = 'evaluation_results_printed_cd.txt';
                fid = fopen(filename, 'w');
                
                accuracy_all = zeros(1,length(names)-6);
                precision_all = accuracy_all;
                recall_all = accuracy_all;
                accuracy__class_all = accuracy_all;
                true_positive_all = accuracy_all;
                true_negative_all = accuracy_all;
                false_positive_all = accuracy_all;
                false_negative_all = accuracy_all;
                for idxnames=1:length(names)
                    aux = names{idxnames};
                    name = aux(1:end-4);
                    format = aux(end-3:end);
                    
                    data1 = names{idxnames};
                    if ( strcmp(data1,'second') == 1 ) || ( strcmp(data1,'stafflines') == 1 ) || ( strcmp(data1,'references') == 1 ) || ( strcmp(data1,'imgs') == 1 ) ...
                            || ( strcmp(data1,'staffinfo') == 1 ) || ( strcmp(data1,'staffinfo_sets') == 1 )
                        continue
                    end
                    data2 = search_for_mat(name,namesfiles_second,2);
                    disp( sprintf('%s <-> %s',data1,data2));
                    
                    data3 = search_for(name,namesfiles_stafflines,2);
                    disp( sprintf('%s <-> %s',data1,data3));
                    
                    data4 = search_for(name,namesfilestaffinfo_sets,2);
                    disp( sprintf('%s <-> %s',data1,data4));
                    
                    data5 = search_for(name,namesfiles_staffinfo,2);
                    disp( sprintf('%s <-> %s',data1,data5));
                    
                    if strcmp('results_printed',files) == 1
                        data6 = search_for(name,namesfilesclasses,3);
                    else
                        data6 = search_for(name,namesfilesclasses,2);
                    end
                    disp( sprintf('%s <-> %s',data1,data6));
                    
                    data7 = search_for(name,namesfilesoriginalimgs,2);
                    disp( sprintf('%s <-> %s',data1,data7));
                    
                    
                    %Read classes
                    data_reference_classes = dlmread(strcat(refclasses,'\',data6));
                    
                    %Read original image
                    image_original = imread(strcat(foimgs,'\',data7));
                    if(size(image_original,3)>1)
                        image_original = rgb2gray(image_original);
                        t=graythresh(image_original);
                        image_original=double(im2bw(image_original,t));
                    else
                        image_original=image_original./255;
                        image_original=double(logical(image_original));
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
                    
                    
                    %Remove stafflines
                    data_staffinfo = dlmread(strcat(files_staffinfo,'\',data5),';');
                    lineHeight = data_staffinfo(1);
                    if lineHeight~=1
                        threshold=2*lineHeight;
                    else
                        threshold=4;
                    end
                    tolerance=1+ceil(lineHeight/3);
                    [h]=size(image_original,1);
                    [image_original]=removeLine(threshold,tolerance,dataY,dataX,image_original,h);
                    
                    %Read staffinfo
                    data4=strcat(filestaffinfo_sets,'\',data4);
                    data_staffinfo_sets = dlmread(data4,';');
                    data_staffinfo_sets(end) = [];
                    
                    %Split the stafflines data
                    [initialpositions] = splitscoreinsets(data_staffinfo_sets,dataY,dataX);
                    
                    data1 = strcat(files,'\',data1);
                    data2 = strcat(files,'\second\',data2);
                    
                    data1 = load(data1);
                    data2 = load(data2);
                    
                    %For each staff of an image
                    allstaffs = data1.setOfSymbols;
                    allstaffs_second = data2.setOfSymbols_Second;
                    DATA = [];
                    CLASSES = [];
                    for numberofstaffs=1:size(allstaffs,2)
                        setOfSymbols = cell2mat(allstaffs(numberofstaffs));
                        setOfSymbols_second = cell2mat(allstaffs_second(numberofstaffs));
                        
                        %% -----------------------------Read data from the first file----------------------------
                        originalscore = setOfSymbols.img_original;
                        %imgWithoutSymbols = setOfSymbols.img_final;
                        %imwrite(originalscore,'originalscore.png','png')
                        %imwrite(imgWithoutSymbols,'imgWithoutSymbols.png','png')
                        
                        aux = setOfSymbols.StaffInfo;
                        Rests_first                       = setOfSymbols.Rests;
                        if size(Rests_first,1)~=0
                            Rests_first = Rests_first(:,1:4);
                        end
                        TimeSignatures_first              = setOfSymbols.TimeSignatures;
                        if size(TimeSignatures_first,1)~=0
                            TimeSignatures_first = TimeSignatures_first(:,1:4);
                        end
                        Dots_first                        = setOfSymbols.Dots;
                        if size(Dots_first,1)~=0
                            Dots_first = Dots_first(:,7:end);
                        end
                        OpenNoteHeadWithoutStem_first     = setOfSymbols.OpenNoteHeadWithoutStem;
                        if size(OpenNoteHeadWithoutStem_first,1)~=0
                            OpenNoteHeadWithoutStem_first = OpenNoteHeadWithoutStem_first(:,1:4);
                        end
                        Accidental_first                  = setOfSymbols.Accidental;
                        if size(Accidental_first,1)~=0
                            Accidental_first              = Accidental_first(:,1:4);
                        end
                        Clefs_first                       = setOfSymbols.Clefs;
                        if size(Clefs_first,1)~=0
                            Clefs_first = Clefs_first(:,1:4);
                        end
                        Keys_first                        = setOfSymbols.Keys;
                        if size(Keys_first,1)~=0
                            Keys_first = Keys_first(:,1:4);
                        end
                        BarLines_first                    = setOfSymbols.BarLines;
                        if size(BarLines_first,1)~=0
                            BarLines_first = BarLines_first(:,1:4);
                        end
                        Accent_first                      = setOfSymbols.Accent;
                        if size(Accent_first,1)~=0
                            Accent_first = Accent_first(:,1:4);
                        end
                        Beams_first                       = setOfSymbols.Beams;
                        if size(Beams_first,1)~=0
                            Beams_first                   = Beams_first(:,1:4);
                        end
                        OpenNoteheadstem_first            = setOfSymbols.OpenNoteheadStem.OpenNoteheadstem;
                        noteheadstem_first                = setOfSymbols.NoteheadStem.noteheadstem;
                        WholeRest_first                   = setOfSymbols.WholeRest;
                        if size(WholeRest_first,1)~=0
                            WholeRest_first = WholeRest_first(:,1:4);
                        end
                        HalfRest_first                    = setOfSymbols.HalfRest;
                        if size(HalfRest_first,1)~=0
                            HalfRest_first = HalfRest_first(:,1:4);
                        end
                        DoubleWholeRest_first             = setOfSymbols.DoubleWholeRest;
                        if size(DoubleWholeRest_first,1)~=0
                            DoubleWholeRest_first = DoubleWholeRest_first(:,1:4);
                        end
                        
                        
                        %% -----------------------------Read data from the second file----------------------------
                        % Read data from the second file
                        if size(setOfSymbols_second,1) ~= 0
                            Rests_second                       = setOfSymbols_second.Rests;
                            if size(Rests_second,1)~=0
                                Rests_second = Rests_second(:,1:4);
                            end
                            TimeSignatures_second              = setOfSymbols_second.TimeSignatures;
                            if size(TimeSignatures_second,1)~=0
                                TimeSignatures_second = TimeSignatures_second(:,1:4);
                            end
                            Dots_second                        = setOfSymbols_second.Dots;
                            if size(Dots_second,1)~=0
                                Dots_second = Dots_second(:,7:end);
                            end
                            OpenNoteHeadWithoutStem_second     = setOfSymbols_second.OpenNoteHeadWithoutStem;
                            if size(OpenNoteHeadWithoutStem_second,1)~=0
                                OpenNoteHeadWithoutStem_second = OpenNoteHeadWithoutStem_second(:,1:4);
                            end
                            Accidental_second                  = setOfSymbols_second.Accidental;
                            if size(Accidental_second,1)~=0
                                Accidental_second              = Accidental_second(:,1:4);
                            end
                            Clefs_second                       = setOfSymbols_second.Clefs;
                            if size(Clefs_second,1)~=0
                                Clefs_second = Clefs_second(:,1:4);
                            end
                            Keys_second                        = setOfSymbols_second.Keys;
                            if size(Keys_second,1)~=0
                                Keys_second = Keys_second(:,1:4);
                            end
                            BarLines_second                    = setOfSymbols_second.BarLines;
                            if size(BarLines_second,1)~=0
                                BarLines_second = BarLines_second(:,1:4);
                            end
                            Accent_second                      = setOfSymbols_second.Accent;
                            if size(Accent_second,1)~=0
                                Accent_second = Accent_second(:,1:4);
                            end
                            Beams_second                       = setOfSymbols_second.Beams;
                            if size(Beams_second,1)~=0
                                Beams_second                   = Beams_second(:,1:4);
                            end
                            OpenNoteheadstem_second            = setOfSymbols_second.OpenNoteheadStem.OpenNoteheadstem;
                            noteheadstem_second                = setOfSymbols_second.NoteheadStem.noteheadstem;
                            WholeRest_second                   = setOfSymbols_second.WholeRest;
                            if size(WholeRest_second,1)~=0
                                WholeRest_second = WholeRest_second(:,1:4);
                            end
                            HalfRest_second                    = setOfSymbols_second.HalfRest;
                            if size(HalfRest_second,1)~=0
                                HalfRest_second = HalfRest_second(:,1:4);
                            end
                            DoubleWholeRest_second             = setOfSymbols_second.DoubleWholeRest;
                            if size(DoubleWholeRest_second,1)~=0
                                DoubleWholeRest_second = DoubleWholeRest_second(:,1:4);
                            end
                        end
                        
                        symbols = [Accidental_first; Accidental_second];
                        if size(symbols,1) ~= 0
                            a = symbols(:,1:2);
                            symbols = [a + repmat(initialpositions(numberofstaffs),size(a)) symbols(:,3:4)];
                            DATA = [DATA; symbols];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(symbols,1)
                                        if symbols(i,2) > size(image_original,1)
                                            symbols(i,2) = size(image_original,1);
                                        end
                                        if symbols(i,4) > size(image_original,2)
                                            symbols(i,4) = size(image_original,2);
                                        end
                                        img = image_original(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    [values, predicted_label]=max(prob_estimates);
                                    
                                    idx = find(values<degrees(1,2));
                                    [~,idx1] = max([prob_estimates(8,idx); prob_estimates(9,idx); prob_estimates(17,idx)]);
                                    
                                    predicted_label(idx(find(idx1 == 1))) = 8;
                                    predicted_label(idx(find(idx1 == 2))) = 9;
                                    predicted_label(idx(find(idx1 == 3))) = 17;
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        symbols = [BarLines_first; BarLines_second];
                        if size(symbols,1) ~= 0
                            a = symbols(:,1:2);
                            symbols = [a + repmat(initialpositions(numberofstaffs),size(a)) symbols(:,3:4)];
                            DATA = [DATA; symbols];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(symbols,1)
                                        if symbols(i,2) > size(image_original,1)
                                            symbols(i,2) = size(image_original,1);
                                        end
                                        if symbols(i,4) > size(image_original,2)
                                            symbols(i,4) = size(image_original,2);
                                        end
                                        img = image_original(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    [values, predicted_label]=max(prob_estimates);
                                    
                                    idx = find(values<degrees(4,2));
                                    predicted_label(idx) = 3;
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        symbols = [Beams_first; Beams_second];
                        if size(symbols,1) ~= 0
                            a = symbols(:,1:2);
                            symbols = [a + repmat(initialpositions(numberofstaffs),size(a)) symbols(:,3:4)];
                            DATA = [DATA; symbols];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(symbols,1)
                                        if symbols(i,2) > size(image_original,1)
                                            symbols(i,2) = size(image_original,1);
                                        end
                                        if symbols(i,4) > size(image_original,2)
                                            symbols(i,4) = size(image_original,2);
                                        end
                                        img = image_original(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    [values, predicted_label]=max(prob_estimates);
                                    
                                    idx = find(values<degrees(5,2));
                                    predicted_label(idx) = 5;
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        symbols = [HalfRest_first; HalfRest_second];
                        if size(symbols,1) ~= 0
                            a = symbols(:,1:2);
                            symbols = [a + repmat(initialpositions(numberofstaffs),size(a)) symbols(:,3:4)];
                            DATA = [DATA; symbols];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(symbols,1)
                                        if symbols(i,2) > size(image_original,1)
                                            symbols(i,2) = size(image_original,1);
                                        end
                                        if symbols(i,4) > size(image_original,2)
                                            symbols(i,4) = size(image_original,2);
                                        end
                                        img = image_original(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    [values, predicted_label]=max(prob_estimates);
                                    
                                    idx = find(values<degrees(9,2));
                                    predicted_label(idx) = 15;
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        symbolsposition = [];
                        symbols         = [OpenNoteheadstem_first; OpenNoteheadstem_second];
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
                            b = min(symbol(4)+5,size(originalscore,2));
                            symbolsposition = [symbolsposition; symbol(1) symbol(2) a b];
                        end
                        symbols = symbolsposition;
                        if size(symbols,1) ~= 0
                            a = symbols(:,1:2);
                            symbols = [a + repmat(initialpositions(numberofstaffs),size(a)) symbols(:,3:4)];
                            DATA = [DATA; symbols];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(symbols,1)
                                        if symbols(i,2) > size(image_original,1)
                                            symbols(i,2) = size(image_original,1);
                                        end
                                        if symbols(i,4) > size(image_original,2)
                                            symbols(i,4) = size(image_original,2);
                                        end
                                        img = image_original(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    [values, predicted_label]=max(prob_estimates);
                                    
                                    idx = find(values<degrees(8,2));
                                    predicted_label(idx) = 12;
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        symbolsposition = [];
                        symbols         = [noteheadstem_first; noteheadstem_second];
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
                            b = min(symbol(4)+5,size(originalscore,2));
                            symbolsposition = [symbolsposition; symbol(1) symbol(2) a b];
                        end
                        symbols = symbolsposition;
                        if size(symbols,1) ~= 0
                            a = symbols(:,1:2);
                            symbols = [a + repmat(initialpositions(numberofstaffs),size(a)) symbols(:,3:4)];
                            DATA = [DATA; symbols];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(symbols,1)
                                        if symbols(i,2) > size(image_original,1)
                                            symbols(i,2) = size(image_original,1);
                                        end
                                        if symbols(i,4) > size(image_original,2)
                                            symbols(i,4) = size(image_original,2);
                                        end
                                        img = image_original(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    [values, predicted_label]=max(prob_estimates);
                                    
                                    idx = find(values<degrees(6,2));
                                    [~,idx1] = max([prob_estimates(10,idx); prob_estimates(11,idx)]);
                                    
                                    predicted_label(idx(find(idx1 == 1))) = 10;
                                    predicted_label(idx(find(idx1 == 2))) = 11;
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        data = [Dots_first; Dots_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    
                                    prob_estimates(7,:) = prob_estimates(7,:) * degrees(14,2);
                                    prob_estimates(1:6,:) = prob_estimates(1:6,:) * ((1-degrees(14,2))/19);
                                    prob_estimates(8:20,:) = prob_estimates(8:20,:) * ((1-degrees(14,2))/19);
                                    
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        data = [OpenNoteHeadWithoutStem_first; OpenNoteHeadWithoutStem_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    
                                    prob_estimates(6,:) = prob_estimates(6,:) * degrees(19,2);
                                    prob_estimates(16,:) = prob_estimates(16,:) * degrees(19,2);
                                    prob_estimates(1:5,:) = prob_estimates(1:5,:) * ((1-degrees(19,2))/18);
                                    prob_estimates(7:15,:) = prob_estimates(7:15,:) * ((1-degrees(19,2))/18);
                                    prob_estimates(17:20,:) = prob_estimates(17:20,:) * ((1-degrees(19,2))/18);
                                    
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        data = [Clefs_first; Clefs_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    
                                    prob_estimates(2,:) = prob_estimates(2,:) * degrees(2,2);
                                    prob_estimates(4,:) = prob_estimates(4,:) * degrees(2,2);
                                    prob_estimates(20,:) = prob_estimates(20,:) * degrees(2,2);
                                    prob_estimates(1,:) = prob_estimates(1,:) * ((1-degrees(2,2))/17);
                                    prob_estimates(3,:) = prob_estimates(3,:) * ((1-degrees(2,2))/17);
                                    prob_estimates(5:19,:) = prob_estimates(5:19,:) * ((1-degrees(2,2))/17);
                                    
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        data = [Keys_first; Keys_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    
                                    prob_estimates(8,:) = prob_estimates(8,:) * degrees(16,2);
                                    prob_estimates(9,:) = prob_estimates(9,:) * degrees(16,2);
                                    prob_estimates(17,:) = prob_estimates(17,:) * degrees(16,2);
                                    prob_estimates(1:7,:) = prob_estimates(1:7,:) * ((1-degrees(16,2))/17);
                                    prob_estimates(10:16,:) = prob_estimates(10:16,:) * ((1-degrees(16,2))/17);
                                    prob_estimates(18:20,:) = prob_estimates(18:20,:) * ((1-degrees(16,2))/17);
                                    
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        
                        data = [Accent_first; Accent_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    
                                    prob_estimates(1,:) = prob_estimates(1,:) * degrees(10,2);
                                    prob_estimates(2:20,:) = prob_estimates(2:20,:) * ((1-degrees(10,2))/19);
                                    
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        
                        data = [WholeRest_first; WholeRest_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    
                                    prob_estimates(1:14,:) = prob_estimates(1:14,:) * ((1-degrees(22,2))/19);
                                    prob_estimates(15,:) = prob_estimates(15,:) * degrees(22,2);
                                    prob_estimates(16:20,:) = prob_estimates(16:20,:) * ((1-degrees(22,2))/19);
                                    
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        
                        data = [DoubleWholeRest_first; DoubleWholeRest_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    
                                    prob_estimates(1:14,:) = prob_estimates(1:14,:) * ((1-degrees(15,2))/19);
                                    prob_estimates(15,:) = prob_estimates(15,:) * degrees(15,2);
                                    prob_estimates(16:20,:) = prob_estimates(16:20,:) * ((1-degrees(15,2))/19);
                                    
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        data = [TimeSignatures_first; TimeSignatures_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    
                                    prob_estimates(1:16,:) = prob_estimates(1:16,:) * ((1-degrees(23,2))/18);
                                    prob_estimates(17,:) = prob_estimates(17,:) * degrees(23,2);
                                    prob_estimates(18,:) = prob_estimates(18,:) * degrees(23,2);
                                    prob_estimates(19:20,:) = prob_estimates(19:20,:) * ((1-degrees(23,2))/18);
                                    
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                        
                        data = [Rests_first; Rests_second];
                        if size(data,1) ~= 0
                            a = data(:,1:2);
                            data = [a + repmat(initialpositions(numberofstaffs),size(a)) data(:,3:4)];
                            DATA = [DATA; data];
                            
                            switch typeofmodel
                                case 'svm'
                                    
                                case 'nn'
                                    f = load('networkspace.mat');
                                    net = f.net;
                                    datatoclassify = [];
                                    for i=1:size(data,1)
                                        if data(i,2) > size(image_original,1)
                                            data(i,2) = size(image_original,1);
                                        end
                                        if data(i,4) > size(image_original,2)
                                            data(i,4) = size(image_original,2);
                                        end
                                        img = image_original(data(i,1):data(i,2),data(i,3):data(i,4));
                                        if islogical(img)==0
                                            t=graythresh(img);
                                            img=im2bw(img,t);
                                        end
                                        img= imresize(img, [20 20]);
                                        datatoclassify  = [datatoclassify img(:)];
                                    end
                                    prob_estimates= sim(net,datatoclassify);
                                    [~, predicted_label]=max(prob_estimates);
                                    
                                    CLASSES = [CLASSES; predicted_label'];
                            end
                        end
                    end
                    %     imgxx = double(image_original);
                    %     for j=1:size(DATA,1)
                    %         imgxx(DATA(j,1):DATA(j,2),DATA(j,3):DATA(j,4))=0.5;
                    %     end
                    %     imwrite(imgxx,'xx.png','png')
                    
                    DATA = [DATA CLASSES];
                    
                    %     image_ref = double(zeros(size(image_original)));
                    %     for j=1:size(data_reference_classes,1)
                    %         image_ref(data_reference_classes(j,1):data_reference_classes(j,2), data_reference_classes(j,3):data_reference_classes(j,4)) = 1;
                    %     end
                    %     imwrite(image_ref,'xx1.png','png')
                    
                    true_positive = 0;
                    true_positive_class = 0;
                    data_reference_classes_aux = data_reference_classes;
                    for i=1:size(DATA,1)
                        data = DATA(i,:);
                        idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                        
                        [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            abs(data(2) - data_reference_classes_aux(idx,2))...
                            abs(data(3) - data_reference_classes_aux(idx,3))...
                            abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                        
                        data_ref = data_reference_classes_aux(idx(idx1),:);
                        data_reference_classes_aux(idx(idx1),:) = [];
                        
                        if size(data_ref,1) ~= 0
                            true_positive = true_positive+1;
                            
                            aux1 = 0;
                            if data(end) == 1 %accents
                                aux = 27;
                            elseif data(end) == 2 || data(end) == 4 || data(end) == 20 %altoclef, basslef, trebleclef
                                aux = 1;
                            elseif data(end) == 3 %barlines
                                aux = 37;
                            elseif data(end) == 5 %beams
                                aux = 40;
                            elseif data(end) == 6 || data(end) == 16 %Breve, semibreve
                                aux = 24;
                            elseif data(end) == 7 %Dots
                                aux = 26;
                            elseif data(end) == 8 || data(end) == 9 || data(end) == 17 %flat, naturals, sharp
                                aux = 9;
                            elseif data(end) == 10 || data(end) == 11 %notes, notesflags
                                aux = 44;
                            elseif data(end) == 12 %notesopen
                                aux = 54;
                            elseif data(end) == 14 %rests1
                                aux = 4;
                            elseif data(end) == 15 %rests2, doublewhole, half and whole
                                aux1 = 4;
                            elseif data(end) == 18 %timeL
                                aux = 22;
                            elseif data(end) == 19 %timeN
                                aux = 12;
                            end
                            
                            if aux == data_ref(5)
                                true_positive_class = true_positive_class+1;
                            end
                            if aux1~=0
                                if data_ref(5) == 4 || data_ref(5) == 38 || data_ref(5) == 39
                                    true_positive_class = true_positive_class+1;
                                end
                            end
                            
                        end
                    end
                    
                    false_negative = size(data_reference_classes,1) - true_positive; %missing result
                    if false_negative < 0
                        false_negative = 0;
                    end
                    
                    false_positive = size(DATA,1)- size(data_reference_classes,1); %unexpected result
                    if false_positive < 0
                        false_positive = 0;
                    end
                    true_negative = 0; %Correct absence of result
                    
                    accuracy = (true_positive + true_negative)/(true_positive + false_positive + false_negative + true_negative)*100;
                    precision = true_positive/(true_positive + false_positive) * 100;
                    recall = true_positive/(true_positive + false_negative) * 100;
                    accuracy_class = true_positive_class/true_positive*100;
                    
                    disp(['Accuracy = ', num2str(accuracy)])
                    disp(['Precision = ', num2str(precision)])
                    disp(['Recall = ', num2str(recall)])
                    disp(['Classification accuracy = ', num2str(accuracy_class)])
                    
                    fprintf(fid, '%s %f %f %f %f \r\n', name, accuracy, precision, recall, accuracy_class);
                    %fprintf(fid, '%s %f %f %f \r\n', name, accuracy, precision, recall);
                    
                    accuracy_all(idxnames) = accuracy;
                    precision_all(idxnames) = precision;
                    recall_all(idxnames) = recall;
                    accuracy__class_all(idxnames) = accuracy_class;
                    
                    true_positive = recall;
                    false_positive = false_positive/(true_negative+false_positive)*100;
                    
                    true_negative = true_negative/(true_negative+false_positive)*100;
                    false_negative = false_negative/(true_positive+false_negative)*100;
                    
                    true_positive_all(idxnames) = true_positive;
                    true_negative_all(idxnames) = true_negative;
                    false_positive_all(idxnames) = false_positive;
                    false_negative_all(idxnames) = false_negative;

                end
                accuracy_all(isnan(accuracy_all)) = 0;
                precision_all(isnan(precision_all)) = 0;
                recall_all(isnan(recall_all)) = 0;
                accuracy__class_all(isnan(accuracy__class_all));
                
                true_positive_all(isnan(true_positive_all)) = 0;
                true_negative_all(isnan(true_negative_all)) = 0;
                false_positive_all(isnan(false_positive_all)) = 0;
                false_negative_all(isnan(false_negative_all)) = 0;
                
                meanaccuracy = mean(accuracy_all);
                meanprecision = mean(precision_all);
                meanrecall = mean(recall_all);
                meanaccuracyclass = mean(accuracy__class_all);
                
                meanatrue_positive = mean(true_positive_all);
                meantrue_negative = mean(true_negative_all);
                meanfalse_positive = mean(false_positive_all);
                meanfalse_negative = mean(false_negative_all);
                
                fprintf(fid, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                fprintf(fid, '%f %f %f %f \r\n', meanatrue_positive, meantrue_negative, meanfalse_positive, meanfalse_negative);
                fclose(fid);
                
        end
    case 'yes'
        switch type
            case 'printed'
                
                scoretype = 'printed';
                
                load ALLSYMBOLS_printed_cd
                fields = fieldnames(ALLSYMBOLS);
                
                local = 'dataBaseEvaluation\';
                files = strcat(local,'results_',scoretype);
                
                
                
                %         load ALLSYMBOLS_BARLINES_printed
                %         fields_barlines = fieldnames(ALLSYMBOLS_BARLINES);
                %
                %         load ALLSYMBOLS_TIME_printed
                %         fields_time = fieldnames(ALLSYMBOLS_TIME);
                
                
                results = strcat(files,'\references\classes');
                dresults=dir(results);
                dresults=struct2cell(dresults);
                namesfilesresults=dresults(1,3:end,:);
                
                
                
                resultsnostafflines = strcat(files,'\references\nostafflines');
                dresultsnostafflines=dir(resultsnostafflines);
                dresultsnostafflines=struct2cell(dresultsnostafflines);
                namesfilesresultsnostafflines=dresultsnostafflines(1,3:end,:);
                
                resultssymbols = strcat(files,'\references\symbols');
                dresultssymbols=dir(resultssymbols);
                dresultssymbols=struct2cell(dresultssymbols);
                namesfilesresultssymbols=dresultssymbols(1,3:end,:);
                
                filename = strcat(scoretype,'_sc_cd.txt');
                fid = fopen(filename, 'w');
                
                %         filename = strcat(scoretype,'_sc_barlines.txt');
                %         fidbarlines = fopen(filename, 'w');
                %
                %         filename = strcat(scoretype,'_sc_timeL.txt');
                %         fidtimeL = fopen(filename, 'w');
                %
                %         filename = strcat(scoretype,'_sc_timeN.txt');
                %         fidtimeN = fopen(filename, 'w');
                
                accuracy_all = zeros(1,size(fields,1));
                precision_all = accuracy_all;
                recall_all = accuracy_all;
                accuracy_class_all = accuracy_all;
                true_positive_all = accuracy_all;
                true_negative_all = accuracy_all;
                false_positive_all = accuracy_all;
                false_negative_all = accuracy_all;
                
                %         accuracy_all_barlines = accuracy_all;
                %         precision_all_barlines = accuracy_all;
                %         recall_all_barlines = accuracy_all;
                %         accuracy_class_all_barlines = accuracy_all;
                %
                %         accuracy_all_timeL = accuracy_all;
                %         precision_all_timeL = accuracy_all;
                %         recall_all_timeL = accuracy_all;
                %         accuracy_class_all_timeL = accuracy_all;
                %
                %         accuracy_all_timeN = accuracy_all;
                %         precision_all_timeN = accuracy_all;
                %         recall_all_timeN = accuracy_all;
                %         accuracy_class_all_timeN = accuracy_all;
                
                idxnames_others_idx = 1;
                for idxnames=1:length(namesfilesresults)
                    mainfilereference = namesfilesresults{idxnames};
                    
                    [name_aux ~]= strtok(mainfilereference,'-');
                    
                    if strcmp(name_aux,'pmw01') == 1
                        for idxnames_others=idxnames_others_idx:idxnames_others_idx+10
                            data_reference_classes = dlmread(strcat(results,'\',mainfilereference));
                            disp( sprintf('%s <-> %s',mainfilereference,fields{idxnames_others}));
                            
                            imgnamenostafflines = namesfilesresultsnostafflines{idxnames};
                            imgnamesymbols = namesfilesresultssymbols{idxnames};
                            
                            disp( sprintf('%s <-> %s',mainfilereference,imgnamenostafflines));
                            disp( sprintf('%s <-> %s',mainfilereference,imgnamesymbols));
                            
                            data = getfield(ALLSYMBOLS,fields{idxnames_others});
                            fields_data = fieldnames(data);
                            DATA = [];
                            for i=1:size(fields_data,1)
                                a = getfield(data,fields_data{i});
                                if size(a,1) == 0
                                    continue
                                end
                                DATA = [DATA; a(:,1:6)];
                            end
                            
                            %                     data_barlines = getfield(ALLSYMBOLS_BARLINES,fields_barlines{idxnames_others});
                            %                     fields_data_barlines = fieldnames(data_barlines);
                            %                     DATA_BARLINES = [];
                            %                     for i=1:size(fields_data_barlines,1)
                            %                         a = getfield(data_barlines,fields_data_barlines{i});
                            %                         if size(a,1) == 0
                            %                             continue
                            %                         end
                            %                         DATA_BARLINES = [DATA_BARLINES; a(:,1:5)];
                            %                     end
                            
                            true_positive = 0;
                            true_positive_class = 0;
                            data_reference_classes_aux = data_reference_classes;
                            count = 0;
                            for i=1:size(DATA,1)
                                data = DATA(i,:);
                                idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                                    abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                                
                                [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                                    abs(data(2) - data_reference_classes_aux(idx,2))...
                                    abs(data(3) - data_reference_classes_aux(idx,3))...
                                    abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                                
                                data_ref = data_reference_classes_aux(idx(idx1),:);
                                data_reference_classes_aux(idx(idx1),:) = [];
                                
                                if size(data_ref,1) ~= 0
                                    true_positive = true_positive+1;
                                    
                                    aux1 = 0;
                                    aux2 = 0;
                                    aux = 0;
                                    if data(end) == 1 || data(end) == 2 || data(end) == 3 %acidentals
                                        aux = 9;
                                    elseif data(end) == 4 %accents
                                        aux = 27;
                                    elseif data(end) == 5 || data(end) == 7 %breve and semibreve
                                        aux = 24;
                                    elseif data(end) == 6 || data(end) == 8 %breve and semibreve with dot
                                        aux = 24;
                                        aux1 = 26;
                                    elseif data(end) == 9 %minim
                                        aux = 54;
                                    elseif data(end) == 10 %minim with dot
                                        aux = 54;
                                        aux1 = 26;
                                    elseif data(end) == 11 %quarter
                                        aux = 44;
                                    elseif data(end) == 12 %quarter with dot
                                        aux = 44;
                                        aux1 = 26;
                                    elseif data(end) == 13 || data(end) == 15 || data(end) == 17 || data(end) == 19 %Eighth, Sixteenth, Thirty-second and Sixty-fourth
                                        aux = 44;
                                        if data(end-1) == 1
                                            aux2 = 40;
                                        end
                                    elseif data(end) == 14 || data(end) == 16 || data(end) == 18 || data(end) == 20 %Eighth, Sixteenth, Thirty-second and Sixty-fourth with dot
                                        aux = 44;
                                        aux1 = 26;
                                        if data(end-1) == 1
                                            aux2 = 40;
                                        end
                                    elseif data(end) == 21 %doublewhole
                                        aux = 39;
                                    elseif data(end) == 22 %doublewhole with dot
                                        aux = 39;
                                        aux1 = 26;
                                    elseif data(end) == 23 || data(end) == 25 %whole and half
                                        aux = 38;
                                    elseif data(end) == 24 || data(end) == 26 %whole and half with dot
                                        aux = 38;
                                        aux1 = 26;
                                    elseif data(end) == 27 || data(end) == 29 || data(end) == 31 || data(end) == 33 || data(end) == 35 %quarter, Eighth, Sixteenth, Thirty-second and Sixty-fourth rest
                                        aux = 4;
                                    elseif data(end) == 28 || data(end) == 30 || data(end) == 32 || data(end) == 34 || data(end) == 36 %quarter, Eighth, Sixteenth, Thirty-second and Sixty-fourth rest with dot
                                        aux = 4;
                                        aux1 = 26;
                                    elseif data(end) == 37 %barlines
                                        aux = 37;
                                        
                                    elseif data(end) == 38 %timeN
                                        aux = 12;
                                    elseif data(end) == 39 %timeL
                                        aux = 22;
                                    elseif data(end) == 40 %clefs
                                        aux = 1;
                                    end
                                    
                                    if aux == data_ref(5)
                                        true_positive_class = true_positive_class+1;
                                    end
                                    if aux1~=0 & aux == data_ref(5)
                                        true_positive_class = true_positive_class+1;
                                        true_positive = true_positive+1; % dot
                                        count = count + 1;
                                    end
                                    if aux2~=0 & aux == data_ref(5)
                                        true_positive_class = true_positive_class+1;
                                        true_positive = true_positive+1; % beams
                                        count = count + 1;
                                    end
                                end
                            end
                            false_negative = size(data_reference_classes,1) - true_positive; %missing result
                            if false_negative < 0
                                false_negative = 0;
                            end
                            
                            false_positive = size(DATA,1)+count- size(data_reference_classes,1); %unexpected result
                            if false_positive < 0
                                false_positive = 0;
                            end
                            
                            imgnostafflines = imread(strcat(resultsnostafflines,'\',imgnamenostafflines));
                            if(size(imgnostafflines,3)>1)
                                %Otsu
                                imgnostafflines = rgb2gray(imgnostafflines);
                                t=graythresh(imgnostafflines);
                                imgnostafflines=im2bw(imgnostafflines,t);
                            else
                                %Otsu or BLIST
                                imgnostafflines=imgnostafflines./255;
                                imgnostafflines=logical(imgnostafflines);
                            end
                            
                            imgsymbols = imread(strcat(resultssymbols,'\',imgnamesymbols));
                            if(size(imgsymbols,3)>1)
                                %Otsu
                                imgsymbols = rgb2gray(imgsymbols);
                                t=graythresh(imgsymbols);
                                imgsymbols=im2bw(imgsymbols,t);
                            else
                                %Otsu or BLIST
                                imgsymbols=imgsymbols./255;
                                imgsymbols=logical(imgsymbols);
                            end
                            
                            
                            img = 1-abs(imgnostafflines-imgsymbols);
                            img=double(img);
                            L = bwlabel(1-img);
                            s  = regionprops(L, 'BoundingBox');
                            BoundingBox = cat(1, s.BoundingBox);
                            BoundingBox=floor(BoundingBox);
                            noise = [BoundingBox(:,2) BoundingBox(:,2)+BoundingBox(:,4) BoundingBox(:,1) BoundingBox(:,1)+BoundingBox(:,3)];
                            [row,col]=find(noise == 0);
                            noise(row,col)=1;
                            [value idx]=sort(noise(:,1));
                            
                            true_negative = size(noise,1); %Correct absence of result
                            
                            accuracy = (true_positive + true_negative)/(true_positive + false_positive + false_negative + true_negative)*100;
                            precision = true_positive/(true_positive + false_positive) * 100;
                            recall = true_positive/(true_positive + false_negative) * 100;
                            accuracy_class = true_positive_class/true_positive*100;
                            
                            disp('Values for all symbols')
                            disp(['Accuracy = ', num2str(accuracy)])
                            disp(['Precision = ', num2str(precision)])
                            disp(['Recall = ', num2str(recall)])
                            disp(['Classification accuracy = ', num2str(accuracy_class)])
                            disp('-------------------------------------------------------------')
                            
                            fprintf(fid, '%s %f %f %f %f \r\n', name, accuracy, precision, recall, accuracy_class);
                            
                            accuracy_all(idxnames_others) = accuracy;
                            precision_all(idxnames_others) = precision;
                            recall_all(idxnames_others) = recall;
                            accuracy_class_all(idxnames_others) = accuracy_class;
                            
                            true_positive = recall;
                            false_positive = false_positive/(true_negative+false_positive)*100;
                            
                            true_negative = true_negative/(true_negative+false_positive)*100;
                            false_negative = false_negative/(true_positive+false_negative)*100;
                            
                            true_positive_all(idxnames_others) = true_positive;
                            true_negative_all(idxnames_others) = true_negative;
                            false_positive_all(idxnames_others) = false_positive;
                            false_negative_all(idxnames_others) = false_negative;
                            
                            %                     %Barlines
                            %                     true_positive_barlines = 0;
                            %                     true_positive_class_barlines = 0;
                            %                     idx = find(data_reference_classes(:,end) == 37);
                            %                     data_reference_classes_aux = data_reference_classes(idx,:);
                            %                     data_reference_classes_barlines = data_reference_classes(idx,:);
                            %                     for i=1:size(DATA_BARLINES,1)
                            %                         data = DATA_BARLINES(i,:);
                            %                         idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            %                             abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                            %
                            %                         [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            %                             abs(data(2) - data_reference_classes_aux(idx,2))...
                            %                             abs(data(3) - data_reference_classes_aux(idx,3))...
                            %                             abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                            %
                            %                         data_ref = data_reference_classes_aux(idx(idx1),:);
                            %                         data_reference_classes_aux(idx(idx1),:) = [];
                            %
                            %                         if size(data_ref,1) ~= 0
                            %                             true_positive_barlines = true_positive_barlines+1;
                            %                             if data(end) == data_ref(5)
                            %                                 true_positive_class_barlines = true_positive_class_barlines+1;
                            %                             end
                            %                         end
                            %                     end
                            %
                            %                     false_negative_barlines = size(data_reference_classes_barlines,1) - true_positive_barlines; %missing result
                            %                     if false_negative_barlines < 0
                            %                         false_negative_barlines = 0;
                            %                     end
                            %
                            %                     false_positive_barlines = size(DATA_BARLINES,1)- size(data_reference_classes_barlines,1); %unexpected result
                            %                     if false_positive_barlines < 0
                            %                         false_positive_barlines = 0;
                            %                     end
                            %                     true_negative_barlines = 0; %Correct absence of result
                            %
                            %
                            %                     if size(DATA_BARLINES,1) == 0
                            %                         recall_barlines = 0; accuracy_class_barlines = 0; accuracy_barlines = 0; precision_barlines = 0;
                            %                     else
                            %                         accuracy_barlines = (true_positive_barlines + true_negative_barlines)/(true_positive_barlines + false_positive_barlines + false_negative_barlines + true_negative_barlines)*100;
                            %                         precision_barlines = true_positive_barlines/(true_positive_barlines + false_positive_barlines) * 100;
                            %                         recall_barlines = true_positive_barlines/(true_positive_barlines + false_negative_barlines) * 100;
                            %                         accuracy_class_barlines = true_positive_class_barlines/size(data_reference_classes_barlines,1)*100;
                            %                     end
                            %
                            %                     disp('Values for barlines')
                            %                     disp(['Accuracy = ', num2str(accuracy_barlines)])
                            %                     disp(['Precision = ', num2str(precision_barlines)])
                            %                     disp(['Recall = ', num2str(recall_barlines)])
                            %                     disp(['Classification accuracy = ', num2str(accuracy_class_barlines)])
                            %                     disp('-------------------------------------------------------------')
                            %
                            %                     fprintf(fidbarlines, '%s %f %f %f %f \r\n', name, accuracy_barlines, precision_barlines, recall_barlines, accuracy_class_barlines);
                            %
                            %                     accuracy_all_barlines(idxnames_others) = accuracy_barlines;
                            %                     precision_all_barlines(idxnames_others) = precision_barlines;
                            %                     recall_all_barlines(idxnames_others) = recall_barlines;
                            %                     accuracy_class_all_barlines(idxnames_others) = accuracy_class_barlines;
                            %
                            %                     %Time
                            %                     %typeTime = 0 Letter
                            %                     true_positive_time = 0;
                            %                     true_positive_class_time = 0;
                            %                     idx = find(data_reference_classes(:,end) == 22);
                            %                     data_reference_classes_aux = data_reference_classes(idx,:);
                            %                     data_reference_classes_time = data_reference_classes(idx,:);
                            %                     for i=1:size(DATA_TIME,1)
                            %                         data = DATA_TIME(i,:);
                            %                         idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            %                             abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                            %
                            %                         [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            %                             abs(data(2) - data_reference_classes_aux(idx,2))...
                            %                             abs(data(3) - data_reference_classes_aux(idx,3))...
                            %                             abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                            %
                            %                         data_ref = data_reference_classes_aux(idx(idx1),:);
                            %                         data_reference_classes_aux(idx(idx1),:) = [];
                            %
                            %                         if size(data_ref,1) ~= 0
                            %                             true_positive_time = true_positive_time+1;
                            %                             if data(5) == 38 %time
                            %                                 if data(end) == 0 %letter
                            %                                     true_positive_class_time = true_positive_class_time+1;
                            %                                 end
                            %                             end
                            %                         end
                            %                     end
                            %
                            %                     false_negative_time = size(data_reference_classes_time,1) - true_positive_time; %missing result
                            %                     if false_negative_time < 0
                            %                         false_negative_time = 0;
                            %                     end
                            %
                            %                     false_positive_time = size(DATA_TIME,1)- size(data_reference_classes_time,1); %unexpected result
                            %                     if false_positive_time < 0
                            %                         false_positive_time = 0;
                            %                     end
                            %                     true_negative_time = 0; %Correct absence of result
                            %
                            %
                            %                     if size(DATA_TIME,1) == 0
                            %                         recall_time = 0; accuracy_class_time = 0; accuracy_time = 0; precision_time = 0;
                            %                     else
                            %                         accuracy_time = (true_positive_time + true_negative_time)/(true_positive_time + false_positive_time + false_negative_time + true_negative_time)*100;
                            %                         precision_time = true_positive_time/(true_positive_time + false_positive_time) * 100;
                            %                         recall_time = true_positive_time/(true_positive_time + false_negative_time) * 100;
                            %                         accuracy_class_time = true_positive_class_time/size(data_reference_classes_time,1)*100;
                            %                     end
                            %
                            %                     disp('Values for time (letter)')
                            %                     disp(['Accuracy = ', num2str(accuracy_time)])
                            %                     disp(['Precision = ', num2str(precision_time)])
                            %                     disp(['Recall = ', num2str(recall_time)])
                            %                     disp(['Classification accuracy = ', num2str(accuracy_class_time)])
                            %                     disp('-------------------------------------------------------------')
                            %
                            %                     fprintf(fidtimeL, '%s %f %f %f %f \r\n', name, accuracy_time, precision_time, recall_time, accuracy_class_time);
                            %
                            %                     accuracy_all_timeL(idxnames_others) = accuracy_time;
                            %                     precision_all_timeL(idxnames_others) = precision_time;
                            %                     recall_all_timeL(idxnames_others) = recall_time;
                            %                     accuracy_class_all_timeL(idxnames_others) = accuracy_class_time;
                            %
                            %                     %Time
                            %                     %typeTime = 1 Number
                            %                     true_positive_time = 0;
                            %                     true_positive_class_time = 0;
                            %                     idx = find(data_reference_classes(:,end) == 12);
                            %                     data_reference_classes_aux = data_reference_classes(idx,:);
                            %                     data_reference_classes_time = data_reference_classes(idx,:);
                            %                     for i=1:size(DATA_TIME,1)
                            %                         data = DATA_TIME(i,:);
                            %                         idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            %                             abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                            %
                            %                         [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            %                             abs(data(2) - data_reference_classes_aux(idx,2))...
                            %                             abs(data(3) - data_reference_classes_aux(idx,3))...
                            %                             abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                            %
                            %                         data_ref = data_reference_classes_aux(idx(idx1),:);
                            %                         data_reference_classes_aux(idx(idx1),:) = [];
                            %
                            %                         if size(data_ref,1) ~= 0
                            %                             true_positive_time = true_positive_time+1;
                            %                             if data(5) == 38 %time
                            %                                 if data(end) == 1 %number
                            %                                     true_positive_class_time = true_positive_class_time+1;
                            %                                 end
                            %                             end
                            %                         end
                            %                     end
                            %
                            %                     false_negative_time = size(data_reference_classes_time,1) - true_positive_time; %missing result
                            %                     if false_negative_time < 0
                            %                         false_negative_time = 0;
                            %                     end
                            %
                            %                     false_positive_time = size(DATA_TIME,1)- size(data_reference_classes_time,1); %unexpected result
                            %                     if false_positive_time < 0
                            %                         false_positive_time = 0;
                            %                     end
                            %                     true_negative_time = 0; %Correct absence of result
                            %
                            %                     if size(DATA_TIME,1) == 0
                            %                         recall_time = 0; accuracy_class_time = 0; accuracy_time = 0; precision_time = 0;
                            %                     else
                            %                         accuracy_time = (true_positive_time + true_negative_time)/(true_positive_time + false_positive_time + false_negative_time + true_negative_time)*100;
                            %                         precision_time = true_positive_time/(true_positive_time + false_positive_time) * 100;
                            %                         recall_time = true_positive_time/(true_positive_time + false_negative_time) * 100;
                            %                         accuracy_class_time = true_positive_class_time/size(data_reference_classes_time,1)*100;
                            %                     end
                            %
                            %                     disp('Values for time (number)')
                            %                     disp(['Accuracy = ', num2str(accuracy_time)])
                            %                     disp(['Precision = ', num2str(precision_time)])
                            %                     disp(['Recall = ', num2str(recall_time)])
                            %                     disp(['Classification accuracy = ', num2str(accuracy_class_time)])
                            %                     disp('-------------------------------------------------------------')
                            %
                            %                     fprintf(fidtimeN, '%s %f %f %f %f \r\n', name, accuracy_time, precision_time, recall_time, accuracy_class_time);
                            %
                            %                     accuracy_all_timeN(idxnames_others) = accuracy_time;
                            %                     precision_all_timeN(idxnames_others) = precision_time;
                            %                     recall_all_timeN(idxnames_others) = recall_time;
                            %                     accuracy_class_all_timeN(idxnames_others) = accuracy_class_time;
                        end
                        idxnames_others_idx = idxnames_others_idx + 11;
                    else
                        for idxnames_others=idxnames_others_idx:idxnames_others_idx+11
                            data_reference_classes = dlmread(strcat(results,'\',mainfilereference));
                            disp( sprintf('%s <-> %s',mainfilereference,fields{idxnames_others}));
                            
                            imgnamenostafflines = namesfilesresultsnostafflines{idxnames};
                            imgnamesymbols = namesfilesresultssymbols{idxnames};
                            
                            disp( sprintf('%s <-> %s',mainfilereference,imgnamenostafflines));
                            disp( sprintf('%s <-> %s',mainfilereference,imgnamesymbols));
                            
                            
                            data = getfield(ALLSYMBOLS,fields{idxnames_others});
                            fields_data = fieldnames(data);
                            DATA = [];
                            for i=1:size(fields_data,1)
                                a = getfield(data,fields_data{i});
                                
                                if size(a,1) == 0
                                    continue
                                end
                                DATA = [DATA; a(:,1:6)];
                            end
                            %                     data_barlines = getfield(ALLSYMBOLS_BARLINES,fields_barlines{idxnames_others});
                            %                     fields_data_barlines = fieldnames(data_barlines);
                            %                     DATA_BARLINES = [];
                            %                     for i=1:size(fields_data_barlines,1)
                            %                         a = getfield(data_barlines,fields_data_barlines{i});
                            %                         if size(a,1) == 0
                            %                             continue
                            %                         end
                            %                         DATA_BARLINES = [DATA_BARLINES; a(:,1:5)];
                            %                     end
                            %
                            %                     data_time = getfield(ALLSYMBOLS_TIME,fields_time{idxnames_others});
                            %                     fields_data_time = fieldnames(data_time);
                            %                     DATA_TIME = [];
                            %                     for i=1:size(fields_data_time,1)
                            %                         a = getfield(data_time,fields_data_time{i});
                            %                         if size(a,1) == 0
                            %                             continue
                            %                         end
                            %                         DATA_TIME = [DATA_TIME; a];
                            %                     end
                            
                            true_positive = 0;
                            true_positive_class = 0;
                            data_reference_classes_aux = data_reference_classes;
                            count = 0;
                            for i=1:size(DATA,1)
                                data = DATA(i,:);
                                idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                                    abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                                
                                [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                                    abs(data(2) - data_reference_classes_aux(idx,2))...
                                    abs(data(3) - data_reference_classes_aux(idx,3))...
                                    abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                                
                                data_ref = data_reference_classes_aux(idx(idx1),:);
                                data_reference_classes_aux(idx(idx1),:) = [];
                                
                                if size(data_ref,1) ~= 0
                                    true_positive = true_positive+1;
                                    
                                    aux1 = 0;
                                    aux2 = 0;
                                    aux = 0;
                                    if data(end) == 1 || data(end) == 2 || data(end) == 3 %acidentals
                                        aux = 9;
                                    elseif data(end) == 4 %accents
                                        aux = 27;
                                    elseif data(end) == 5 || data(end) == 7 %breve and semibreve
                                        aux = 24;
                                    elseif data(end) == 6 || data(end) == 8 %breve and semibreve with dot
                                        aux = 24;
                                        aux1 = 26;
                                    elseif data(end) == 9 %minim
                                        aux = 54;
                                    elseif data(end) == 10 %minim with dot
                                        aux = 54;
                                        aux1 = 26;
                                    elseif data(end) == 11 %quarter
                                        aux = 44;
                                    elseif data(end) == 12 %quarter with dot
                                        aux = 44;
                                        aux1 = 26;
                                    elseif data(end) == 13 || data(end) == 15 || data(end) == 17 || data(end) == 19 %Eighth, Sixteenth, Thirty-second and Sixty-fourth
                                        aux = 44;
                                        if data(end-1) == 1
                                            aux2 = 40;
                                        end
                                    elseif data(end) == 14 || data(end) == 16 || data(end) == 18 || data(end) == 20 %Eighth, Sixteenth, Thirty-second and Sixty-fourth with dot
                                        aux = 44;
                                        aux1 = 26;
                                        if data(end-1) == 1
                                            aux2 = 40;
                                        end
                                    elseif data(end) == 21 %doublewhole
                                        aux = 39;
                                    elseif data(end) == 22 %doublewhole with dot
                                        aux = 39;
                                        aux1 = 26;
                                    elseif data(end) == 23 || data(end) == 25 %whole and half
                                        aux = 38;
                                    elseif data(end) == 24 || data(end) == 26 %whole and half with dot
                                        aux = 38;
                                        aux1 = 26;
                                    elseif data(end) == 27 || data(end) == 29 || data(end) == 31 || data(end) == 33 || data(end) == 35 %quarter, Eighth, Sixteenth, Thirty-second and Sixty-fourth rest
                                        aux = 4;
                                    elseif data(end) == 28 || data(end) == 30 || data(end) == 32 || data(end) == 34 || data(end) == 36 %quarter, Eighth, Sixteenth, Thirty-second and Sixty-fourth rest with dot
                                        aux = 4;
                                        aux1 = 26;
                                    elseif data(end) == 37 %barlines
                                        aux = 37;
                                    elseif data(end) == 38 %timeN
                                        aux = 12;
                                    elseif data(end) == 39 %timeL
                                        aux = 22;
                                    elseif data(end) == 40 %clefs
                                        aux = 1;
                                    end
                                    
                                    if aux == data_ref(5)
                                        true_positive_class = true_positive_class+1;
                                    end
                                    if aux1~=0 & aux == data_ref(5)
                                        true_positive_class = true_positive_class+1;
                                        true_positive = true_positive+1; % dot
                                        count = count + 1;
                                    end
                                    if aux2~=0 & aux == data_ref(5)
                                        true_positive_class = true_positive_class+1;
                                        true_positive = true_positive+1; % beams
                                        count = count + 1;
                                    end
                                end
                            end
                            false_negative = size(data_reference_classes,1) - true_positive; %missing result
                            if false_negative < 0
                                false_negative = 0;
                            end
                            
                            false_positive = size(DATA,1)+count- size(data_reference_classes,1); %unexpected result
                            if false_positive < 0
                                false_positive = 0;
                            end
                            
                            imgnostafflines = imread(strcat(resultsnostafflines,'\',imgnamenostafflines));
                            if(size(imgnostafflines,3)>1)
                                %Otsu
                                imgnostafflines = rgb2gray(imgnostafflines);
                                t=graythresh(imgnostafflines);
                                imgnostafflines=im2bw(imgnostafflines,t);
                            else
                                %Otsu or BLIST
                                imgnostafflines=imgnostafflines./255;
                                imgnostafflines=logical(imgnostafflines);
                            end
                            
                            imgsymbols = imread(strcat(resultssymbols,'\',imgnamesymbols));
                            if(size(imgsymbols,3)>1)
                                %Otsu
                                imgsymbols = rgb2gray(imgsymbols);
                                t=graythresh(imgsymbols);
                                imgsymbols=im2bw(imgsymbols,t);
                            else
                                %Otsu or BLIST
                                imgsymbols=imgsymbols./255;
                                imgsymbols=logical(imgsymbols);
                            end
                            
                            
                            img = 1-abs(imgnostafflines-imgsymbols);
                            img=double(img);
                            L = bwlabel(1-img);
                            s  = regionprops(L, 'BoundingBox');
                            BoundingBox = cat(1, s.BoundingBox);
                            BoundingBox=floor(BoundingBox);
                            noise = [BoundingBox(:,2) BoundingBox(:,2)+BoundingBox(:,4) BoundingBox(:,1) BoundingBox(:,1)+BoundingBox(:,3)];
                            [row,col]=find(noise == 0);
                            noise(row,col)=1;
                            [value idx]=sort(noise(:,1));
                            
                            true_negative = size(noise,1); %Correct absence of result
                            
                            if (size(DATA,1)+count) == 0
                                accuracy = 0; precision = 0; recall = 0; accuracy_class = 0;
                            else
                                accuracy = (true_positive + true_negative)/(true_positive + false_positive + false_negative + true_negative)*100;
                                precision = true_positive/(true_positive + false_positive) * 100;
                                recall = true_positive/(true_positive + false_negative) * 100;
                                accuracy_class = true_positive_class/true_positive*100;
                            end
                            
                            disp('Values for all symbols')
                            disp(['Accuracy = ', num2str(accuracy)])
                            disp(['Precision = ', num2str(precision)])
                            disp(['Recall = ', num2str(recall)])
                            disp(['Classification accuracy = ', num2str(accuracy_class)])
                            disp('-------------------------------------------------------------')
                            
                            fprintf(fid, '%s %f %f %f %f \r\n', name, accuracy, precision, recall, accuracy_class);
                            
                            accuracy_all(idxnames_others) = accuracy;
                            precision_all(idxnames_others) = precision;
                            recall_all(idxnames_others) = recall;
                            accuracy_class_all(idxnames_others) = accuracy_class;
                            
                            true_positive = recall;
                            false_positive = false_positive/(true_negative+false_positive)*100;
                            
                            true_negative = true_negative/(true_negative+false_positive)*100;
                            false_negative = false_negative/(true_positive+false_negative)*100;

                            true_positive_all(idxnames_others) = true_positive;
                            true_negative_all(idxnames_others) = true_negative;
                            false_positive_all(idxnames_others) = false_positive;
                            false_negative_all(idxnames_others) = false_negative;
                            
                            %                     %Barlines
                            %                     true_positive_barlines = 0;
                            %                     true_positive_class_barlines = 0;
                            %                     idx = find(data_reference_classes(:,end) == 37);
                            %                     data_reference_classes_aux = data_reference_classes(idx,:);
                            %                     data_reference_classes_barlines = data_reference_classes(idx,:);
                            %                     for i=1:size(DATA_BARLINES,1)
                            %                         data = DATA_BARLINES(i,:);
                            %                         idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            %                             abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                            %
                            %                         [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            %                             abs(data(2) - data_reference_classes_aux(idx,2))...
                            %                             abs(data(3) - data_reference_classes_aux(idx,3))...
                            %                             abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                            %
                            %                         data_ref = data_reference_classes_aux(idx(idx1),:);
                            %                         data_reference_classes_aux(idx(idx1),:) = [];
                            %
                            %                         if size(data_ref,1) ~= 0
                            %                             true_positive_barlines = true_positive_barlines+1;
                            %                             if data(end) == data_ref(5)
                            %                                 true_positive_class_barlines = true_positive_class_barlines+1;
                            %                             end
                            %                         end
                            %                     end
                            %
                            %                     false_negative_barlines = size(data_reference_classes_barlines,1) - true_positive_barlines; %missing result
                            %                     if false_negative_barlines < 0
                            %                         false_negative_barlines = 0;
                            %                     end
                            %
                            %                     false_positive_barlines = size(DATA_BARLINES,1)- size(data_reference_classes_barlines,1); %unexpected result
                            %                     if false_positive_barlines < 0
                            %                         false_positive_barlines = 0;
                            %                     end
                            %                     true_negative_barlines = 0; %Correct absence of result
                            %
                            %
                            %                     if size(DATA_BARLINES,1) == 0
                            %                         recall_barlines = 0; accuracy_class_barlines = 0; accuracy_barlines = 0; precision_barlines = 0;
                            %                     else
                            %                         accuracy_barlines = (true_positive_barlines + true_negative_barlines)/(true_positive_barlines + false_positive_barlines + false_negative_barlines + true_negative_barlines)*100;
                            %                         precision_barlines = true_positive_barlines/(true_positive_barlines + false_positive_barlines) * 100;
                            %                         recall_barlines = true_positive_barlines/(true_positive_barlines + false_negative_barlines) * 100;
                            %                         accuracy_class_barlines = true_positive_class_barlines/size(data_reference_classes_barlines,1)*100;
                            %                     end
                            %
                            %                     disp('Values for barlines')
                            %                     disp(['Accuracy = ', num2str(accuracy_barlines)])
                            %                     disp(['Precision = ', num2str(precision_barlines)])
                            %                     disp(['Recall = ', num2str(recall_barlines)])
                            %                     disp(['Classification accuracy = ', num2str(accuracy_class_barlines)])
                            %                     disp('-------------------------------------------------------------')
                            %
                            %                     fprintf(fidbarlines, '%s %f %f %f %f \r\n', name, accuracy_barlines, precision_barlines, recall_barlines, accuracy_class_barlines);
                            %
                            %                     accuracy_all_barlines(idxnames_others) = accuracy_barlines;
                            %                     precision_all_barlines(idxnames_others) = precision_barlines;
                            %                     recall_all_barlines(idxnames_others) = recall_barlines;
                            %                     accuracy_class_all_barlines(idxnames_others) = accuracy_class_barlines;
                            %
                            %                     %Time
                            %                     %typeTime = 0 Letter
                            %                     true_positive_time = 0;
                            %                     true_positive_class_time = 0;
                            %                     idx = find(data_reference_classes(:,end) == 22);
                            %                     data_reference_classes_aux = data_reference_classes(idx,:);
                            %                     data_reference_classes_time = data_reference_classes(idx,:);
                            %                     for i=1:size(DATA_TIME,1)
                            %                         data = DATA_TIME(i,:);
                            %                         idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            %                             abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                            %
                            %                         [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            %                             abs(data(2) - data_reference_classes_aux(idx,2))...
                            %                             abs(data(3) - data_reference_classes_aux(idx,3))...
                            %                             abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                            %
                            %                         data_ref = data_reference_classes_aux(idx(idx1),:);
                            %                         data_reference_classes_aux(idx(idx1),:) = [];
                            %
                            %                         if size(data_ref,1) ~= 0
                            %                             true_positive_time = true_positive_time+1;
                            %                             if data(5) == 38 %time
                            %                                 if data(end) == 0 %letter
                            %                                     true_positive_class_time = true_positive_class_time+1;
                            %                                 end
                            %                             end
                            %                         end
                            %                     end
                            %
                            %                     false_negative_time = size(data_reference_classes_time,1) - true_positive_time; %missing result
                            %                     if false_negative_time < 0
                            %                         false_negative_time = 0;
                            %                     end
                            %
                            %                     false_positive_time = size(DATA_TIME,1)- size(data_reference_classes_time,1); %unexpected result
                            %                     if false_positive_time < 0
                            %                         false_positive_time = 0;
                            %                     end
                            %                     true_negative_time = 0; %Correct absence of result
                            %
                            %
                            %                     if size(DATA_TIME,1) == 0
                            %                         recall_time = 0; accuracy_class_time = 0; accuracy_time = 0; precision_time = 0;
                            %                     else
                            %                         accuracy_time = (true_positive_time + true_negative_time)/(true_positive_time + false_positive_time + false_negative_time + true_negative_time)*100;
                            %                         precision_time = true_positive_time/(true_positive_time + false_positive_time) * 100;
                            %                         recall_time = true_positive_time/(true_positive_time + false_negative_time) * 100;
                            %                         accuracy_class_time = true_positive_class_time/size(data_reference_classes_time,1)*100;
                            %                     end
                            %
                            %                     disp('Values for time (letter)')
                            %                     disp(['Accuracy = ', num2str(accuracy_time)])
                            %                     disp(['Precision = ', num2str(precision_time)])
                            %                     disp(['Recall = ', num2str(recall_time)])
                            %                     disp(['Classification accuracy = ', num2str(accuracy_class_time)])
                            %                     disp('-------------------------------------------------------------')
                            %
                            %                     fprintf(fidtimeL, '%s %f %f %f %f \r\n', name, accuracy_time, precision_time, recall_time, accuracy_class_time);
                            %
                            %                     accuracy_all_timeL(idxnames_others) = accuracy_time;
                            %                     precision_all_timeL(idxnames_others) = precision_time;
                            %                     recall_all_timeL(idxnames_others) = recall_time;
                            %                     accuracy_class_all_timeL(idxnames_others) = accuracy_class_time;
                            %
                            %                     %Time
                            %                     %typeTime = 1 Number
                            %                     true_positive_time = 0;
                            %                     true_positive_class_time = 0;
                            %                     idx = find(data_reference_classes(:,end) == 12);
                            %                     data_reference_classes_aux = data_reference_classes(idx,:);
                            %                     data_reference_classes_time = data_reference_classes(idx,:);
                            %                     for i=1:size(DATA_TIME,1)
                            %                         data = DATA_TIME(i,:);
                            %                         idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            %                             abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                            %
                            %                         [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            %                             abs(data(2) - data_reference_classes_aux(idx,2))...
                            %                             abs(data(3) - data_reference_classes_aux(idx,3))...
                            %                             abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                            %
                            %                         data_ref = data_reference_classes_aux(idx(idx1),:);
                            %                         data_reference_classes_aux(idx(idx1),:) = [];
                            %
                            %                         if size(data_ref,1) ~= 0
                            %                             true_positive_time = true_positive_time+1;
                            %                             if data(5) == 38 %time
                            %                                 if data(end) == 1 %number
                            %                                     true_positive_class_time = true_positive_class_time+1;
                            %                                 end
                            %                             end
                            %                         end
                            %                     end
                            %
                            %                     false_negative_time = size(data_reference_classes_time,1) - true_positive_time; %missing result
                            %                     if false_negative_time < 0
                            %                         false_negative_time = 0;
                            %                     end
                            %
                            %                     false_positive_time = size(DATA_TIME,1)- size(data_reference_classes_time,1); %unexpected result
                            %                     if false_positive_time < 0
                            %                         false_positive_time = 0;
                            %                     end
                            %                     true_negative_time = 0; %Correct absence of result
                            %
                            %                     if size(DATA_TIME,1) == 0
                            %                         recall_time = 0; accuracy_class_time = 0; accuracy_time = 0; precision_time = 0;
                            %                     else
                            %                         accuracy_time = (true_positive_time + true_negative_time)/(true_positive_time + false_positive_time + false_negative_time + true_negative_time)*100;
                            %                         precision_time = true_positive_time/(true_positive_time + false_positive_time) * 100;
                            %                         recall_time = true_positive_time/(true_positive_time + false_negative_time) * 100;
                            %                         accuracy_class_time = true_positive_class_time/size(data_reference_classes_time,1)*100;
                            %                     end
                            %
                            %                     disp('Values for time (number)')
                            %                     disp(['Accuracy = ', num2str(accuracy_time)])
                            %                     disp(['Precision = ', num2str(precision_time)])
                            %                     disp(['Recall = ', num2str(recall_time)])
                            %                     disp(['Classification accuracy = ', num2str(accuracy_class_time)])
                            %                     disp('-------------------------------------------------------------')
                            %
                            %                     fprintf(fidtimeN, '%s %f %f %f %f \r\n', name, accuracy_time, precision_time, recall_time, accuracy_class_time);
                            %
                            %                     accuracy_all_timeN(idxnames_others) = accuracy_time;
                            %                     precision_all_timeN(idxnames_others) = precision_time;
                            %                     recall_all_timeN(idxnames_others) = recall_time;
                            %                     accuracy_class_all_timeN(idxnames_others) = accuracy_class_time;
                            
                        end
                        idxnames_others_idx = idxnames_others_idx + 12;
                    end
                end
                
                accuracy_all(isnan(accuracy_all)) = 0;
                precision_all(isnan(precision_all)) = 0;
                recall_all(isnan(recall_all)) = 0;
                accuracy_class_all(isnan(accuracy_class_all));
                
                true_positive_all(isnan(true_positive_all)) = 0;
                true_negative_all(isnan(true_negative_all)) = 0;
                false_positive_all(isnan(false_positive_all)) = 0;
                false_negative_all(isnan(false_negative_all)) = 0;
                
                meanaccuracy = mean(accuracy_all);
                meanprecision = mean(precision_all);
                meanrecall = mean(recall_all);
                meanaccuracyclass = mean(accuracy_class_all);
                
                meanatrue_positive = mean(true_positive_all);
                meantrue_negative = mean(true_negative_all);
                meanfalse_positive = mean(false_positive_all);
                meanfalse_negative = mean(false_negative_all);
                
                fprintf(fid, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                fprintf(fid, '%f %f %f %f \r\n', meanatrue_positive, meantrue_negative, meanfalse_positive, meanfalse_negative);
                fclose(fid);
                
                %         meanaccuracy = mean(accuracy_all_barlines);
                %         meanprecision = mean(precision_all_barlines);
                %         meanrecall = mean(recall_all_barlines);
                %         meanaccuracyclass = mean(accuracy_class_all_barlines);
                %
                %         fprintf(fidbarlines, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                %         fclose(fidbarlines);
                %
                %         meanaccuracy = mean(accuracy_all_timeL);
                %         meanprecision = mean(precision_all_timeL);
                %         meanrecall = mean(recall_all_timeL);
                %         meanaccuracyclass = mean(accuracy_class_all_timeL);
                %
                %         fprintf(fidtimeL, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                %         fclose(fidtimeL);
                %
                %         meanaccuracy = mean(accuracy_all_timeN);
                %         meanprecision = mean(precision_all_timeN);
                %         meanrecall = mean(recall_all_timeN);
                %         meanaccuracyclass = mean(accuracy_class_all_timeN);
                %
                %         fprintf(fidtimeN, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                %         fclose(fidtimeN);
                
            case 'other'
                
                scoretype = 'scanned';
                
                load ALLSYMBOLS_scanned_cd
                fields = fieldnames(ALLSYMBOLS);
                
                %         fields = fields([1 2 3 6 7 15]);
                
                
                
                %         load ALLSYMBOLS_BARLINES_real
                %         fields_barlines = fieldnames(ALLSYMBOLS_BARLINES);
                %
                %         load ALLSYMBOLS_TIME_real
                %         fields_time = fieldnames(ALLSYMBOLS_TIME);
                
                local = 'dataBaseEvaluation\';
                files = strcat(local,'results_',scoretype);
                
                results = strcat(files,'\references\classes');
                dresults=dir(results);
                dresults=struct2cell(dresults);
                namesfilesresults=dresults(1,3:end,:);
                
                resultsnostafflines = strcat(files,'\references\nostafflines');
                dresultsnostafflines=dir(resultsnostafflines);
                dresultsnostafflines=struct2cell(dresultsnostafflines);
                namesfilesresultsnostafflines=dresultsnostafflines(1,3:end,:);
                
                resultssymbols = strcat(files,'\references\symbols');
                dresultssymbols=dir(resultssymbols);
                dresultssymbols=struct2cell(dresultssymbols);
                namesfilesresultssymbols=dresultssymbols(1,3:end,:);
                

                filename = strcat('results_',scoretype,'_sc_cd.txt');
                fid = fopen(filename, 'w');
                
                %         filename = strcat(scoretype,'_sc_barlines.txt');
                %         fidbarlines = fopen(filename, 'w');
                %
                %         filename = strcat(scoretype,'_sc_timeL.txt');
                %         fidtimeL = fopen(filename, 'w');
                %
                %         filename = strcat(scoretype,'_sc_timeN.txt');
                %         fidtimeN = fopen(filename, 'w');
                
                accuracy_all = zeros(1,length(namesfilesresults));
                precision_all = accuracy_all;
                recall_all = accuracy_all;
                accuracy_class_all = accuracy_all;
                true_positive_all = accuracy_all;
                true_negative_all = accuracy_all;
                false_positive_all = accuracy_all;
                false_negative_all = accuracy_all;
                
                %         accuracy_all_barlines = accuracy_all;
                %         precision_all_barlines = accuracy_all;
                %         recall_all_barlines = accuracy_all;
                %         accuracy_class_all_barlines = accuracy_all;
                %
                %         accuracy_all_timeL = accuracy_all;
                %         precision_all_timeL = accuracy_all;
                %         recall_all_timeL = accuracy_all;
                %         accuracy_class_all_timeL = accuracy_all;
                %
                %         accuracy_all_timeN = accuracy_all;
                %         precision_all_timeN = accuracy_all;
                %         recall_all_timeN = accuracy_all;
                %         accuracy_class_all_timeN = accuracy_all;

                for idxnames=1:length(namesfilesresults)
                    aux = namesfilesresults{idxnames};
                    imgnamenostafflines = namesfilesresultsnostafflines{idxnames};
                    imgnamesymbols = namesfilesresultssymbols{idxnames};
                    
                    data_reference_classes = dlmread(strcat(results,'\',aux));
                    if data_reference_classes(1,end) == 0
                        data_reference_classes(:,end) = [];
                    end
                    
                    disp( sprintf('%s <-> %s',aux,fields{idxnames}));
                    disp( sprintf('%s <-> %s',aux,imgnamenostafflines));
                    disp( sprintf('%s <-> %s',aux,imgnamesymbols));
                    
                    
                    data = getfield(ALLSYMBOLS,fields{idxnames});
                    fields_data = fieldnames(data);
                    DATA = [];
                    for i=1:size(fields_data,1)
                        a = getfield(data,fields_data{i});
                        if size(a,1) == 0
                            continue
                        end
                        DATA = [DATA; a(:,1:6)];
                    end
                    
                    %             data_barlines = getfield(ALLSYMBOLS_BARLINES,fields_barlines{idxnames_others});
                    %             fields_data_barlines = fieldnames(data_barlines);
                    %             DATA_BARLINES = [];
                    %             for i=1:size(fields_data_barlines,1)
                    %                 a = getfield(data_barlines,fields_data_barlines{i});
                    %                 if size(a,1) == 0
                    %                     continue
                    %                 end
                    %                 DATA_BARLINES = [DATA_BARLINES; a(:,1:5)];
                    %             end
                    %
                    %             data_time = getfield(ALLSYMBOLS_TIME,fields_time{idxnames_others});
                    %             fields_data_time = fieldnames(data_time);
                    %             DATA_TIME = [];
                    %             for i=1:size(fields_data_time,1)
                    %                 a = getfield(data_time,fields_data_time{i});
                    %                 if size(a,1) == 0
                    %                     continue
                    %                 end
                    %                 DATA_TIME = [DATA_TIME; a];
                    %             end
                    
                    
                    
                    true_positive = 0;
                    true_positive_class = 0;
                    data_reference_classes_aux = data_reference_classes;
                    count = 0;
                    for i=1:size(DATA,1)
                        data = DATA(i,:);
                        idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                            abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                        
                        [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                            abs(data(2) - data_reference_classes_aux(idx,2))...
                            abs(data(3) - data_reference_classes_aux(idx,3))...
                            abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                        
                        data_ref = data_reference_classes_aux(idx(idx1),:);
                        data_reference_classes_aux(idx(idx1),:) = [];
                        
                        if size(data_ref,1) ~= 0
                            true_positive = true_positive+1;
                            
                            aux1 = 0;
                            aux2 = 0;
                            aux = 0;
                            if data(end) == 1 %acidentals
                                aux = 9;
                            elseif data(end) == 4-2 %accents
                                aux = 27;
                            elseif data(end) == 5-2 || data(end) == 7-2 %breve and semibreve
                                aux = 24;
                            elseif data(end) == 6-2 || data(end) == 8-2 %breve and semibreve with dot
                                aux = 24;
                                aux1 = 26;
                            elseif data(end) == 9-2 %minim
                                aux = 54;
                            elseif data(end) == 10-2 %minim with dot
                                aux = 54;
                                aux1 = 26;
                            elseif data(end) == 11-2 %quarter
                                aux = 44;
                            elseif data(end) == 12-2 %quarter with dot
                                aux = 44;
                                aux1 = 26;
                            elseif data(end) == 13-2 || data(end) == 15-2 || data(end) == 17-2 || data(end) == 19-2 %Eighth, Sixteenth, Thirty-second and Sixty-fourth
                                aux = 44;
                                if data(end-1) == 1
                                    aux2 = 40;
                                end
                            elseif data(end) == 14-2 || data(end) == 16-2 || data(end) == 18-2 || data(end) == 20-2 %Eighth, Sixteenth, Thirty-second and Sixty-fourth with dot
                                aux = 44;
                                aux1 = 26;
                                if data(end-1) == 1
                                    aux2 = 40;
                                end
                            elseif data(end) == 21-2 %doublewhole
                                aux = 39;
                            elseif data(end) == 22-2 %doublewhole with dot
                                aux = 39;
                                aux1 = 26;
                            elseif data(end) == 23-2 || data(end) == 25-2 %whole and half
                                aux = 38;
                            elseif data(end) == 24-2 || data(end) == 26-2 %whole and half with dot
                                aux = 38;
                                aux1 = 26;
                            elseif data(end) == 27-2 || data(end) == 29-2 || data(end) == 31-2 || data(end) == 33-2 || data(end) == 35-2 %quarter, Eighth, Sixteenth, Thirty-second and Sixty-fourth rest
                                aux = 4;
                            elseif data(end) == 28-2 || data(end) == 30-2 || data(end) == 32-2 || data(end) == 34-2 || data(end) == 36-2 %quarter, Eighth, Sixteenth, Thirty-second and Sixty-fourth rest with dot
                                aux = 4;
                                aux1 = 26;
                            elseif data(end) == 37 %barlines
                                aux = 37;
                            elseif data(end) == 38 %timeN
                                aux = 12;
                            elseif data(end) == 39 %timeL
                                aux = 22;
                            elseif data(end) == 40 %clefs
                                aux = 1;
                            end
                            
                            if aux == data_ref(5)
                                true_positive_class = true_positive_class+1;
                            end
                            if aux1~=0 & aux == data_ref(5)
                                true_positive_class = true_positive_class+1;
                                true_positive = true_positive+1; % dot
                                count = count +1;
                            end
                            if aux2~=0 & aux == data_ref(5)
                                true_positive_class = true_positive_class+1;
                                true_positive = true_positive+1; % beam
                                count = count +1;
                            end
                        end
                    end
                    false_negative = size(data_reference_classes,1) - true_positive; %missing result
                    if false_negative < 0
                        false_negative = 0;
                    end
                    
                    false_positive = size(DATA,1)+count- size(data_reference_classes,1); %unexpected result
                    if false_positive < 0
                        false_positive = 0;
                    end
                    
                    imgnostafflines = imread(strcat(resultsnostafflines,'\',imgnamenostafflines));
                    if(size(imgnostafflines,3)>1)
                        %Otsu
                        imgnostafflines = rgb2gray(imgnostafflines);
                        t=graythresh(imgnostafflines);
                        imgnostafflines=im2bw(imgnostafflines,t);
                    else
                        %Otsu or BLIST
                        imgnostafflines=imgnostafflines./255;
                        imgnostafflines=logical(imgnostafflines);
                    end
                    
                    imgsymbols = imread(strcat(resultssymbols,'\',imgnamesymbols));
                    if(size(imgsymbols,3)>1)
                        %Otsu
                        imgsymbols = rgb2gray(imgsymbols);
                        t=graythresh(imgsymbols);
                        imgsymbols=im2bw(imgsymbols,t);
                    else
                        %Otsu or BLIST
                        imgsymbols=imgsymbols./255;
                        imgsymbols=logical(imgsymbols);
                    end
                    
                    
                    img = 1-abs(imgnostafflines-imgsymbols);
                    img=double(img);
                    L = bwlabel(1-img);
                    s  = regionprops(L, 'BoundingBox');
                    BoundingBox = cat(1, s.BoundingBox);
                    BoundingBox=floor(BoundingBox);
                    noise = [BoundingBox(:,2) BoundingBox(:,2)+BoundingBox(:,4) BoundingBox(:,1) BoundingBox(:,1)+BoundingBox(:,3)];
                    [row,col]=find(noise == 0);
                    noise(row,col)=1;
                    [value idx]=sort(noise(:,1));
                    
                    true_negative = size(noise,1); %Correct absence of result
                    
                    
                    accuracy = (true_positive + true_negative)/(true_positive + false_positive + false_negative + true_negative)*100;
                    precision = true_positive/(true_positive + false_positive) * 100;
                    recall = true_positive/(true_positive + false_negative) * 100;
                    accuracy_class = true_positive_class/true_positive*100;
                    
                    disp('Values for all symbols')
                    disp(['Accuracy = ', num2str(accuracy)])
                    disp(['Precision = ', num2str(precision)])
                    disp(['Recall = ', num2str(recall)])
                    disp(['Classification accuracy = ', num2str(accuracy_class)])
                    disp('-------------------------------------------------------------')
                    
                    fprintf(fid, '%s %f %f %f %f \r\n', name, accuracy, precision, recall, accuracy_class);
                    
                    accuracy_all(idxnames) = accuracy;
                    precision_all(idxnames) = precision;
                    recall_all(idxnames) = recall;
                    accuracy_class_all(idxnames) = accuracy_class;
                    
                    true_positive = recall;
                    false_positive = false_positive/(true_negative+false_positive)*100;
                    
                    true_negative = true_negative/(true_negative+false_positive)*100;
                    false_negative = false_negative/(true_positive+false_negative)*100;
                    
                    true_positive_all(idxnames) = true_positive;
                    true_negative_all(idxnames) = true_negative;
                    false_positive_all(idxnames) = false_positive;
                    false_negative_all(idxnames) = false_negative;
                    
                    %             %Barlines
                    %             true_positive_barlines = 0;
                    %             true_positive_class_barlines = 0;
                    %             idx = find(data_reference_classes(:,end) == 37);
                    %             data_reference_classes_aux = data_reference_classes(idx,:);
                    %             data_reference_classes_barlines = data_reference_classes(idx,:);
                    %             for i=1:size(DATA_BARLINES,1)
                    %                 data = DATA_BARLINES(i,:);
                    %                 idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                    %                     abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                    %
                    %                 [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                    %                     abs(data(2) - data_reference_classes_aux(idx,2))...
                    %                     abs(data(3) - data_reference_classes_aux(idx,3))...
                    %                     abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                    %
                    %                 data_ref = data_reference_classes_aux(idx(idx1),:);
                    %                 data_reference_classes_aux(idx(idx1),:) = [];
                    %
                    %                 if size(data_ref,1) ~= 0
                    %                     true_positive_barlines = true_positive_barlines+1;
                    %                     if data(end) == data_ref(5)
                    %                         true_positive_class_barlines = true_positive_class_barlines+1;
                    %                     end
                    %                 end
                    %             end
                    %
                    %             false_negative_barlines = size(data_reference_classes_barlines,1) - true_positive_barlines; %missing result
                    %             if false_negative_barlines < 0
                    %                 false_negative_barlines = 0;
                    %             end
                    %
                    %             false_positive_barlines = size(DATA_BARLINES,1)- size(data_reference_classes_barlines,1); %unexpected result
                    %             if false_positive_barlines < 0
                    %                 false_positive_barlines = 0;
                    %             end
                    %             true_negative_barlines = 0; %Correct absence of result
                    %
                    %
                    %             if size(DATA_BARLINES,1) == 0
                    %                 recall_barlines = 0; accuracy_class_barlines = 0; accuracy_barlines = 0; precision_barlines = 0;
                    %             else
                    %                 accuracy_barlines = (true_positive_barlines + true_negative_barlines)/(true_positive_barlines + false_positive_barlines + false_negative_barlines + true_negative_barlines)*100;
                    %                 precision_barlines = true_positive_barlines/(true_positive_barlines + false_positive_barlines) * 100;
                    %                 recall_barlines = true_positive_barlines/(true_positive_barlines + false_negative_barlines) * 100;
                    %                 accuracy_class_barlines = true_positive_class_barlines/size(data_reference_classes_barlines,1)*100;
                    %             end
                    %
                    %             disp('Values for barlines')
                    %             disp(['Accuracy = ', num2str(accuracy_barlines)])
                    %             disp(['Precision = ', num2str(precision_barlines)])
                    %             disp(['Recall = ', num2str(recall_barlines)])
                    %             disp(['Classification accuracy = ', num2str(accuracy_class_barlines)])
                    %             disp('-------------------------------------------------------------')
                    %
                    %             fprintf(fidbarlines, '%s %f %f %f %f \r\n', name, accuracy_barlines, precision_barlines, recall_barlines, accuracy_class_barlines);
                    %
                    %             accuracy_all_barlines(idxnames) = accuracy_barlines;
                    %             precision_all_barlines(idxnames) = precision_barlines;
                    %             recall_all_barlines(idxnames) = recall_barlines;
                    %             accuracy_class_all_barlines(idxnames) = accuracy_class_barlines;
                    %
                    %             %Time
                    %             %typeTime = 0 Letter
                    %             true_positive_time = 0;
                    %             true_positive_class_time = 0;
                    %             idx = find(data_reference_classes(:,end) == 22);
                    %             data_reference_classes_aux = data_reference_classes(idx,:);
                    %             data_reference_classes_time = data_reference_classes(idx,:);
                    %             for i=1:size(DATA_TIME,1)
                    %                 data = DATA_TIME(i,:);
                    %                 idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                    %                     abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                    %
                    %                 [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                    %                     abs(data(2) - data_reference_classes_aux(idx,2))...
                    %                     abs(data(3) - data_reference_classes_aux(idx,3))...
                    %                     abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                    %
                    %                 data_ref = data_reference_classes_aux(idx(idx1),:);
                    %                 data_reference_classes_aux(idx(idx1),:) = [];
                    %
                    %                 if size(data_ref,1) ~= 0
                    %                     true_positive_time = true_positive_time+1;
                    %                     if data(5) == 38 %time
                    %                         if data(end) == 0 %letter
                    %                             true_positive_class_time = true_positive_class_time+1;
                    %                         end
                    %                     end
                    %                 end
                    %             end
                    %
                    %             false_negative_time = size(data_reference_classes_time,1) - true_positive_time; %missing result
                    %             if false_negative_time < 0
                    %                 false_negative_time = 0;
                    %             end
                    %
                    %             false_positive_time = size(DATA_TIME,1)- size(data_reference_classes_time,1); %unexpected result
                    %             if false_positive_time < 0
                    %                 false_positive_time = 0;
                    %             end
                    %             true_negative_time = 0; %Correct absence of result
                    %
                    %
                    %             if size(DATA_TIME,1) == 0
                    %                 recall_time = 0; accuracy_class_time = 0; accuracy_time = 0; precision_time = 0;
                    %             else
                    %                 accuracy_time = (true_positive_time + true_negative_time)/(true_positive_time + false_positive_time + false_negative_time + true_negative_time)*100;
                    %                 precision_time = true_positive_time/(true_positive_time + false_positive_time) * 100;
                    %                 recall_time = true_positive_time/(true_positive_time + false_negative_time) * 100;
                    %                 accuracy_class_time = true_positive_class_time/size(data_reference_classes_time,1)*100;
                    %             end
                    %
                    %             disp('Values for time (letter)')
                    %             disp(['Accuracy = ', num2str(accuracy_time)])
                    %             disp(['Precision = ', num2str(precision_time)])
                    %             disp(['Recall = ', num2str(recall_time)])
                    %             disp(['Classification accuracy = ', num2str(accuracy_class_time)])
                    %             disp('-------------------------------------------------------------')
                    %
                    %             fprintf(fidtimeL, '%s %f %f %f %f \r\n', name, accuracy_time, precision_time, recall_time, accuracy_class_time);
                    %
                    %             accuracy_all_timeL(idxnames) = accuracy_time;
                    %             precision_all_timeL(idxnames) = precision_time;
                    %             recall_all_timeL(idxnames) = recall_time;
                    %             accuracy_class_all_timeL(idxnames) = accuracy_class_time;
                    %
                    %             %Time
                    %             %typeTime = 1 Number
                    %             true_positive_time = 0;
                    %             true_positive_class_time = 0;
                    %             idx = find(data_reference_classes(:,end) == 12);
                    %             data_reference_classes_aux = data_reference_classes(idx,:);
                    %             data_reference_classes_time = data_reference_classes(idx,:);
                    %             for i=1:size(DATA_TIME,1)
                    %                 data = DATA_TIME(i,:);
                    %                 idx = find( abs(data(1) - data_reference_classes_aux(:,1)) <= 100 & abs(data(2) - data_reference_classes_aux(:,2)) <= 100 & ...
                    %                     abs(data(3) - data_reference_classes_aux(:,3)) <= 100 & abs(data(4) - data_reference_classes_aux(:,4)) <= 100);
                    %
                    %                 [~, idx1] = min(min([abs(data(1) - data_reference_classes_aux(idx,1))...
                    %                     abs(data(2) - data_reference_classes_aux(idx,2))...
                    %                     abs(data(3) - data_reference_classes_aux(idx,3))...
                    %                     abs(data(4) - data_reference_classes_aux(idx,4))],[],2));
                    %
                    %                 data_ref = data_reference_classes_aux(idx(idx1),:);
                    %                 data_reference_classes_aux(idx(idx1),:) = [];
                    %
                    %                 if size(data_ref,1) ~= 0
                    %                     true_positive_time = true_positive_time+1;
                    %                     if data(5) == 38 %time
                    %                         if data(end) == 1 %number
                    %                             true_positive_class_time = true_positive_class_time+1;
                    %                         end
                    %                     end
                    %                 end
                    %             end
                    %
                    %             false_negative_time = size(data_reference_classes_time,1) - true_positive_time; %missing result
                    %             if false_negative_time < 0
                    %                 false_negative_time = 0;
                    %             end
                    %
                    %             false_positive_time = size(DATA_TIME,1)- size(data_reference_classes_time,1); %unexpected result
                    %             if false_positive_time < 0
                    %                 false_positive_time = 0;
                    %             end
                    %             true_negative_time = 0; %Correct absence of result
                    %
                    %             if size(DATA_TIME,1) == 0
                    %                 recall_time = 0; accuracy_class_time = 0; accuracy_time = 0; precision_time = 0;
                    %             else
                    %                 accuracy_time = (true_positive_time + true_negative_time)/(true_positive_time + false_positive_time + false_negative_time + true_negative_time)*100;
                    %                 precision_time = true_positive_time/(true_positive_time + false_positive_time) * 100;
                    %                 recall_time = true_positive_time/(true_positive_time + false_negative_time) * 100;
                    %                 accuracy_class_time = true_positive_class_time/size(data_reference_classes_time,1)*100;
                    %             end
                    %
                    %             disp('Values for time (number)')
                    %             disp(['Accuracy = ', num2str(accuracy_time)])
                    %             disp(['Precision = ', num2str(precision_time)])
                    %             disp(['Recall = ', num2str(recall_time)])
                    %             disp(['Classification accuracy = ', num2str(accuracy_class_time)])
                    %             disp('-------------------------------------------------------------')
                    %
                    %             fprintf(fidtimeN, '%s %f %f %f %f \r\n', name, accuracy_time, precision_time, recall_time, accuracy_class_time);
                    %
                    %             accuracy_all_timeN(idxnames) = accuracy_time;
                    %             precision_all_timeN(idxnames) = precision_time;
                    %             recall_all_timeN(idxnames) = recall_time;
                    %             accuracy_class_all_timeN(idxnames) = accuracy_class_time;
                end
                accuracy_all(isnan(accuracy_all)) = 0;
                precision_all(isnan(precision_all)) = 0;
                recall_all(isnan(recall_all)) = 0;
                accuracy_class_all(isnan(accuracy_class_all));
                
                true_positive_all(isnan(true_positive_all)) = 0;
                true_negative_all(isnan(true_negative_all)) = 0;
                false_positive_all(isnan(false_positive_all)) = 0;
                false_negative_all(isnan(false_negative_all)) = 0;
                
                meanaccuracy = mean(accuracy_all);
                meanprecision = mean(precision_all);
                meanrecall = mean(recall_all);
                meanaccuracyclass = mean(accuracy_class_all);
                
                
                meanatrue_positive = mean(true_positive_all);
                meantrue_negative = mean(true_negative_all);
                meanfalse_positive = mean(false_positive_all);
                meanfalse_negative = mean(false_negative_all);
                
                
                fprintf(fid, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                fprintf(fid, '%f %f %f %f \r\n', meanatrue_positive, meantrue_negative, meanfalse_positive, meanfalse_negative);
                fclose(fid);
                
                %         meanaccuracy = mean(accuracy_all_barlines);
                %         meanprecision = mean(precision_all_barlines);
                %         meanrecall = mean(recall_all_barlines);
                %         meanaccuracyclass = mean(accuracy_class_all_barlines);
                %
                %         fprintf(fidbarlines, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                %         fclose(fidbarlines);
                %
                %         meanaccuracy = mean(accuracy_all_timeL);
                %         meanprecision = mean(precision_all_timeL);
                %         meanrecall = mean(recall_all_timeL);
                %         meanaccuracyclass = mean(accuracy_class_all_timeL);
                %
                %         fprintf(fidtimeL, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                %         fclose(fidtimeL);
                %
                %         meanaccuracy = mean(accuracy_all_timeN);
                %         meanprecision = mean(precision_all_timeN);
                %         meanrecall = mean(recall_all_timeN);
                %         meanaccuracyclass = mean(accuracy_class_all_timeN);
                %
                %         fprintf(fidtimeN, '%f %f %f %f \r\n', meanaccuracy, meanprecision, meanrecall, meanaccuracyclass);
                %         fclose(fidtimeN);
        end
end



