function extractSymbols
%connectcomponents new version
%image1     -> nome da imagem
%data1      -> ficheiro com as posições das linhas detectadas pelo stablepath

% rmpath(genpath('F:\Programas\MATLAB\R2007b\toolbox\images\'))
% addpath(genpath('images\'))

clc
file='DB\imgs';
typeFiles = 1;
d=dir(file);
d=struct2cell(d);
names=d(1,3:end,:);

filestaffinfo = 'DB\staffinfo';
dfilestaffinfo=dir(filestaffinfo);
dfilestaffinfo=struct2cell(dfilestaffinfo);
namesfilestaffinfo=dfilestaffinfo(1,3:end,:);

filestaffinfo_sets = 'DB\staffinfo_sets';
dfilestaffinfo_sets=dir(filestaffinfo_sets);
dfilestaffinfo_sets=struct2cell(dfilestaffinfo_sets);
namesfilestaffinfo_sets=dfilestaffinfo_sets(1,3:end,:);


if isdir('results') == 1
    rmdir('results','s')
    mkdir('results')
else
    mkdir('results')
end
if isdir('results_imgs') == 1
    rmdir('results_imgs','s')
    mkdir('results_imgs')
else
    mkdir('results_imgs')
end

for idxnames=1:length(names)
    aux = names{idxnames};
    name = aux(1:end-4);
    format = aux(end-3:end);
    
    if ( strcmp(format,'.png') == 1 )
        data1 = search_for(name,names,typeFiles);
        disp( sprintf('%s <-> %s',names{idxnames},data1));
        
        data2 = search_for(name,namesfilestaffinfo,typeFiles);
        disp( sprintf('%s <-> %s',names{idxnames},data2));
        
        data3 = search_for(name,namesfilestaffinfo_sets,typeFiles);
        disp( sprintf('%s <-> %s',names{idxnames},data3));
        
        close all
        clear functions
        clear imageWithoutLines
        clear visitedMatrix
        clear visitedMatrixObjects
        
        
        global imageWithoutLines
        global visitedMatrix
        global visitedMatrixObjects
        
        image1=strcat(file,'\', name,'.png');
        image = imread(image1);
        
        if(size(image,3)>1)
            %Otsu
            image = rgb2gray(image);
            t=graythresh(image);
            image=im2bw(image,t);
        else
            %Otsu or BLIST
            image=image./255;
            image=logical(image);
        end        
        
        %Read matrix models
        [models, vectorParametersRests, vectorParameters] = read_models();
        
        if strcmp(data1(end-2:end),'csv')==1
            data1=strcat(file,'\',data1);
            data = dlmread(data1,';');
        elseif strcmp(data1(end-2:end),'txt')==1
            data1=strcat(file,'\',data1);
            data = dlmread(data1,',');
        end
        
        if size(data,1) == 0 
            clc
            continue
        end

        time = cputime;
%         [spaceHeight, lineHeight]= getStaffInfo(image); 
        data2=strcat(filestaffinfo,'\',data2);
        data_staffinfo = dlmread(data2,';');
        spaceHeight = data_staffinfo(2);
        lineHeight = data_staffinfo(1);
        disp(['spaceHeight ', num2str(spaceHeight)])
        disp(['lineHeight ', num2str(lineHeight)])
        processing_time = cputime-time;
        disp(['00000. Get staff info: ', num2str(processing_time), ' secs'])
        
       
        time = cputime;
        data3=strcat(filestaffinfo_sets,'\',data3);
        data_staffinfo_sets = dlmread(data3,';');
        data_staffinfo_sets(end) = [];
        numberLines = mode(data_staffinfo_sets);
        numberSpaces = numberLines-1;
        disp(['numberLines ', num2str(numberLines)])
        disp(['numberSpaces ', num2str(numberSpaces)])
        processing_time = cputime-time;
        disp(['0000. Organize lines in sets: ', num2str(processing_time),' secs'])

        %---x
        %|
        %|
        %y        
        dataX=data(:,1:2:end);
        dataY=data(:,2:2:end);
        
        
        %%%%%%%%%%%%%%%%%%%%%% Remove lines %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        time = cputime;
        if lineHeight~=1
            threshold=2*lineHeight;
        else
            threshold=4;
        end
        tolerance=1+ceil(lineHeight/3);
        [h]=size(image,1);
        [imageWithoutLines]=removeLine(threshold,tolerance,dataY,dataX,image,h);
        processing_time = cputime-time;
        disp(['000. Remove lines: ', num2str(processing_time), ' secs'])
        

        %%%%%%%%%%%%%%%%%%%%%%%% Split score in sets %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        time = cputime;
        [musicalScores,initialpositions,~,toleranceStaff] = splitscoreinsets(data_staffinfo_sets,dataY,dataX,imageWithoutLines,spaceHeight,numberSpaces);
        
        processing_time = cputime-time;
        disp(['00. Split score in sets: ', num2str(processing_time), ' secs'])

        
        %%%%Thresholds
        minStem                     = 2*spaceHeight-lineHeight;
        MaxdistancesBetweenElements = round(spaceHeight/2);
        maxWidthClave               = 4*spaceHeight;
        heigthKeySignatures         = numberLines*lineHeight+(numberLines-1)*spaceHeight;
        val_blackpixels             = 1;
        val_NoteHeads1              = 2*lineHeight;
        val_NoteHeads2              = round(spaceHeight*0.70);
        val_NoteHeads3              = 2*spaceHeight;
        val_WidthHeightDiag         = 0.60;    
        val_verifyNoteHeadStem1     = spaceHeight;
        val_verifyNoteHeadStem2     = 8;
        val_sideFlag                = 6;
        minWidthClave               = spaceHeight+lineHeight;
        val_findAccidentals1        = 2*spaceHeight;
        val_findAccidentals2        = round(spaceHeight*0.85); 
        val_findAccidentals3        = 4*spaceHeight; 
        val_findAccidentals4        = 3*spaceHeight;
        val_opennotehead            = 0.8;
        val_whitepixels             = 0.7;   
        
        %setnoteheadstem -> notes, stem, 1-with beams/0-without beams, flags
        %stem -> initial row, end row, column, 1-up/0-down
        %setopennoteheadstem -> notehead stem [] []
        r=1;
        count = 1;
        symbolBeams = [];
        BeamsClass=[];
        accidentalClass=[];
        nameimag=names{idxnames};   
        filename_result = strcat('results\', nameimag(1:end-4),'-setOfSymbols.mat');
        %filename_result_second = strcat('results\', nameimag(1:end-4),'-setOfSymbols_second.mat');
        setOfSymbols = {};
        degree = struct();
        number = [];
        %musicalScores = musicalScores(1);  %<--------------------------
        
        orderID = 1;
        setOfSymbols = main(musicalScores,spaceHeight,lineHeight,dataY,dataX,numberLines,initialpositions,data_staffinfo_sets,count,r,symbolBeams,...
    BeamsClass,accidentalClass,setOfSymbols,degree,models,minStem,MaxdistancesBetweenElements,maxWidthClave,heigthKeySignatures,vectorParametersRests,...
    toleranceStaff,numberSpaces,vectorParameters,orderID, number, val_blackpixels,val_NoteHeads1,val_NoteHeads2,val_NoteHeads3,val_WidthHeightDiag,...
    val_verifyNoteHeadStem1,val_verifyNoteHeadStem2,val_sideFlag,minWidthClave,val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,...
    val_findAccidentals4,val_opennotehead,val_whitepixels);
        
        setOfSymbols
        
%         disp('Changing parameters.........................................')
%         minStem                 = [spaceHeight+lineHeight spaceHeight];
%         val_NoteHeads2          = [round(spaceHeight*0.30) round(spaceHeight*0.20)];
%         val_WidthHeightDiag     = 0.30;
%         val_verifyNoteHeadStem1 = lineHeight;
%         val_verifyNoteHeadStem2 = spaceHeight;
%         maxWidthClave           = 5*spaceHeight;
%         minWidthClave           = 2*lineHeight;
%         val_findAccidentals1    = 2*spaceHeight-2*lineHeight;
%         val_findAccidentals2    = round(spaceHeight*0.75); 
%         val_findAccidentals3    = 4*spaceHeight; 
%         val_opennotehead        = 0.6;
%         val_whitepixels         = 0.5;
%         
%         possibilities = combvec(1:2,1:2);
%         
%         orderID = 2;
%         symbols = cell2mat(setOfSymbols);
%         setOfSymbols_Second = {};
%         for j = 1:size(symbols,2)
%             imgWithoutSymbols = symbols(j).img_final;    
%             imgWithoutSymbols = {imgWithoutSymbols};
%             setOfSymbols1 = {};
%             
%             for k=1:size(possibilities,2)  
%                 disp('-------------------------------------- New parameters ----------------------------------------')
%                 setOfSymbols1 = main(imgWithoutSymbols,spaceHeight,lineHeight,dataY,dataX,numberLines,initialpositions,data_staffinfo_sets,count,r,symbolBeams,BeamsClass,accidentalClass,...
%                     setOfSymbols1,degree,models,minStem(possibilities(1,k)),MaxdistancesBetweenElements,maxWidthClave,heigthKeySignatures,vectorParametersRests,...
%                     toleranceStaff,numberSpaces,vectorParameters, orderID, k, ...
%                     val_blackpixels,val_NoteHeads1,val_NoteHeads2(possibilities(2,k)),val_NoteHeads3,val_WidthHeightDiag,val_verifyNoteHeadStem1,...
%                     val_verifyNoteHeadStem2, val_sideFlag,minWidthClave,val_findAccidentals1,val_findAccidentals2,...
%                     val_findAccidentals3,val_findAccidentals4,val_opennotehead,val_whitepixels);             
%             end
%             nbsymbols = zeros(1,size(setOfSymbols1,2));
%             for k = 1:size(setOfSymbols1,2)
%                 symbols1 = cell2mat(setOfSymbols1(k));
%                 nbsymbols(k) = symbols1.numberofsymbols;
%             end
%             [~,id] = max(nbsymbols); 
%             setOfSymbols_Second = [setOfSymbols_Second cell2mat(setOfSymbols1(id))];
%             
            
%             file_staff='symbols_detected_secondary';
%             d_staff=dir(file_staff);
%             d_staff=struct2cell(d_staff);
%             names_staff=d_staff(1,3:end,:);
%             
%             oldname = strcat(file_staff,'\',names_staff(id));
%             oldname = char(oldname);
%             newname = strcat(file_staff,'\',sprintf('staff%d',j));
%             movefile(oldname,newname)
%             
%             aux_id = 1:4;
%             aux_id(id) = [];
%             rmdir(char(strcat(file_staff,'\',names_staff(aux_id(1)))),'s')
%             rmdir(char(strcat(file_staff,'\',names_staff(aux_id(2)))),'s')
%             rmdir(char(strcat(file_staff,'\',names_staff(aux_id(3)))),'s')
            
            %symbols = cell2mat(setOfSymbols_Second(1));
            %imgWithoutSymbols1 = symbols.img_final;
            %imwrite(imgWithoutSymbols1,'imgWithoutSymbols1.png','png')        
%         end
        
%         setOfSymbols_Second
%         filename_result
        
        save(filename_result, 'setOfSymbols')  
%         save(filename_result_second, 'setOfSymbols_Second')  

%         movefile('symbols_detected_secondary','..\..\results_imgs')
%         movefile('..\..\results_imgs\symbols_detected_secondary',char(strcat('results_imgs\',nameimag(1:end-4),'-second')))
        
        movefile('symbols_detected','results_imgs')
        movefile('results_imgs\symbols_detected',char(strcat('results_imgs\',nameimag(1:end-4),'-first')))   
    end
end
   
return

