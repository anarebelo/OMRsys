function correction_of_symbols_detected
clc
% clear all

%Meter
%Classification of time signature
%The symbols between to consecutive bar lines must be classified to detected errors

%s = struct('ScoreID',i,'Rests',restClass,'TimeSignatures',TimeSignature,'Dots',dotClass,'OpenNoteHeadWithoutStem',setOpenNotehead,...
%        'Accidental',[accidentalClass; accidentalClass1],'Clefs',ClefsClass,'Keys',keySignature,'BarLines',barlines,'Accent',accentClass,'Beams',BeamsClass,...
%        'OpenNoteheadStem',setOpenNoteheadstem,'NoteheadStem',setnoteheadstem);


file='results\otsu';
filestafflines='results\otsu\stafflines';
fileothers='results\otsu\others';
type = 1;
d=dir(file);
d=struct2cell(d);
names=d(1,3:end,:);

dfilesothers=dir(fileothers);
dfilesothers=struct2cell(dfilesothers);
namesfilesothers=dfilesothers(1,3:end,:);

dfilestafflines=dir(filestafflines);
dfilestafflines=struct2cell(dfilestafflines);
namesfilestafflines=dfilestafflines(1,3:end,:);

filestaffinfo_sets = 'results\otsu\staffinfo_sets';
dfilestaffinfo_sets=dir(filestaffinfo_sets);
dfilestaffinfo_sets=struct2cell(dfilestaffinfo_sets);
namesfilestaffinfo_sets=dfilestaffinfo_sets(1,3:end,:);

filename = 'evaluation_results_otsu.txt';
fid = fopen(filename, 'w');

filename = 'evaluation_results_average_otsu.txt';
fid1 = fopen(filename, 'w');

