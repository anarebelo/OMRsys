function setOfSymbols =  firstmain(musicalScores,spaceHeight,lineHeight,dataY,dataX,numberLines,initialpositions,data_staffinfo_sets,count,r,symbolBeams,...
    BeamsClass,accidentalClass,setOfSymbols,degree,models,minStem,MaxdistancesBetweenElements,maxWidthClave,heigthKeySignatures,vectorParametersRests,...
    toleranceStaff,numberSpaces,vectorParameters,orderID, val_blackpixels,val_NoteHeads1,val_NoteHeads2,val_NoteHeads3,val_WidthHeightDiag,...
    val_verifyNoteHeadStem1,val_verifyNoteHeadStem2,val_sideFlag,minWidthClave,val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,...
    val_findAccidentals4,val_opennotehead,val_whitepixels)



disp('--------------------------------------------------------------------------')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Segmentation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=3:size(musicalScores,2)
    disp(['Staff number ', num2str(i)])
    noteHeadRejected = [];
    
    score=cell2mat(musicalScores(i));
    scoreTOdebug=score;
    scorewithoutsymbolsdetected = score;

    %Remove the brace
    brace = 0;
    vect = cumsum(data_staffinfo_sets);
    if i == 1
        vect1=1;
    else
        vect1 = vect(i-1)+1;
    end
    dataY1 = dataY(vect1:min(vect1+(numberLines-1),size(dataY,1)),:);
    tam = dataY1(1,1)-initialpositions(i);
    [~,positioncolumn] = find(score(tam,:) == 0,1);

    img1 = score(:,max(1,positioncolumn-spaceHeight):positioncolumn+spaceHeight);
    [~, stem]=removeSTEM(img1,2*spaceHeight); 
    
    b = zeros(1,size(stem,2));
    for j=1:size(stem,2)
       a = cell2mat(stem(j));
       b(j) = a(end);
    end

    aux = diff(b);
    aux_p = b(find(aux~=1));
    if size(aux_p,2) == 1
        if aux_p > round(spaceHeight/2)
            if length(aux(1:find(aux~=1)-1)) > round(spaceHeight/3)
                if max(1,positioncolumn-spaceHeight) == 1
                    positionstoremove = b;
                else  
                    positionstoremove = b(1:find(aux~=1)-1)+positioncolumn-spaceHeight;
                end
                score(:,positionstoremove) = 1;
                brace = 1;
            end
        end
    elseif size(aux_p,2) == 0
        if length(aux) > round(spaceHeight/4)
            if max(1,positioncolumn-spaceHeight) == 1
                positionstoremove = b;
            else
                positionstoremove = b+positioncolumn-spaceHeight-1;
            end
            score(:,positionstoremove) = 1;
            brace = 1;
        elseif length(aux) ~= 0 
            %Remove letters or numbers before clefs
            if max(1,positioncolumn-spaceHeight) == 1
                positionstoremove = b;
            else
                positionstoremove = b+positioncolumn-spaceHeight-1;
            end
            score(:,1:positionstoremove(1)-lineHeight) = 1;
        end
    end

    [ClefsClass,keySignature,TimeSignature,scoreWithoutClefsKeySignature,count,degree,scorewithoutsymbolsdetected,scoreWithoutClefs] = submain(score,spaceHeight,lineHeight,dataY,dataX,numberLines,i,...
        initialpositions,data_staffinfo_sets,scoreTOdebug,models,count,degree,heigthKeySignatures,scorewithoutsymbolsdetected,i,brace);
    
    score_detect_barlines= scoreWithoutClefsKeySignature;
    
    %%IV. Stem detection
    time = cputime;
    [imgWithoutStem, stem]=removeSTEM(scoreWithoutClefsKeySignature,minStem);
    
    
    %%Remove black pixels around stems (for skew symbols)
    [imgWithoutStem]=removeBlackPixelsStems(imgWithoutStem,stem,val_blackpixels);
    processing_time = cputime-time;
    disp(['4. Stem detection: ', num2str(processing_time), ' secs'])
    
    
    %%V. Noteheads detection steps
    time = cputime;
    [noteheadsObject]=findNoteHeads(imgWithoutStem,val_NoteHeads1, val_NoteHeads2,val_NoteHeads3);
    %Noteheads rejected because its width and height
    [noteHead,noteHeadRejected]=WidthHeightDiag(noteheadsObject,val_WidthHeightDiag);
    
    
    %Noteheads rejected because its have white pixels in the middle
    [NewnoteHead, Stem, noteHeadRejected1, setnoteheadstem]=noteHeadStem(val_verifyNoteHeadStem1,val_verifyNoteHeadStem2,stem,noteHead,score,0,val_sideFlag,orderID);
    noteHeadRejected = [noteHeadRejected; noteHeadRejected1];
    imgWithoutNoteHeads=delObjects(imgWithoutStem,NewnoteHead,0);
    scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,NewnoteHead,0);
    
    processing_time = cputime-time;
    disp(['5. Noteheads detection steps: ', num2str(processing_time), ' secs'])
    
    %If exist noteheads
    if size(NewnoteHead,2)~=0
        %I. Clefs detection - > erro na detec��o, afinar parametros
        if size(ClefsClass,1)==0
            time = cputime;
            [clefs] = findClefsSymbols(score,dataY,dataX,i,initialpositions,spaceHeight,lineHeight,numberLines,vectorParameters,data_staffinfo_sets);
            ClefsClass = clefs;
            
            %Save Clefs Symbols
            if size(ClefsClass,1)~=0
                if i == 1
                    FILE = assign_name_file('clefs_rule',0);
                else
                    FILE = assign_name_file('clefs_rule',1);
                end
                count = saveSymbols(ClefsClass, 'clefs', count, score,FILE);
                degree = setfield(degree, 'clef', confidence_degree(ClefsClass,models,scoreTOdebug,'clefs',1));
                %Remove clefs
                imgWithoutNoteHeads=delObjects(imgWithoutNoteHeads,ClefsClass,0);
                scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,ClefsClass,0);
                score_detect_barlines = delObjects(score_detect_barlines,ClefsClass,0);
            end
            
            %II. Key Signature detection
            if size(ClefsClass,1)~=0
                [keySignature] = findKeySignaturesSymbols(imgWithoutNoteHeads,dataY,dataX,i,initialpositions,spaceHeight,lineHeight,numberLines,ClefsClass,data_staffinfo_sets);
            end
            
            %Save Key Signature Symbols
            %Este s�mbolo pode existir depois de cada barra m�trica. Mais tarde fazer procura novamente
            if size(keySignature,1)~=0
                if i == 1
                    FILE = assign_name_file('keySignature_rule',0);
                else
                    FILE = assign_name_file('keySignature_rule',1);
                end
                count = saveSymbols(keySignature, 'keySignature', count, scoreWithoutClefs,FILE);
                degree = setfield(degree, 'keySignature', confidence_degree(keySignature,models,scoreTOdebug,'keySignature',1));
                %Remove clefs
                imgWithoutNoteHeads=delObjects(imgWithoutNoteHeads,keySignature,0);
                scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,keySignature,0);
                score_detect_barlines = delObjects(score_detect_barlines,keySignature,0);
            end
            
            
            %III. Time Signature detection
            if size(ClefsClass,1)~=0
                if size(keySignature,1)~=0
                    [TimeSignature] = findTimeSignaturesSymbols(imgWithoutNoteHeads,dataY,dataX,i,initialpositions,spaceHeight,lineHeight,numberLines,keySignature,data_staffinfo_sets);
                else
                    [TimeSignature] = findTimeSignaturesSymbols(imgWithoutNoteHeads,dataY,dataX,i,initialpositions,spaceHeight,lineHeight,numberLines,ClefsClass,data_staffinfo_sets);
                end
            end
            
            %Save Time Signature Symbols
            if size(TimeSignature,1)~=0
                for j=1:size(TimeSignature,1)
                    TS = TimeSignature(j,:);
                    if TS(end) > heigthKeySignatures
                        if i==1
                            FILE = assign_name_file('TimeSignatureN_rule',0);
                        else
                            FILE = assign_name_file('TimeSignatureN_rule',1);
                        end
                        count = saveSymbols(TS, 'TimeSignatureN', count, scoreWithoutClefsKeySignature,FILE);
                        [dataUp dataDown]= timeSignatureNumberClassification1(score,TimeSignature);
                        TS = [dataUp; dataDown];
                        degree = setfield(degree, 'TimeSignatureN', confidence_degree(TS,models,scoreTOdebug,'TimeSignatureN',1)); % Graus para cada s�mbolo
                    else
                        if i == 1
                            FILE = assign_name_file('TimeSignatureL_rule',0);
                        else
                            FILE = assign_name_file('TimeSignatureL_rule',1);
                        end
                        count = saveSymbols(TS, 'TimeSignatureL', count, scoreWithoutClefsKeySignature,FILE);
                        degree = setfield(degree, 'TimeSignatureL', confidence_degree(TS,models,scoreTOdebug,'TimeSignatureL',1));
                    end
                end
                %Remove time signature
                imgWithoutNoteHeads=delObjects(imgWithoutNoteHeads,TimeSignature,0);
                scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,TimeSignature,0);
                score_detect_barlines = delObjects(score_detect_barlines,TimeSignature,0);
            end
            processing_time = cputime-time;
            disp(['Changing parameters: ', num2str(processing_time), ' secs'])
        end
        
        %Delete noteHeadRejected in the position of the clef, key and time
        %signature.
        if size(ClefsClass,1)~=0
            noteHeadRejected = deleteNotesHeadRejected(noteHeadRejected,ClefsClass,spaceHeight);
            if size(keySignature,1)~=0
                noteHeadRejected = deleteNotesHeadRejected(noteHeadRejected,keySignature,spaceHeight);
            end
            if size(TimeSignature,1)~=0
                noteHeadRejected = deleteNotesHeadRejected(noteHeadRejected,TimeSignature,spaceHeight);
            end
        end
        
        
        %Delete noteheads with height and width 80% below of the height and
        %width mean of the all noteheads
        meanheightnotehead = round(mean(NewnoteHead(:,5)));
        meanwidthnotehead = round(mean(NewnoteHead(:,6)));
        
        idx = find( NewnoteHead(:,5) < meanheightnotehead*0.8 & NewnoteHead(:,6) < meanwidthnotehead*0.8);
        setnoteheadstem.noteheadstem(idx,:) = [];
        
        %VI. Beams detection steps
        time = cputime;
        [symbol]=findBeams(imgWithoutNoteHeads,lineHeight,spaceHeight);
        
        if size(symbol,2)~=0
            %Chose those that have a width bigger than minWidthClave and a height lower than maxWidthClave
            symbol1=symbol(find(symbol(:,5)>=minWidthClave & symbol(:,6)<=maxWidthClave),:);
            %newSymbol11=newSymbol1(find(newSymbol1(:,5)>minStem),:);
            symbolBeams=findBars(symbol1,MaxdistancesBetweenElements);
        end
        
        if size(symbolBeams,1) ~= 0
            %Verify if the noteheads have beams associated
            [BeamsBetweenTwoNoteHeads, beamsWithOneNotehead, BeamWithoutNotehead,setnoteheadstem]=stemsBeams(setnoteheadstem, symbolBeams, spaceHeight,lineHeight);
            BeamsClass = BeamsBetweenTwoNoteHeads;
            
            
            if size(noteHeadRejected,1)~=0
                %Remove the beams detected from the noteheads rejected
                for j = 1: size(BeamsClass,1)
                    id = find(noteHeadRejected(:,1) == BeamsClass(j,1) & noteHeadRejected(:,2) == BeamsClass(j,2) & noteHeadRejected(:,3) == BeamsClass(j,3) & noteHeadRejected(:,4) == BeamsClass(j,4));
                    noteHeadRejected(id,:) = [];
                end
                for j = 1: size(beamsWithOneNotehead,1)
                    id = find(noteHeadRejected(:,1) == beamsWithOneNotehead(j,1) & noteHeadRejected(:,2) == beamsWithOneNotehead(j,2) & noteHeadRejected(:,3) == beamsWithOneNotehead(j,3) & noteHeadRejected(:,4) == beamsWithOneNotehead(j,4));
                    noteHeadRejected(id,:) = [];
                end
                for j = 1: size(BeamWithoutNotehead,1)
                    id = find(noteHeadRejected(:,1) == BeamWithoutNotehead(j,1) & noteHeadRejected(:,2) == BeamWithoutNotehead(j,2) & noteHeadRejected(:,3) == BeamWithoutNotehead(j,3) & noteHeadRejected(:,4) == BeamWithoutNotehead(j,4));
                    noteHeadRejected(id,:) = [];
                end
                
                %Add stems to the noteHeads that were removed
                [noteHeadAccepted1, stemAccepted, noteHeadRejected1, setnoteheadstem1]=noteHeadStem(val_verifyNoteHeadStem1,val_verifyNoteHeadStem2,stem,noteHeadRejected,score,1,val_sideFlag,orderID);
                
                
                %Find noteheads for the beams detected with only one or without noteheads
                [BeamsBetweenTwoNoteHeads, noteHeadAccepted, setnoteheadstem1]=noteHeadsBeams(setnoteheadstem1,setnoteheadstem,BeamWithoutNotehead,beamsWithOneNotehead,spaceHeight,lineHeight);
                
                if size(noteHeadAccepted,1)~=0
                    %Noteheads rejected - > noteheads without beams and without width and height appropriated
                    %Remove repeated symbols
                    aa = setnoteheadstem1.noteheadstem(noteHeadAccepted,:);
                    noteHeadAccepted_aux = cell2mat(aa(:,1));
                    for j = 1: size(noteHeadAccepted_aux,1)
                        id = find(noteHeadAccepted1(:,1) == noteHeadAccepted_aux(j,1) & noteHeadAccepted1(:,2) == noteHeadAccepted_aux(j,2) & noteHeadAccepted1(:,3) == noteHeadAccepted_aux(j,3) & noteHeadAccepted1(:,4) == noteHeadAccepted_aux(j,4));
                        if length(id) > 1
                            noteHeadAccepted1(id(2:end),:) = [];
                        end
                    end
                    
                    if size(noteHeadAccepted,1)~=0
                        BeamsClass = [BeamsClass; BeamsBetweenTwoNoteHeads];
                        setnoteheadstem = setfield(setnoteheadstem, 'noteheadstem', [setnoteheadstem.noteheadstem; setnoteheadstem1.noteheadstem(noteHeadAccepted,:)]);
                    end
                    
                    %Remove repeated symbols
                    BeamsClassCopy = BeamsClass;
                    
                    %Remove the beams detected from the noteheads rejected
                    for j = 1: size(BeamsClassCopy,1)
                        id = find(BeamsClass(:,1) == BeamsClassCopy(j,1) & BeamsClass(:,2) == BeamsClassCopy(j,2) & BeamsClass(:,3) == BeamsClassCopy(j,3) & BeamsClass(:,4) == BeamsClassCopy(j,4));
                        if length(id) > 1
                            BeamsClass(id(2:end),:) = [];
                        end
                    end
                end
            end
        end
        processing_time = cputime-time;
        disp(['6. Beams detection steps: ', num2str(processing_time), ' secs'])
        
        %Save Beams Symbols
        if size(BeamsClass,1)~=0
            if i == 1
                FILE = assign_name_file('beams_rule',0);
            else
                FILE = assign_name_file('beams_rule',1);
            end
            count = saveSymbols(BeamsClass, 'beams', count, score,FILE);
            degree = setfield(degree, 'beams', confidence_degree(BeamsClass,models,scoreTOdebug,'beams',1));
            %Remove beams
            scoreWithoutBeams=delObjects(scoreWithoutClefsKeySignature,BeamsClass,0);
            scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,BeamsClass,0);
            score_detect_barlines = delObjects(score_detect_barlines,BeamsClass,0);
        else
            scoreWithoutBeams = scoreWithoutClefsKeySignature;
        end

        %Remove noteheads and stems
        if size(setnoteheadstem,2)~=0
            imgWithoutBeamsNoteHeadsStems=delObjects(scoreWithoutBeams,setnoteheadstem,1);
            scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,setnoteheadstem,1);
            score_detect_barlines = delObjects(score_detect_barlines,setnoteheadstem,1);
        else
            imgWithoutBeamsNoteHeadsStems = scoreWithoutBeams;
        end
        
        %IXa. Accidentals detection steps
        time = cputime;
        %Before a notehead and at same height
        accidentalClass = [];
        if size(setnoteheadstem.noteheadstem,1)~=0
            for j=1:size(setnoteheadstem.noteheadstem,1)
                A = cell2mat(setnoteheadstem.noteheadstem(j,1));
                
                a = max(1,A(1)-spaceHeight);
                b = min(A(2)+spaceHeight,size(score,1));
                c = max(1,A(3)-(2*spaceHeight+2*lineHeight));
                d = min(A(4)-spaceHeight,size(score,2));
                
                
                [accidentalSymbol]=findAccidentals(imgWithoutBeamsNoteHeadsStems(a:b,c:d),val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,val_findAccidentals4);
                
                if size(accidentalSymbol,1)~=0
                    accidentalSymbol = [max(1,accidentalSymbol(1,1)+a) min(accidentalSymbol(1,2)+a,size(score,1)) max(1,accidentalSymbol(1,3)+c) min(size(score,2),accidentalSymbol(1,4)+c)];
                    accidentalClass =[accidentalClass; accidentalSymbol];
                end
            end
            
        end
        %Save Accidentals Symbols
        if size(accidentalClass,1)~=0
            if i == 1
                FILE = assign_name_file('accidentals_rule',0);
            else
                FILE = assign_name_file('accidentals_rule',1);
            end
            count = saveSymbols(accidentalClass, 'accidentals', count, score,FILE);
            degree = setfield(degree, 'accidentals', confidence_degree(accidentalClass,models,scoreTOdebug,'accidentals',1));
            %Remove accidentals
            imgWithoutBeamsNoteHeadsStems=delObjects(imgWithoutBeamsNoteHeadsStems,accidentalClass,0);
            scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,accidentalClass,0);
            score_detect_barlines = delObjects(score_detect_barlines,accidentalClass,0);
        end
        
        processing_time = cputime-time;
        disp(['9a. Accidentals detection steps: ', num2str(processing_time), ' secs'])
        
        %VII. Flag detection steps
        time = cputime;
        %After each notehead and notehead without beams
        for j=1:size(setnoteheadstem.noteheadstem,1)
            A = cell2mat(setnoteheadstem.noteheadstem(j,2));
            B = cell2mat(setnoteheadstem.noteheadstem(j,1));
            C = cell2mat(setnoteheadstem.noteheadstem(j,3));
            
            sizestem=A(2)-A(1);
            widthnote=B(end);
            
            if size(C,1)==0
                aux = [abs(A(1)-B(1)) abs(A(2)-B(2))];
                [vl idx] = max(aux);
                
                %Stem down
                if A(1) >= B(1) && A(1) <= B(2) && aux(1) < aux(2)
                    if sizestem > widthnote
                        a = max(1,B(2)-lineHeight);
                        b = min(A(2)+lineHeight,size(score,1));
                    else
                        %nao tem flag
                        continue
                    end
                elseif A(1) >= B(2) && A(2) > B(1) && idx == 2 || A(1) < B(1) && A(2) > B(2) && aux(1) < aux(2)
                    a = max(1,B(2)-lineHeight);
                    b = min(A(2)+lineHeight,size(score,1));
                    %Stem up
                elseif A(2) >= B(1) && A(2) <= B(2) && aux(2) < aux(1)
                    if sizestem > widthnote
                        a = max(1,A(1)-lineHeight);
                        b = min(B(1)+lineHeight,size(score,1));
                    else
                        %nao tem flag
                        continue
                    end
                elseif A(2) <= B(1) && A(1) < B(2) && idx == 1 || A(2) > B(2) && A(1) < B(1) && aux(2) < aux(1)
                    a = max(1,A(1)-lineHeight);
                    b = min(B(1)+lineHeight,size(score,1));
                end
                
                c = max(1,A(3));
                d = min(A(3)+(spaceHeight+2*lineHeight),size(score,2));
                
                
                [flagSymbol]=findFlags(imgWithoutBeamsNoteHeadsStems(a:b,c:d),spaceHeight,lineHeight);
                
                if size(flagSymbol,1)~=0
                    flagSymbol = [max(1,flagSymbol(1,1)+a-1) min(size(score,1),flagSymbol(1,2)+a-1) max(1,flagSymbol(1,3)+c-1) min(size(score,2),flagSymbol(1,4)+c-1) flagSymbol(1,5) flagSymbol(1,6)];
                    if flagSymbol(1) < B(1) &&  flagSymbol(2) > B(2)
                        continue;
                    else
                        setnoteheadstem.noteheadstem(j,4) = {flagSymbol};
                    end
                end
            end
        end
        processing_time = cputime-time;
        disp(['7. Flag detection steps: ', num2str(processing_time), ' secs'])
        
        %Save noteheads symbols
        if size(setnoteheadstem,2)~=0
            if i == 1
                FILE = assign_name_file('noteheads_rule',0);
            else
                FILE = assign_name_file('noteheads_rule',1);
            end
            count = saveSymbols(setnoteheadstem, 'noteheads', count, scoreWithoutBeams,FILE);
            symbolsNH = [];
            for j=1:size(setnoteheadstem.noteheadstem,1)
                nH = cell2mat(setnoteheadstem.noteheadstem(j,1));
                st = cell2mat(setnoteheadstem.noteheadstem(j,2));
                flag_nh = cell2mat(setnoteheadstem.noteheadstem(j,4));
                
                k = st(:,1:2);
                if size(k,1)>1
                    k = k(:)';
                end
                if size(flag_nh,1) ==0
                    v = [nH(1:2) k];
                    v = sort(v);
                    symbol=[v(1) v(end) nH(3) nH(4) (nH(4)-nH(3)+1) (v(end)-v(1)+1)];
                else
                    v = [nH(1:2) k];
                    v = sort(v);
                    vv = [nH(3:4) flag_nh(3:4)];
                    vv = sort(vv);
                    symbol=[v(1) v(end) vv(1) vv(end) (vv(end)-vv(1)+1) (v(end)-v(1)+1)];
                end
                
                a = max(symbol(3)-5,1);
                b = min(symbol(4)+5,size(score,2));
                symbolsNH = [symbolsNH; symbol(1) symbol(2) a b];
            end
            degree = setfield(degree, 'noteheads', confidence_degree(symbolsNH,models,scoreTOdebug,'notes',1));
            
            %Remove flags
            imgWithoutBeamsNoteHeadsStemsFlags=delObjects(imgWithoutBeamsNoteHeadsStems,setnoteheadstem,2);
            scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,setnoteheadstem,2);
            score_detect_barlines = delObjects(score_detect_barlines,setnoteheadstem,2);
        else
            imgWithoutBeamsNoteHeadsStemsFlags = imgWithoutBeamsNoteHeadsStems;
        end
    else
        imgWithoutBeamsNoteHeadsStemsFlags = imgWithoutNoteHeads;
    end
    %     imgforfinddots=imgWithoutBeamsNoteHeadsStemsFlags;
    
    %Open noteheads detection steps
    time = cputime;
    %VIIIa. Open noteheads with stems -> Minim
    %Remove noteheads stems from stems
    setOpenNoteheadstem = struct();
    setOpenNoteheadstem = setfield(setOpenNoteheadstem, 'OpenNoteheadstem', [{}]);
    
    if size(setnoteheadstem.noteheadstem,1)~=0
        nH = cell2mat(setnoteheadstem.noteheadstem(:,1));
        st = cell2mat(setnoteheadstem.noteheadstem(:,2));
        threshold = max(nH(:,5));
        st_new = [];
        
        for k=1:size(st,1)
            %stem at right of the notehead
            if st(k,4) == 1
                st_new = [st_new; st(k,1) st(k,2) st(k,3)-threshold:st(k,3) st(k,4)];
            else
                st_new = [st_new; st(k,1) st(k,2) st(k,3):st(k,3)+threshold st(k,4)];
            end
        end
    else
        %         imgWithoutBeamsNoteHeadsStemsFlags = score;
        st_new=[];
    end
    
    aux_stem_col = [];
    for j=1:size(stem,2)
        A = cell2mat(stem(j));
        aux_stem_col = [aux_stem_col; A(end)];
    end
    
    if size(aux_stem_col,1)~=0
        [aux_stem_col,~] = sort(aux_stem_col(:,end));
    end
    
    countidx = [];
    flag = 0;
    idx = [];
    for jj=1:size(aux_stem_col,1)-1
        aux = aux_stem_col(jj+1,1) - aux_stem_col(jj,1);
        if aux == 1
            idx = [idx jj];
            flag = 1;
        else
            if flag == 1
                countidx = [countidx idx(1)];
            end
            idx = [];
            flag = 0;
        end
        if jj == size(aux_stem_col,1)-1
            aux = aux_stem_col(size(aux_stem_col,1),1) - aux_stem_col(jj,1) ;
            if aux == 1
                if flag == 1
                    idx = [idx size(aux_stem_col,1)];
                    countidx = [countidx idx(1)];
                else
                    countidx = [countidx idx(1)];
                end
            else
                if flag == 1
                    countidx = [countidx idx(1)];
                end
            end
        end
    end
    stem = stem(countidx);
    
    for j=1:size(stem,2)
        A = cell2mat(stem(j));
        col = A(end);
        aux=repmat(col,size(st_new,1),size(st_new,2)-3);
        [row1 col1]=find(aux == st_new(:,3:end-1));
        
        %Do not coincide with any noteheads column
        if size(row1,1)==0 || size(row1,2)==0
            for k=1:2:size(A,2)-1
                row=[A(k) A(k+1)];
                [setOpenNoteheadstem]=findOpenNoteHeads(imgWithoutBeamsNoteHeadsStemsFlags,setOpenNoteheadstem,lineHeight,spaceHeight,row,col,val_WidthHeightDiag);
            end
        else
            %Verify the rows the noteheads
            row2 = [st_new(row1,1)-lineHeight:st_new(row1,1)  st_new(row1,2):st_new(row1,2)+lineHeight];
            row2_1 = row2(1):row2(end);
            for k=1:2:size(A,2)-1
                row=[A(k) A(k+1)];
                if size(find(row(1) == row2_1),1)==0
                    %The row does not coincide with noteheads rows
                    if size(find(row(2) == row2_1),1)==0
                        [setOpenNoteheadstem]=findOpenNoteHeads(imgWithoutBeamsNoteHeadsStemsFlags,setOpenNoteheadstem,lineHeight,spaceHeight,row,col,val_WidthHeightDiag);
                    end
                end
            end
        end
    end
    %     A = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(:,1));
    %     A = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(:,2));
    
    
    %     %Remove open noteheads with close columns
    %     if size(setOpenNoteheadstem.OpenNoteheadstem,1)~=0
    %         auxind = [];
    %         A = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(:,2));
    %         for k=1:size(A,1)-1
    %             %Close columns (colunas pr�ximas)
    %             if abs(A(k,3)-A(k+1,3)) < lineHeight
    %                 row  = A(k,1):A(k,2);
    %                 row1 = [A(k+1,1) A(k+1,2)];
    %                 %Closed rows
    %                 if size(find(row1(1) == row),1)~=0
    %                     auxind = [auxind k];
    %                 elseif size(find(row1(2) == row),1)~=0
    %                     auxind = [auxind k];
    %                 end
    %             end
    %             if k == size(A,1)-1
    %                 %Close columns
    %                 if abs(A(k,3)-A(size(A,1),3)) < lineHeight
    %                     row  = A(k,1):A(k,2);
    %                     row1 = [A(size(A,1),1) A(size(A,1),2)];
    %                     %Close rows
    %                     if size(find(row1(1) == row),1)~=0
    %                         auxind = [auxind k];
    %                     elseif size(find(row1(2) == row),1)~=0
    %                         auxind = [auxind k];
    %                     end
    %                 end
    %             end
    %         end
    %         setOpenNoteheadstem.OpenNoteheadstem(auxind,:)=[];
    %     end
    %     A = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(:,1))
    
    
    openNoteHeadStem_aux = [];
    for j=1:size(setOpenNoteheadstem.OpenNoteheadstem,1)
        openNoteHeadStem_aux = [openNoteHeadStem_aux cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,1))];
    end
    
    if size(setOpenNoteheadstem.OpenNoteheadstem,1)~=0
        %Delete noteheads with height and width 80% below of the height and
        %width mean of the all noteheads
        meanheightnotehead = round(mean(openNoteHeadStem_aux(:,5)));
        meanwidthnotehead = round(mean(openNoteHeadStem_aux(:,6)));
        
        idx = find( openNoteHeadStem_aux(:,5) < val_opennotehead*meanheightnotehead  & openNoteHeadStem_aux(:,6) < val_opennotehead*meanwidthnotehead);
        setOpenNoteheadstem.OpenNoteheadstem(idx,:) = [];
    end
    
    processing_time = cputime-time;
    disp(['8a. Open noteheads with stems detection steps: ', num2str(processing_time), ' secs'])
    
    %Remove open noteheads and stems
    if size(setOpenNoteheadstem,2)~=0
        if i == 1
            FILE = assign_name_file('openNoteheads_rule',0);
        else
            FILE = assign_name_file('openNoteheads_rule',1);
        end
        count = saveSymbols(setOpenNoteheadstem, 'openNoteheads', count, score,FILE);
        symbolsNH = [];
        for j=1:size(setOpenNoteheadstem.OpenNoteheadstem,1)
            nH = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,1));
            st = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,2));
            flag_nh = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,4));
            
            k = st(:,1:2);
            if size(k,1)>1
                k = k(:)';
            end
            if size(flag_nh,1) ==0
                v = [nH(1:2) k];
                v = sort(v);
                symbol=[v(1) v(end) nH(3) nH(4) (nH(4)-nH(3)+1) (v(end)-v(1)+1)];
            else
                v = [nH(1:2) k];
                v = sort(v);
                vv = [nH(3:4) flag_nh(3:4)];
                vv = sort(vv);
                symbol=[v(1) v(end) vv(1) vv(end) (vv(end)-vv(1)+1) (v(end)-v(1)+1)];
            end
            a = max(symbol(3)-5,1);
            b = min(symbol(4)+5,size(score,2));
            
            symbolsNH= [symbolsNH; symbol(1) symbol(2) a b];
        end
        degree = setfield(degree, 'opennoteheads', confidence_degree(symbolsNH,models,scoreTOdebug,'opennotes',1));
        imgWithoutBeamsOpenNoteHeadsStemsFlags=delObjects(imgWithoutBeamsNoteHeadsStemsFlags,setOpenNoteheadstem,3);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,setOpenNoteheadstem,3);
        score_detect_barlines = delObjects(score_detect_barlines,setOpenNoteheadstem,3);
    else
        imgWithoutBeamsOpenNoteHeadsStemsFlags = imgWithoutBeamsNoteHeadsStemsFlags;
    end
    
    %VIIIb. Open noteheads without stems -> semibreve, breve
    %Search between stafflines and over them
    time = cputime;
    numberOfstaff = i;
    [setOpenNotehead]=findOpenNoteHeadsI(imgWithoutBeamsOpenNoteHeadsStemsFlags,lineHeight,spaceHeight,dataY,dataX,...
        initialpositions,numberLines,numberOfstaff,data_staffinfo_sets,val_whitepixels);
    processing_time = cputime-time;
    disp(['8b. Open noteheads without stems detection steps: ', num2str(processing_time), ' secs'])
    
    %Remove open noteheads and stems
    if size(setOpenNotehead,1)~=0
        if i == 1
            FILE = assign_name_file('semibreve_breve_rule',0);
        else
            FILE = assign_name_file('semibreve_breve_rule',1);
        end
        count = saveSymbols(setOpenNotehead, 'openNoteheadsI', count, score,FILE);
        degree = setfield(degree, 'semibreve_breve', confidence_degree(setOpenNotehead,models,scoreTOdebug,'semibreve_breve',1));
        imgWithoutBeamsOpenNoteHeadsStemsFlagsI=delObjects(imgWithoutBeamsOpenNoteHeadsStemsFlags,setOpenNotehead,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,setOpenNotehead,0);
        score_detect_barlines = delObjects(score_detect_barlines,setOpenNotehead,0);
    else
        imgWithoutBeamsOpenNoteHeadsStemsFlagsI = imgWithoutBeamsOpenNoteHeadsStemsFlags;
    end
    imgforfinddots=imgWithoutBeamsOpenNoteHeadsStemsFlagsI;
    
    
    %IXb. Accidentals detection steps
    %Before a notehead and at same height
    %Minimas
    accidentalClass1 = [];
    if size(setOpenNoteheadstem.OpenNoteheadstem,1)~=0
        for j=1:size(setOpenNoteheadstem.OpenNoteheadstem,1)
            A = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,1));
            
            a = max(1,A(1)-spaceHeight);
            b = min(A(2)+spaceHeight,size(score,1));
            c = max(1,A(3)-(2*spaceHeight+2*lineHeight));
            d = min(A(4)-spaceHeight,size(score,2));
            
            [accidentalSymbol]=findAccidentals(imgWithoutBeamsOpenNoteHeadsStemsFlagsI(a:b,c:d),val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,val_findAccidentals4);
            
            if size(accidentalSymbol,1)~=0
                accidentalSymbol = [max(1,accidentalSymbol(1,1)+a) min(size(score,1),accidentalSymbol(1,2)+a) max(1,accidentalSymbol(1,3)+c) min(size(score,2),accidentalSymbol(1,4)+c)];
                accidentalClass1 =[accidentalClass1; accidentalSymbol];
            end
        end
    end
    
    %Save Accidentals Symbols
    if size(accidentalClass1,1)~=0
        
        if size(accidentalClass,1)~=0
            FILE = assign_name_file('accidentals_rule',1);
            count = saveSymbols(accidentalClass1, 'accidentals', count, score,FILE);
            degree.accidentals = [degree.accidentals; confidence_degree(accidentalClass1,models,scoreTOdebug,'accidentals',1)];
        else
            if i == 1
                FILE = assign_name_file('accidentals_rule',0);
            else
                FILE = assign_name_file('accidentals_rule',1);
            end
            count = saveSymbols(accidentalClass1, 'accidentals', count, score,FILE);
            degree = setfield(degree, 'accidentals', confidence_degree(accidentalClass1,models,scoreTOdebug,'accidentals',1));
        end
        %Remove accidentals
        imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals1=delObjects(imgWithoutBeamsOpenNoteHeadsStemsFlagsI,accidentalClass1,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,accidentalClass1,0);
        score_detect_barlines = delObjects(score_detect_barlines,accidentalClass1,0);
    else
        imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals1 = imgWithoutBeamsOpenNoteHeadsStemsFlagsI;
    end
    
    
    %IXc. Accidentals detection steps
    %Before a notehead and at same height
    %Breves&semibreves
    accidentalClass2 = [];
    if size(setOpenNotehead,1)~=0
        for j=1:size(setOpenNotehead,1)
            A = setOpenNotehead(j,:);
            
            a = max(1,A(1)-spaceHeight);
            b = min(A(2)+spaceHeight,size(score,1));
            c = max(1,A(3)-(2*spaceHeight+2*lineHeight));
            d = min(A(4)-spaceHeight,size(score,2));
            
            [accidentalSymbol]=findAccidentals(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals1(a:b,c:d),val_findAccidentals1,val_findAccidentals2,val_findAccidentals3,val_findAccidentals4);
            
            if size(accidentalSymbol,1)~=0
                accidentalSymbol = [max(1,accidentalSymbol(1,1)+a) min(size(score,1),accidentalSymbol(1,2)+a) max(1,accidentalSymbol(1,3)+c) min(size(score,2),accidentalSymbol(1,4)+c)];
                accidentalClass2 =[accidentalClass2; accidentalSymbol];
            end
        end
    end
    %Save Accidentals Symbols
    if size(accidentalClass2,1)~=0
        if size(accidentalClass,1)~=0
            FILE = assign_name_file('accidentals_rule',1);
            count = saveSymbols(accidentalClass2, 'accidentals', count, score,FILE);
            degree.accidentals = [degree.accidentals; confidence_degree(accidentalClass2,models,scoreTOdebug,'accidentals',1)];
        else
            if i == 1
                FILE = assign_name_file('accidentals_rule',0);
            else
                FILE = assign_name_file('accidentals_rule',1);
            end
            count = saveSymbols(accidentalClass2, 'accidentals', count, score,FILE);
            degree = setfield(degree, 'accidentals', confidence_degree(accidentalClass2,models,scoreTOdebug,'accidentals',1));
        end
        %Remove accidentals
        imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals2=delObjects(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals1,accidentalClass2,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,accidentalClass2,0);
        score_detect_barlines = delObjects(score_detect_barlines,accidentalClass2,0);
    else
        imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals2 = imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals1;
    end
    
    accidentalClass = [accidentalClass; accidentalClass1; accidentalClass2];
    
    processing_time = cputime-time;
    disp(['9b. Accidentals detection steps: ', num2str(processing_time), ' secs'])
    
    
    %X. Dots detection steps
    %To the right of the notehead, always placed in the center of a space
    %Noteheads with flags: in the space above and beyond the tail of the flag
    %Noteheads placed on lines (including ledger lines): in the space above
    %One notehead on a line and another notehead in a space: if the lower
    %of the two notes is on a line, its dot must go in the space beneath it.
    %Dots: noteheads with/without flags and beams, rests, minim,
    %breve and semibreve
    time = cputime;
    %Notas fechadas
    dotClass = [];
    idxJ = [];
    staffNotesHeadwithFlags = [];
    staffNotesHead = [];
    for j=1:size(setnoteheadstem.noteheadstem,1)
        notehead = cell2mat(setnoteheadstem.noteheadstem(j,1));
        flag = cell2mat(setnoteheadstem.noteheadstem(j,4));
        
        %Without flags
        if size(flag,1)==0
            %Find position on the staff
            staffNotesHead = findnotepositionstaff(notehead, imgforfinddots, lineHeight, spaceHeight, dataX, dataY, numberLines, i,initialpositions,data_staffinfo_sets,val_NoteHeads1, val_NoteHeads2,val_NoteHeads3);
        else
            %Find position on the staff
            staffNotesHeadwithFlags = findnotepositionstaff(notehead, imgforfinddots, lineHeight, spaceHeight, dataX, dataY, numberLines, i,initialpositions,data_staffinfo_sets,val_NoteHeads1, val_NoteHeads2,val_NoteHeads3);
        end
        
        
        if size(staffNotesHeadwithFlags,1)==0 && size(staffNotesHead,1)==0
            idxJ = [idxJ j];
            continue;
        end
        
        %noteheads with flags
        if size(staffNotesHeadwithFlags,1)~=0
            % On staffline
            if mod(staffNotesHeadwithFlags(2),2)==0;
                a = max(1,notehead(1)-spaceHeight);
                b = min(notehead(2),size(score,1));
                c = max(1,flag(4)-lineHeight);
                d = min(flag(4)+spaceHeight,size(score,2));
                
                img = imgforfinddots(a:b,c:d);
                [dotSymbol]=finddots(img,spaceHeight,lineHeight);
                if size(dotSymbol,1)~=0
                    %simbolos perto da fronteira
                    if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                        staffNotesHeadwithFlags = [];
                        staffNotesHead = [];
                        continue;
                    else
                        dotSymbol = [max(1,dotSymbol(1,1)+a) min(size(score,1),dotSymbol(1,2)+a) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                        dotClass = [dotClass; dotSymbol noteheadsymbol(setnoteheadstem.noteheadstem(j,:),score)];
                    end
                end
            else
                % On space
                a = max(1,notehead(1));
                b = min(notehead(2),size(score,1));
                c = max(1,notehead(4));
                d = min(notehead(4)+2*spaceHeight,size(score,2));
                img = imgforfinddots(a:b,c:d);
                
                [dotSymbol]=finddots(img,spaceHeight,lineHeight);
                if size(dotSymbol,1)~=0
                    if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                        staffNotesHeadwithFlags = [];
                        staffNotesHead = [];
                        continue;
                    else
                        dotSymbol = [max(1,dotSymbol(1,1)+a) min(size(score,1),dotSymbol(1,2)+a) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                        dotClass = [dotClass; dotSymbol noteheadsymbol(setnoteheadstem.noteheadstem(j,:),score)];
                    end
                end
            end
        end
        
        %noteheads without flags
        if size(staffNotesHead,1)~=0
            % On staffline
            if mod(staffNotesHead(2),2)==0;
                a = max(1,notehead(1)-spaceHeight);
                b = min(notehead(2),size(score,1));
                c = max(1,notehead(4));
                d = min(round(notehead(4)+spaceHeight+0.5*spaceHeight),size(score,2));
                
                img = imgforfinddots(a:b,c:d);
                [dotSymbol]=finddots(img,spaceHeight,lineHeight);
                
                if size(dotSymbol,1)~=0
                    %simbolos perto da fronteira
                    if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                        staffNotesHeadwithFlags = [];
                        staffNotesHead = [];
                        continue;
                    else
                        dotSymbol = [max(1,dotSymbol(1,1)+a) min(size(score,1),dotSymbol(1,2)+a) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                        dotClass = [dotClass; dotSymbol noteheadsymbol(setnoteheadstem.noteheadstem(j,:),score)];
                    end
                end
            else
                % On space
                a = max(1,notehead(1));
                b = min(notehead(2),size(score,1));
                c = max(1,notehead(4));
                d = min(round(notehead(4)+spaceHeight+0.5*spaceHeight),size(score,2));
                img = imgforfinddots(a:b,c:d);
                
                [dotSymbol]=finddots(img,spaceHeight,lineHeight);
                if size(dotSymbol,1)~=0
                    if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                        staffNotesHeadwithFlags = [];
                        staffNotesHead = [];
                        continue;
                    else
                        dotSymbol = [max(1,dotSymbol(1,1)+a) min(size(score,1),dotSymbol(1,2)+a) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                        dotClass = [dotClass; dotSymbol noteheadsymbol(setnoteheadstem.noteheadstem(j,:),score)];
                    end
                end
            end
        end
        staffNotesHeadwithFlags = [];
        staffNotesHead = [];
    end
    
    %Remove the noteheads without position on the staff
    %setnoteheadstem.noteheadstem(idxJ,:)=[];
    
    %Minim
    idxJ = [];
    for j=1:size(setOpenNoteheadstem.OpenNoteheadstem,1)
        notehead = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,1));
        
        
        %Find position on the staff
        staffNotesHead = findnotepositionstaff(notehead, imgforfinddots, lineHeight, spaceHeight, dataX, dataY, numberLines, i,initialpositions,data_staffinfo_sets,val_NoteHeads1, val_NoteHeads2,val_NoteHeads3);
        if size(staffNotesHead,1)==0
            idxJ = [idxJ j];
        else
            % On staffline
            if mod(staffNotesHead(2),2)==0;
                a = max(1,notehead(1)-spaceHeight);
                b = min(notehead(2),size(score,1));
                c = max(1,notehead(4));
                d = min(round(notehead(4)+spaceHeight+0.5*spaceHeight),size(score,2));
                
                img = imgforfinddots(a:b,c:d);
                [dotSymbol]=finddots(img,spaceHeight,lineHeight);
                
                if size(dotSymbol,1)~=0
                    %simbolos perto da fronteira
                    if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                        continue;
                    else
                        dotSymbol = [max(1,dotSymbol(1,1)+a) min(size(score,1),dotSymbol(1,2)+a) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                        dotClass = [dotClass; dotSymbol noteheadsymbol(setOpenNoteheadstem.OpenNoteheadstem(j,:),score)];
                    end
                end
            else
                % On space
                a = max(1,notehead(1));
                b = min(notehead(2),size(score,1));
                c = max(1,notehead(4));
                d = min(round(notehead(4)+spaceHeight+0.5*spaceHeight),size(score,2));
                img = imgforfinddots(a:b,c:d);
                [dotSymbol]=finddots(img,spaceHeight,lineHeight);
                
                if size(dotSymbol,1)~=0
                    if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                        continue;
                    else
                        dotSymbol = [max(1,dotSymbol(1,1)+a) min(size(score,1),dotSymbol(1,2)+a) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                        dotClass = [dotClass; dotSymbol noteheadsymbol(setOpenNoteheadstem.OpenNoteheadstem(j,:),score)];
                    end
                end
            end
        end
    end
    %Remove the noteheads without position on the staff
    %setOpenNoteheadstem.OpenNoteheadstem(idxJ,:)=[];
    
    %breves&semibreves
    if size(setOpenNotehead,1)~=0
        for j=1:size(setOpenNotehead,1)
            notehead = setOpenNotehead(j,:);
            
            %Find position on the staff
            staffNotesHead = findnotepositionstaff(notehead, imgforfinddots, lineHeight, spaceHeight, dataX, dataY, numberLines, i,initialpositions,data_staffinfo_sets,val_NoteHeads1, val_NoteHeads2,val_NoteHeads3);
            
            if size(staffNotesHead,1)==0
                idxJ = [idxJ j];
            else
                % On staffline
                if mod(staffNotesHead(2),2)==0;
                    a = max(1,notehead(1)-spaceHeight);
                    b = min(notehead(2),size(score,1));
                    c = max(1,notehead(4));
                    d = min(round(notehead(4)+spaceHeight+0.5*spaceHeight),size(score,2));
                    
                    img = imgforfinddots(a:b,c:d);
                    [dotSymbol]=finddots(img,spaceHeight,lineHeight);
                    
                    if size(dotSymbol,1)~=0
                        %simbolos perto da fronteira
                        if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                            continue;
                        else
                            dotSymbol = [max(1,dotSymbol(1,1)+a) min(size(score,1),dotSymbol(1,2)+a) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                            dotClass = [dotClass; dotSymbol notehead(:,1:4)];
                        end
                    end
                else
                    % On space
                    a = max(1,notehead(1));
                    b = min(notehead(2),size(score,1));
                    c = max(1,notehead(4));
                    d = min(round(notehead(4)+spaceHeight+0.5*spaceHeight),size(score,2));
                    img = imgforfinddots(a:b,c:d);
                    
                    [dotSymbol]=finddots(img,spaceHeight,lineHeight);
                    if size(dotSymbol,1)~=0
                        if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                            continue;
                        else
                            dotSymbol = [max(1,dotSymbol(1,1)+a) min(size(score,1),dotSymbol(1,2)+a) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                            dotClass = [dotClass; dotSymbol notehead(:,1:4)];
                        end
                    end
                end
            end
        end
    end
    
    processing_time = cputime-time;
    disp(['10a. Dots detection steps: ', num2str(processing_time), ' secs'])
    %Remove and save dots
    if size(dotClass,1)~=0
        if i == 1
            FILE = assign_name_file('dots_rule',0);
        else
            FILE = assign_name_file('dots_rule',1);
        end
        count = saveSymbols(dotClass, 'dots', count, score,FILE);
        degree = setfield(degree, 'dots', confidence_degree(dotClass,models,scoreTOdebug,'dots',1));
        imgWithoutDotsBeamsOpenNoteHeadsStemsFlagsAccidentals=delObjects(imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals2,dotClass,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,dotClass,0);
        score_detect_barlines = delObjects(score_detect_barlines,dotClass,0);
    else
        imgWithoutDotsBeamsOpenNoteHeadsStemsFlagsAccidentals = imgWithoutBeamsOpenNoteHeadsStemsFlagsAccidentals2;
    end
    
    %XI. Find Accents
    time = cputime;
    %Accents exists above beams
    %Accents exists bellow and above noteheads
    accentClass = [];
    %closed noteheads
    accentClass = findaccentsonsymbols(accentClass,setnoteheadstem,imgforfinddots,spaceHeight,lineHeight,1);
    %minim
    accentClass = findaccentsonsymbols(accentClass,setOpenNoteheadstem,imgforfinddots,spaceHeight,lineHeight,1);
    %breves&semibreves
    accentClass = findaccentsonsymbols(accentClass,setOpenNotehead,imgforfinddots,spaceHeight,lineHeight,0);
    if size(accentClass,1)~=0
        accentClass = removeerroraccent(accentClass,spaceHeight);
    end
    
    processing_time = cputime-time;
    disp(['11. Accent detection steps: ', num2str(processing_time), ' secs'])
    %Remove and save accents
    if size(accentClass,1)~=0
        if i == 1
            FILE = assign_name_file('accents_rule',0);
        else
            FILE = assign_name_file('accents_rule',1);
        end
        count = saveSymbols(accentClass, 'accents', count, imgforfinddots,FILE);
        degree = setfield(degree, 'accents', confidence_degree(accentClass,models,scoreTOdebug,'accents',1));
        imgWithoutAccentsDotsBeamsNotesStemsFlagsAccidentals=delObjects(imgWithoutDotsBeamsOpenNoteHeadsStemsFlagsAccidentals,accentClass,0);
        score_detect_barlines = delObjects(score_detect_barlines,accentClass,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,accentClass,0);
    else
        imgWithoutAccentsDotsBeamsNotesStemsFlagsAccidentals = imgWithoutDotsBeamsOpenNoteHeadsStemsFlagsAccidentals;
    end
    
    img_close = imclose(imgWithoutAccentsDotsBeamsNotesStemsFlagsAccidentals,strel('square',2));

    %XIIa. Rests detection steps
    time = cputime;
    restClass = findSymbolRestsBackup(img_close,lineHeight,spaceHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff,vectorParametersRests,data_staffinfo_sets);
    processing_time = cputime-time;
    disp(['12a. Rests detection steps: ', num2str(processing_time), ' secs'])

    %Remove and save rests
    if size(restClass,1)~=0
        if i == 1
            FILE = assign_name_file('rests_rule',0);
        else
            FILE = assign_name_file('rests_rule',1);
        end
        count = saveSymbols(restClass, 'rests', count, img_close,FILE);
        degree = setfield(degree, 'rests', confidence_degree(restClass,models,scoreTOdebug,'rests',1));
        imgWithoutSymbols=delObjects(imgWithoutAccentsDotsBeamsNotesStemsFlagsAccidentals,restClass,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,restClass,0);
        score_detect_barlines = delObjects(score_detect_barlines,restClass,0);
    else
        imgWithoutSymbols = imgWithoutAccentsDotsBeamsNotesStemsFlagsAccidentals;
    end
    %             degree
    %             a = degree.rests
    %             for j=1:size(a,1)
    %                 cell2mat(degree.rests(j,2))
    %             end
    %            sadsdasda
    
    
    %XIII. bar lines detection steps
    time = cputime;
    barlines = findBarlines(imgWithoutSymbols,spaceHeight,lineHeight,dataY,dataX,initialpositions,numberLines,i,toleranceStaff(i),0.40,data_staffinfo_sets);
    processing_time = cputime-time;
    disp(['13. Barlines detection steps: ', num2str(processing_time), ' secs'])
    
    %Afinar parametros
    if size(barlines,1)==0
        barlines = findBarlines(imgWithoutSymbols,spaceHeight,lineHeight,dataY,dataX,initialpositions,numberLines,i,toleranceStaff(i),0.70,data_staffinfo_sets);
    end
    
    %Afinar parametros
    if size(barlines,1)==0
        %Remove symbols
        barlines = findBarlines(score_detect_barlines,spaceHeight,lineHeight,dataY,dataX,initialpositions,numberLines,i,toleranceStaff(i),0.40,data_staffinfo_sets);
    end
    
    %Remove and save barlines
    if size(barlines,1)~=0
        if i == 1
            FILE = assign_name_file('barlines_rule',0);
        else
            FILE = assign_name_file('barlines_rule',1);
        end
        count = saveSymbols(barlines, 'barlines', count, imgWithoutSymbols,FILE);
        degree = setfield(degree, 'barlines', confidence_degree(barlines,models,scoreTOdebug,'barlines',1));
        imgWithoutSymbols=delObjects(imgWithoutSymbols,barlines,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,barlines,0);
    end
    
    %XIIb. Rests detection steps
    time = cputime;
    %Whole Rest - line number 4
    [type, restClassIIW] = findSymbolRestsII(imgWithoutSymbols,lineHeight,spaceHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff,2,0,data_staffinfo_sets);
    %Remove and save rests
    if size(restClassIIW,1)~=0
        if i == 1
            FILE = assign_name_file('wholerests_rule',0);
        else
            FILE = assign_name_file('wholerests_rule',1);
        end
        count = saveSymbols(restClassIIW, 'wholerests', count, imgWithoutSymbols,FILE);
        degree = setfield(degree, 'wholerests', confidence_degree(restClassIIW,models,scoreTOdebug,'whole',1));
        imgWithoutSymbols=delObjects(imgWithoutSymbols,restClassIIW,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,restClassIIW,0);
    end
    
    
    %Half Rest - line number 3
    [type, restClassIIH] = findSymbolRestsII(imgWithoutSymbols,lineHeight,spaceHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff,3,0,data_staffinfo_sets);
    %Remove and save rests
    if size(restClassIIH,1)~=0
        if i == 1
            FILE = assign_name_file('halfrests_rule',0);
        else
            FILE = assign_name_file('halfrests_rule',1);
        end
        count = saveSymbols(restClassIIH, 'halfrests', count, imgWithoutSymbols,FILE);
        degree = setfield(degree, 'halfrests', confidence_degree(restClassIIH,models,scoreTOdebug,'half',1));
        imgWithoutSymbols=delObjects(imgWithoutSymbols,restClassIIH,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,restClassIIH,0);
    end
    
    %Whole and half rest - lines number 1 and 5
    [type, restClassIIWH] = findSymbolRestsII(imgWithoutSymbols,lineHeight,spaceHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff,1,1,data_staffinfo_sets);
    
    %Remove and save rests
    k=1;
    if size(restClassIIWH,1)~=0
        for j=1:2:size(restClassIIWH,1)
            restII = restClassIIWH(j:j+1,:);
            if type(k) == 0
                restClassIIW =[restClassIIW; restII];
                if i ==1
                    FILE = assign_name_file('wholerests1_rule',0);
                else
                    FILE = assign_name_file('wholerests1_rule',1);
                end
                count = saveSymbols(restII, 'wholerests', count, imgWithoutSymbols,FILE);
                degree.wholerests = [degree.wholerests; confidence_degree(restClassIIW,models,scoreTOdebug,'whole',1)];
                imgWithoutSymbols=delObjects(imgWithoutSymbols,restII,0);
                scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,restII,0);
            else
                restClassIIH =[restClassIIH; restII];
                if i == 1
                    FILE = assign_name_file('halfrests1_rule',0);
                else
                    FILE = assign_name_file('halfrests1_rule',1);
                end
                count = saveSymbols(restII, 'halfrests', count, imgWithoutSymbols,FILE);
                degree.halfrests = [degree.halfrests; confidence_degree(restClassIIH,models,scoreTOdebug,'half',1)];
                imgWithoutSymbols=delObjects(imgWithoutSymbols,restII,0);
                scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,restII,0);
            end
            k=k+1;
        end
    end
    
    %Double Whole Rest - line number 4
    [type, restClassIIWa] = findSymbolRestsII(imgWithoutSymbols,lineHeight,spaceHeight,dataY,dataX,initialpositions,numberLines,numberOfstaff,2,2,data_staffinfo_sets);
    %Remove and save rests
    if size(restClassIIWa,1)~=0
        if i == 1
            FILE = assign_name_file('doublewholerests_rule',0);
        else
            FILE = assign_name_file('doublewholerests_rule',1);
        end
        count = saveSymbols(restClassIIWa, 'doublewholerests', count, imgWithoutSymbols,FILE);
        degree = setfield(degree, 'doublewholerests', confidence_degree(restClassIIWa,models,scoreTOdebug,'doublewhole',1));
        imgWithoutSymbols=delObjects(imgWithoutSymbols,restClassIIWa,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,restClassIIWa,0);
    end
    
    processing_time = cputime-time;
    disp(['12b. Rests detection steps: ', num2str(processing_time), ' secs'])
    
    %Dots steps
    time = cputime;
    dotClass1 = [];
    if size(restClass,1) ~= 0
        for j=1:size(restClass,1)
            c = max(1,restClass(j,4));
            d = min(round(restClass(j,4)+spaceHeight+0.5*spaceHeight),size(score,2));
            img = imgforfinddots(restClass(j,1):restClass(j,2),c:d);
            [dotSymbol]=finddots(img,spaceHeight,lineHeight);
            if size(dotSymbol,1)~=0
                %simbolos perto da fronteira
                if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                    continue;
                else
                    dotSymbol = [max(1,dotSymbol(1,1)+restClass(j,1)) min(size(score,1),dotSymbol(1,2)+restClass(j,1)) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                    dotClass1 = [dotClass1; dotSymbol restClass(j,1:4)];
                end
            end
        end
    end
    if size(restClassIIW,1) ~= 0
        for j=1:size(restClassIIW,1)
            c = max(1,restClassIIW(j,4));
            d = min(round(restClassIIW(j,4)+spaceHeight+0.5*spaceHeight),size(score,2));
            img = imgforfinddots(restClassIIW(j,1):restClassIIW(j,2),c:d);
            [dotSymbol]=finddots(img,spaceHeight,lineHeight);
            if size(dotSymbol,1)~=0
                %simbolos perto da fronteira
                if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                    continue;
                else
                    dotSymbol = [max(1,dotSymbol(1,1)+restClassIIW(j,1)) min(size(score,1),dotSymbol(1,2)+restClassIIW(j,1)) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                    dotClass1 = [dotClass1; dotSymbol restClassIIW(j,1:4)];
                end
            end
        end
    end
    if size(restClassIIH,1) ~= 0
        for j=1:size(restClassIIH,1)
            c = max(1,restClassIIH(j,4));
            d = min(round(restClassIIH(j,4)+spaceHeight+0.5*spaceHeight),size(score,2));
            img = imgforfinddots(restClassIIH(j,1):restClassIIH(j,2),c:d);
            [dotSymbol]=finddots(img,spaceHeight,lineHeight);
            if size(dotSymbol,1)~=0
                %simbolos perto da fronteira
                if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                    continue;
                else
                    dotSymbol = [max(1,dotSymbol(1,1)+restClassIIH(j,1)) min(size(score,1),dotSymbol(1,2)+restClassIIH(j,1)) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                    dotClass1 = [dotClass1; dotSymbol restClassIIH(j,1:4)];
                end
            end
        end
    end
    if size(restClassIIWH,1) ~= 0
        for j=1:size(restClassIIWH,1)
            c = max(1,restClassIIWH(j,4));
            d = min(round(restClassIIWH(j,4)+spaceHeight+0.5*spaceHeight),size(score,2));
            img = imgforfinddots(restClassIIWH(j,1):restClassIIWH(j,2),c:d);
            [dotSymbol]=finddots(img,spaceHeight,lineHeight);
            if size(dotSymbol,1)~=0
                %simbolos perto da fronteira
                if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                    continue;
                else
                    dotSymbol = [max(1,dotSymbol(1,1)+restClassIIWH(j,1)) min(size(score,1),dotSymbol(1,2)+restClassIIWH(j,1)) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                    dotClass1 = [dotClass1; dotSymbol restClassIIWH(j,1:4)];
                end
            end
        end
    end
    if size(restClassIIWa,1) ~= 0
        for j=1:size(restClassIIWa,1)
            c = max(1,restClassIIWa(j,4));
            d = min(round(restClassIIWa(j,4)+spaceHeight+0.5*spaceHeight),size(score,2));
            img = imgforfinddots(restClassIIWa(j,1):restClassIIWa(j,2),c:d);

            [dotSymbol]=finddots(img,spaceHeight,lineHeight);
            if size(dotSymbol,1)~=0
                %simbolos perto da fronteira
                if dotSymbol(1) == 1 || dotSymbol(2) == size(img,1) || dotSymbol(3) == 1 || dotSymbol(4) == size(img,2)
                    continue;
                else      
                    dotSymbol = [max(1,dotSymbol(1,1)+restClassIIWa(j,1)) min(size(score,1),dotSymbol(1,2)+restClassIIWa(j,1)) max(1,dotSymbol(1,3)+c) min(size(score,2),dotSymbol(1,4)+c) dotSymbol(1,5) dotSymbol(1,6)];
                    dotClass1 = [dotClass1; dotSymbol restClassIIWa(j,1:4)];
                end
            end
        end
    end

    %Remove and save dots
    if size(dotClass1,1)~=0
        if size(dotClass,1) ~= 0
            FILE = assign_name_file('doublewholerests_rule',1);
            count = saveSymbols(dotClass1, 'dots', count, score,FILE);
            degree.dots = [degree.dots; confidence_degree(dotClass1,models,scoreTOdebug,'dots',1)];
        else
            if i == 1
                FILE = assign_name_file('doublewholerests_rule',0);
            else
                FILE = assign_name_file('doublewholerests_rule',1);
            end
            count = saveSymbols(dotClass1, 'dots', count, score,FILE);
            degree = setfield(degree, 'dots', confidence_degree(dotClass,models,scoreTOdebug,'dots',1));
        end
        imgWithoutSymbols=delObjects(imgWithoutSymbols,dotClass1,0);
        scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,dotClass1,0);
    end
    dotClass = [dotClass; dotClass1];
    processing_time = cputime-time;
    disp(['10b. Dots detection steps: ', num2str(processing_time), ' secs'])
    
    
    s = struct('ScoreID',i, 'StaffInfo', [spaceHeight, numberSpaces, lineHeight], 'Rests',restClass,'TimeSignatures',TimeSignature,'Dots',dotClass,'OpenNoteHeadWithoutStem',setOpenNotehead,...
        'Accidental',accidentalClass,'Clefs',ClefsClass,'Keys',keySignature,'BarLines',barlines,'Accent',accentClass,'Beams',BeamsClass,...
        'OpenNoteheadStem',setOpenNoteheadstem,'NoteheadStem',setnoteheadstem,'WholeRest',restClassIIW,'HalfRest',restClassIIH,...
        'DoubleWholeRest',restClassIIWa, 'degrees', degree, 'img_original', scoreTOdebug,'img_final',scorewithoutsymbolsdetected,'numberofsymbols',count);
    
    setOfSymbols = [setOfSymbols s];
    
    %     %     %%%%%%Debug
    %     if size(setnoteheadstem.noteheadstem,1)~=0
    %         for j=1:size(setnoteheadstem.noteheadstem,1)
    %             A = cell2mat(setnoteheadstem.noteheadstem(j,1));
    %             scoreTOdebug(A(1):A(2),A(3):A(4))=0.5;
    %             A = cell2mat(setnoteheadstem.noteheadstem(j,2));
    %             for k=1:size(A,1)
    %                 a = max(1,A(k,3)-1);
    %                 b = min(A(k,3)+1,size(score,2));
    %                 scoreTOdebug(A(k,1):A(k,2),a:b)=0.5;
    %             end
    %             A = cell2mat(setnoteheadstem.noteheadstem(j,4));
    %             if size(A,1)~=0
    %                 scoreTOdebug(A(1):A(2),A(3):A(4))=0.5;
    %             end
    %         end
    %     end
    
    %
    %
    %     if size(setOpenNoteheadstem.OpenNoteheadstem,1)~=0
    %         for j=1:size(setOpenNoteheadstem.OpenNoteheadstem,1)
    %             A = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,1));
    %             scoreTOdebug(A(1):A(2),A(3):A(4))=0.5;
    %             A = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,2));
    %             for k=1:size(A,1)
    %                 a = max(1,A(k,3)-1);
    %                 b = min(A(k,3)+1,size(score,2));
    %                 scoreTOdebug(A(k,1):A(k,2),a:b)=0.5;
    %             end
    %             A = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(j,4));
    %             if size(A,1)~=0
    %                 scoreTOdebug(A(1):A(2),A(3):A(4))=0.5;
    %             end
    %         end
    %     end
    %
    %     if size(BeamsClass,1)~=0
    %         for j=1:size(BeamsClass,1)
    %             scoreTOdebug(BeamsClass(j,1):BeamsClass(j,2),BeamsClass(j,3):BeamsClass(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(accentClass,1)~=0
    %         for j=1:size(accentClass,1)
    %             scoreTOdebug(accentClass(j,1):accentClass(j,2),accentClass(j,3):accentClass(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(barlines,1)~=0
    %         for j=1:size(barlines,1)
    %             scoreTOdebug(barlines(j,1):barlines(j,2),barlines(j,3):barlines(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(keySignature,1)~=0
    %         for j=1:size(keySignature,1)
    %             scoreTOdebug(keySignature(j,1):keySignature(j,2),keySignature(j,3):keySignature(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(ClefsClass,1)~=0
    %         for j=1:size(ClefsClass,1)
    %             scoreTOdebug(ClefsClass(j,1):ClefsClass(j,2),ClefsClass(j,3):ClefsClass(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(accidentalClass,1)~=0
    %         for j=1:size(accidentalClass,1)
    %             scoreTOdebug(accidentalClass(j,1):accidentalClass(j,2),accidentalClass(j,3):accidentalClass(j,4))=0.5;
    %         end
    %     end
    %
    %
    %     if size(setOpenNotehead,1)~=0
    %         for j=1:size(setOpenNotehead,1)
    %             scoreTOdebug(setOpenNotehead(j,1):setOpenNotehead(j,2),setOpenNotehead(j,3):setOpenNotehead(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(dotClass,1)~=0
    %         for j=1:size(dotClass,1)
    %             scoreTOdebug(dotClass(j,1):dotClass(j,2),dotClass(j,3):dotClass(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(TimeSignature,1)~=0
    %         for j=1:size(TimeSignature,1)
    %             scoreTOdebug(TimeSignature(j,1):TimeSignature(j,2),TimeSignature(j,3):TimeSignature(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(restClass,1)~=0
    %         for j=1:size(restClass,1)
    %             scoreTOdebug(restClass(j,1):restClass(j,2),restClass(j,3):restClass(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(barlines,1)~=0
    %         for j=1:size(barlines,1)
    %             scoreTOdebug(barlines(j,1):barlines(j,2),barlines(j,3):barlines(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(restClassIIW,1)~=0
    %         for j=1:size(restClassIIW,1)
    %             scoreTOdebug(restClassIIW(j,1):restClassIIW(j,2),restClassIIW(j,3):restClassIIW(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(restClassIIH,1)~=0
    %         for j=1:size(restClassIIH,1)
    %             scoreTOdebug(restClassIIH(j,1):restClassIIH(j,2),restClassIIH(j,3):restClassIIH(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(restClassIIWH,1)~=0
    %         for j=1:size(restClassIIWH,1)
    %             scoreTOdebug(restClassIIWH(j,1):restClassIIWH(j,2),restClassIIWH(j,3):restClassIIWH(j,4))=0.5;
    %         end
    %     end
    %
    %     if size(restClassIIWa,1)~=0
    %         for j=1:size(restClassIIWa,1)
    %             scoreTOdebug(restClassIIWa(j,1):restClassIIWa(j,2),restClassIIWa(j,3):restClassIIWa(j,4))=0.5;
    %         end
    %     end
    %
    %     filename=sprintf('symbol%d.png',r);
    %     filename=strcat('lixo\',filename);
    %     imwrite(scoreTOdebug, filename,'png')
    %     r=r+1;
    
    
    %
    %     filename=sprintf('symbol%d.png',r);
    %     filename=strcat('lixo\',filename);
    %     imwrite(imgWithoutSymbols, filename,'png')
    %     r=r+1;
    
    %     disp('--------------------------------------------------------------------------')
end