accuracy_1 = [];
precision_1 = [];
recall_1 = [];
for idxnames=1:length(names)
    aux = names{idxnames};
    [name remain]= strtok(aux,'-');
    format = aux(end-3:end);
    
    flag = 0;
    if ( strcmp(format,'.png') == 1 )
        data1 = search_for_mat(name,names,type);
        disp( sprintf('%s <-> %s',names{idxnames},data1));
        
        
        data3 = search_for(name,namesfilestaffinfo_sets,type);
        disp( sprintf('%s <-> %s',names{idxnames},data3));
        
        data3=strcat(filestaffinfo_sets,'\',data3);
        data_staffinfo_sets = dlmread(data3,';');
        data_staffinfo_sets(end) = [];
        numberLines = mode(data_staffinfo_sets);
        numberSpaces = numberLines-1;
        
        file1 = strcat(file,'\', data1);
        
        file1 = load(file1);
        setOfSymbols = file1.setOfSymbols;
        
        [name1 remain1]= strtok(aux,'_');
        typeofdeformation = remain1(2);
        
        
        %Kanungo, white speckles and typeset emulation
        %Use the original image to extract the position of the symbols
        if strcmp(typeofdeformation, 'd') == 1 || strcmp(typeofdeformation, 't') == 1
            for i=1:length(names)
                aux = names{i};
                [name11 remain11]= strtok(aux,'-');
                format11 = aux(end-3:end);
                
                if ( strcmp(format11,'.png') == 1 )
                    if ( strcmp(name1,name11) == 1 )
                        [name111 remain111]= strtok(remain11,'-');
                        if ( strcmp(strcat(name11,'-',name111),strcat(name1,'-nostaff')) == 1 )
                            nameimage1 = strtok(name11, '_');
                            nameimage_original=strcat(nameimage1,remain11);
                            image1=strcat(file,'\', nameimage_original);
                            image = imread(image1);
                            
                            if(size(image,3)>1)
                                image = rgb2gray(image);
                                t=graythresh(image);
                                image=im2bw(image,t);
                            else
                                image=image./255;
                                image=logical(image);
                            end
                            
                            data2=strcat(nameimage1,'-staffLines_vs01.txt');
                            disp( sprintf('%s <-> %s',nameimage_original,data2));
                            
                            if strcmp(data2(end-2:end),'csv')==1
                                data2=strcat(filestafflines,'\',data2);
                                data = dlmread(data2,';');
                            elseif strcmp(data2(end-2:end),'txt')==1
                                data2=strcat(filestafflines,'\',data2);
                                data = dlmread(data2,',');
                            end
                            flag=1;
                            break
                        end
                    end
                end
            end
        elseif strcmp(typeofdeformation, 'w') == 1
            for i=1:length(names)
                aux = names{i};
                [name11 remain11]= strtok(aux,'-');
                format11 = aux(end-3:end);
                
                if ( strcmp(format11,'.png') == 1 )
                    if ( strcmp(name1,name11) == 1 )
                        [name111 remain111]= strtok(remain11,'-');
                        if ( strcmp(strcat(name11,'-',name111),strcat(name1,'-nostaff')) == 1 )
                            nameimage1 = strtok(name11, '_');
                            nameimage_original=strcat(nameimage1,remain11);
                            image1=strcat(file,'\', nameimage_original);
                            image = imread(image1);
                            
                            if(size(image,3)>1)
                                image = rgb2gray(image);
                                t=graythresh(image);
                                image=im2bw(image,t);
                            else
                                image=image./255;
                                image=logical(image);
                            end
                            
                            data2=strcat(nameimage1,'-staffLines_vs01.txt');
                            disp( sprintf('%s <-> %s',nameimage_original,data2));
                            
                            if strcmp(data2(end-2:end),'csv')==1
                                data2=strcat(filestafflines,'\',data2);
                                data = dlmread(data2,';');
                            elseif strcmp(data2(end-2:end),'txt')==1
                                data2=strcat(filestafflines,'\',data2);
                                data = dlmread(data2,',');
                            end
                            flag=1;
                            break
                        end
                    end
                end
            end
        else
            image1=strcat(file,'\', names{idxnames});
            image = imread(image1);
            
            if(size(image,3)>1)
                image = rgb2gray(image);
                t=graythresh(image);
                image=im2bw(image,t);
            else
                image=image./255;
                image=logical(image);
            end
            
            data2 = search_for(name,namesfilestafflines,type);
            disp( sprintf('%s <-> %s',names{idxnames},data2));
            
            if strcmp(data2(end-2:end),'csv')==1
                data2=strcat(filestafflines,'\',data2);
                data = dlmread(data2,';');
            elseif strcmp(data2(end-2:end),'txt')==1
                data2=strcat(filestafflines,'\',data2);
                data = dlmread(data2,',');
            end
        end
        
        symbols                 = cell2mat(setOfSymbols(1));
        StaffInfo               = symbols.StaffInfo;
        
        [musicalScores,initialpositionsFinal] = splitscore(StaffInfo,image,data,data_staffinfo_sets);
        
        image=double(image);
        L = bwlabel(1-image);
        s  = regionprops(L, 'BoundingBox');
        BoundingBox = cat(1, s.BoundingBox);
        BoundingBox=floor(BoundingBox);
        refNotes = [BoundingBox(:,2) BoundingBox(:,2)+BoundingBox(:,4) BoundingBox(:,1) BoundingBox(:,1)+BoundingBox(:,3)];
        [row,col]=find(refNotes == 0);
        refNotes(row,col)=1;
        
        %Sort
        [value idx]=sort(refNotes(:,1));
        refNotes = refNotes(idx,:);
        refNotesTotal=refNotes;
        
        refNotesTotal1 = [];
        %Se tiver mais do que uma imagem de referencia
        if flag == 1
            %Kanungo, white speckles and typeset emulation
            %Use the original image to extract the position of the symbols
            auxnames = nameimage_original;
            aux = auxnames(end-4);
        else
            auxnames = names{idxnames};
            aux = auxnames(end-4);
        end
        if strcmp(num2str(1),aux) == 1
            for idxnamesothers=1:length(namesfilesothers)
                aux = namesfilesothers{idxnamesothers};
                [name2 remain]= strtok(aux,'-');
                
                if strcmp(name,name2) == 1
                    disp( sprintf('%s <-> %s',names{idxnames},namesfilesothers{idxnamesothers}));
                    
                    [name1 remain1]= strtok(aux,'_');
                    typeofdeformation = remain1(2);
                    
                    image1=strcat(fileothers,'\', namesfilesothers{idxnamesothers});
                    image = imread(image1);
                    
                    if(size(image,3)>1)
                        image = rgb2gray(image);
                        t=graythresh(image);
                        image=im2bw(image,t);
                    else
                        image=image./255;
                        image=logical(image);
                    end
                    
                    %                     %Kanungo, white speckles and typeset emulation
                    %                     %Use the original image to extract the position of the symbols
                    %                     if strcmp(typeofdeformation, 'd') == 1 || strcmp(typeofdeformation, 't') == 1
                    %                         nameimage1 = strtok(name, '_');
                    %                         nameimage=strcat(nameimage1,remain);
                    %
                    %                         image1=strcat(fileothers,'\', nameimage);
                    %                         image = imread(image1);
                    %
                    %                         if(size(image,3)>1)
                    %                             image = rgb2gray(image);
                    %                             t=graythresh(image);
                    %                             image=im2bw(image,t);
                    %                         else
                    %                             image=image./255;
                    %                             image=logical(image);
                    %                         end
                    %                     elseif strcmp(typeofdeformation, 'w') == 1
                    %                         nameimage1 = strtok(name, '_');
                    %                         nameimage=strcat(nameimage1,remain)
                    %
                    %                         addas
                    %
                    %                         image1=strcat(fileothers,'\', nameimage);
                    %                         image = imread(image1);
                    %
                    %                         if(size(image,3)>1)
                    %                             image = rgb2gray(image);
                    %                             t=graythresh(image);
                    %                             image=im2bw(image,t);
                    %                         else
                    %                             image=image./255;
                    %                             image=logical(image);
                    %                         end
                    %                     else
                    %                         image1=strcat(fileothers,'\', namesfilesothers{idxnamesothers});
                    %                         image = imread(image1);
                    %
                    %                         if(size(image,3)>1)
                    %                             image = rgb2gray(image);
                    %                             t=graythresh(image);
                    %                             image=im2bw(image,t);
                    %                         else
                    %                             image=image./255;
                    %                             image=logical(image);
                    %                         end
                    %                     end
                    
                    musicalScores = splitscore(StaffInfo,image,data,data_staffinfo_sets);
                    
                    image=double(image);
                    L = bwlabel(1-image);
                    s  = regionprops(L, 'BoundingBox');
                    BoundingBox = cat(1, s.BoundingBox);
                    BoundingBox=floor(BoundingBox);
                    refNotes = [BoundingBox(:,2) BoundingBox(:,2)+BoundingBox(:,4) BoundingBox(:,1) BoundingBox(:,1)+BoundingBox(:,3)];
                    [row,col]=find(refNotes == 0);
                    refNotes(row,col)=1;
                    
                    %Sort
                    [value idx]=sort(refNotes(:,1));
                    refNotes = refNotes(idx,:);
                    refNotesTotal1 = [refNotesTotal1; refNotes];
                    
                else
                    continue
                end
            end
        end
        refNotesTotal = [refNotesTotal; refNotesTotal1];
        
        detNotes = [];
        for i=1:size(setOfSymbols,2)
            score=double(cell2mat(musicalScores(i)));
            
            symbols                 = cell2mat(setOfSymbols(i));
            ScoreID                 = symbols.ScoreID;
            Rests                   = symbols.Rests;
            TimeSignatures          = symbols.TimeSignatures;
            Dots                    = symbols.Dots;
            OpenNoteHeadWithoutStem = symbols.OpenNoteHeadWithoutStem;
            Accidental              = symbols.Accidental;
            if size(Accidental,1)~=0
                Accidental              = [Accidental repmat(0,size(Accidental,1),2)];
            end
            Clefs                   = symbols.Clefs;
            Keys                    = symbols.Keys;
            BarLines                = symbols.BarLines;
            Accent                  = symbols.Accent;
            Beams                   = symbols.Beams;
            if size(Beams,1)~=0
                Beams                   = [Beams repmat(0,size(Beams,1),2)];
            end
            OpenNoteheadstem        = symbols.OpenNoteheadStem.OpenNoteheadstem;
            [notes1, flags1]        = notesflags(OpenNoteheadstem,image);
            noteheadstem            = symbols.NoteheadStem.noteheadstem;
            [notes2, flags2]        = notesflags(noteheadstem,image);
            
            notes = [Rests;TimeSignatures;Dots;Accidental;Clefs;Keys;BarLines;Accent;Beams;OpenNoteHeadWithoutStem;notes1;notes2;flags1;flags2];
            if size(notes,1)~=0
                notes = [notes(:,1:2) + repmat(initialpositionsFinal(i), size(notes,1), 2) notes(:,3:4)];
            end
            
            detNotes = [detNotes;notes];
        end
        
        image_ref = zeros(size(image));
        for j=1:size(refNotesTotal,1)
            image_ref(refNotesTotal(j,1):refNotesTotal(j,2), refNotesTotal(j,3):refNotesTotal(j,4)) = 1;
            
        end
        
%         image_test = zeros(size(image));
%         for j=1:size(detNotes,1)
%             image_test(detNotes(j,1):detNotes(j,2), detNotes(j,3):detNotes(j,4)) = 1;
%             
%         end
%         
%         imwrite(image_ref,'image_ref.png','png')
%         imwrite(image_test, 'image_test.png','png')
       
        
        image_test = zeros(size(image));
        true_positive = 0;
        for i=1:size(detNotes,1)
            img = image(detNotes(i,1):detNotes(i,2), detNotes(i,3):detNotes(i,4));
            size_bb = size(img,1)*size(img,2);
            image_test(detNotes(i,1):detNotes(i,2), detNotes(i,3):detNotes(i,4)) = 1;
            
            img_result = image_ref + image_test;
            if length(find(img_result(:) == 2)) > size_bb*0.75
                true_positive = true_positive+1;
            end
        end
        
        false_negative = size(detNotes,1) - true_positive;
        if size(detNotes,1) - size(refNotesTotal,1) > 0
            false_negative = false_negative +  size(detNotes,1) - size(refNotesTotal,1);
        end
        
        false_positive = size(refNotesTotal,1) - size(detNotes,1);
        if false_positive < 0
            false_positive = 0;
        end
        true_negative = 0;
        
        accuracy = (true_positive + true_negative)/(true_positive + false_positive + false_negative + true_negative)*100;
        precision = true_positive/(true_positive + false_positive) * 100;
        recall = true_positive/(true_positive + false_negative) * 100;  % capacidade de distinguir os objectos, sensibilidade
        %         F_measure = 2*((precision*recall)/(precision+recall))
        
        disp(['Accuracy = ', num2str(accuracy)])
        disp(['Precision = ', num2str(precision)])
        disp(['Recall = ', num2str(recall)])
        
        
        fprintf(fid, '%s %f %f %f \r\n', name, accuracy, precision, recall);
        
        accuracy_1 = [accuracy_1 accuracy];
        precision_1 = [precision_1 precision];
        recall_1 = [recall_1 recall];
    end
end
meanaccuracy = mean(accuracy_1);
meanprecision = mean(precision_1);
meanrecall = mean(recall_1);

fprintf(fid1, '%f %f %f \r\n', meanaccuracy, meanprecision, meanrecall);
fclose(fid);
fclose(fid1);



function [musicalScores,initialpositionsFinal] = splitscore(StaffInfo,imageWithoutLines,data,data_staffinfo_sets)

dataX=data(:,1:2:end);
dataY=data(:,2:2:end);
spaceHeight = StaffInfo(1);
numberLines = mode(data_staffinfo_sets);
numberSpaces = numberLines-1;
        
tolerance = spaceHeight*numberSpaces;
count1=1;
numbersetprevious=0;
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
    
    a = valueYI - round((valueYI-newValueY+1)./2);
    b = valueYF+tolerance;
    
    img = ones(size(imageWithoutLines));
    for j=1:length(valueYI)
        img(a(j):b(j),valueX(j))=imageWithoutLines(a(j):b(j),valueX(j));
    end
    img = img(min(a):max(b),valueX(1):valueX(end));
    
    musicalScores=[musicalScores img];
    initialpositionsFinal = [initialpositionsFinal; min(a) valueX(1)];
    
%     filename=sprintf('symbol%d.png',r);
%     filename=strcat('lixo\',filename);
%     imwrite(img, filename,'png')
%     r=r+1;
    
    numbersetprevious = numbersetprevious+numberset;
    count1=1+numbersetprevious;
end






