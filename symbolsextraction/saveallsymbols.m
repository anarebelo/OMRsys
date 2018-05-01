function  setOfSymbols = saveallsymbols (threshold, i, restClass, TimeSignature, dotClass, ...
    setOpenNotehead, accidentalClass, ClefsClass, keySignature, barlines,accentClass,BeamsClass, ...
    setOpenNoteheadstem, setnoteheadstem, restClassIIW, restClassIIH, restClassIIWa)

thresholdrow = threshold(1)-1;
thresholdcolumn = threshold(2)-1;

if size(restClass,1)~=0
    restClass1 = restClass(:,1:2) + thresholdrow;
    restClass2 = restClass(:,3:4) + thresholdcolumn;
    restClass = [restClass1 restClass2];
    height = restClass(:,2)-restClass(:,1)+1;
    width = restClass(:,4)-restClass(:,3)+1;
    restClass = [restClass width height];
end

if size(TimeSignature,1)~=0
    TimeSignature1 = TimeSignature(:,1:2) + thresholdrow;
    TimeSignature2 = TimeSignature(:,3:4) + thresholdcolumn;
    TimeSignature = [TimeSignature1 TimeSignature2];
    height = TimeSignature(:,2)-TimeSignature(:,1)+1;
    width = TimeSignature(:,4)-TimeSignature(:,3)+1;
    TimeSignature = [TimeSignature width height];
end

if size(dotClass,1)~=0
    dotClass1 = dotClass(:,1:2) + thresholdrow;
    dotClass2 = dotClass(:,3:4) + thresholdcolumn;
    dotClass = [dotClass1 dotClass2];
    height = dotClass(:,2)-dotClass(:,1)+1;
    width = dotClass(:,4)-dotClass(:,3)+1;
    dotClass = [dotClass width height];
end

if size(setOpenNotehead,1)~=0
    setOpenNotehead1 = setOpenNotehead(:,1:2) + thresholdrow;
    setOpenNotehead2 = setOpenNotehead(:,3:4) + thresholdcolumn;
    setOpenNotehead = [setOpenNotehead1 setOpenNotehead2];
    height = setOpenNotehead(:,2)-setOpenNotehead(:,1)+1;
    width = setOpenNotehead(:,4)-setOpenNotehead(:,3)+1;
    setOpenNotehead = [setOpenNotehead width height];
end

if size(accidentalClass,1)~=0
    accidentalClass1 = accidentalClass(:,1:2) + thresholdrow;
    accidentalClass2 = accidentalClass(:,3:4) + thresholdcolumn;
    accidentalClass =[accidentalClass1 accidentalClass2];
    height = accidentalClass(:,2)-accidentalClass(:,1)+1;
    width = accidentalClass(:,4)-accidentalClass(:,3)+1;
    accidentalClass = [accidentalClass width height];
end

if size(ClefsClass,1)~=0
    ClefsClass1 = ClefsClass(:,1:2) + thresholdrow;
    ClefsClass2 = ClefsClass(:,3:4) + thresholdcolumn;
    ClefsClass=[ClefsClass1 ClefsClass2];
    height = ClefsClass(:,2)-ClefsClass(:,1)+1;
    width = ClefsClass(:,4)-ClefsClass(:,3)+1;
    ClefsClass = [ClefsClass width height];
end

if size(keySignature,1)~=0
    keySignature1 = keySignature(:,1:2) + thresholdrow;
    keySignature2 = keySignature(:,3:4) + thresholdcolumn;
    keySignature=[keySignature1 keySignature2];
    height = keySignature(:,2)-keySignature(:,1)+1;
    width = keySignature(:,4)-keySignature(:,3)+1;
    keySignature = [keySignature width height];
end

if size(barlines,1)~=0
    barlines1 = barlines(:,1:2) + thresholdrow;
    barlines2 = barlines(:,3:4) + thresholdcolumn;
    barlines=[barlines1 barlines2];
    height = barlines(:,2)-barlines(:,1)+1;
    width = barlines(:,4)-barlines(:,3)+1;
    barlines = [barlines width height];
end

if size(accentClass,1)~=0
    accentClass1 = accentClass(:,1:2) + thresholdrow;
    accentClass2 = accentClass(:,3:4) + thresholdcolumn;
    accentClass =[accentClass1 accentClass2];
    height = accentClass(:,2)-accentClass(:,1)+1;
    width = accentClass(:,4)-accentClass(:,3)+1;
    accentClass = [accentClass width height];
end

if size(BeamsClass,1)~=0
    BeamsClass1 = BeamsClass(:,1:2) + thresholdrow;
    BeamsClass2 = BeamsClass(:,3:4) + thresholdcolumn;
    BeamsClass =[BeamsClass1 BeamsClass2];
    height = BeamsClass(:,2)-BeamsClass(:,1)+1;
    width = BeamsClass(:,4)-BeamsClass(:,3)+1;
    BeamsClass = [BeamsClass width height];
end

if size(restClassIIW,1)~=0
    restClassIIW1 = restClassIIW(:,1:2) + thresholdrow;
    restClassIIW2 = restClassIIW(:,3:4) + thresholdcolumn;
    restClassIIW=[restClassIIW1 restClassIIW2];
    height = restClassIIW(:,2)-restClassIIW(:,1)+1;
    width = restClassIIW(:,4)-restClassIIW(:,3)+1;
    restClassIIW = [restClassIIW width height];
end

if size(restClassIIH,1)~=0
    restClassIIH1 = restClassIIH(:,1:2) + thresholdrow;
    restClassIIH2 = restClassIIH(:,3:4) + thresholdcolumn;
    restClassIIH =[restClassIIH1 restClassIIH2];
    height = restClassIIH(:,2)-restClassIIH(:,1)+1;
    width = restClassIIH(:,4)-restClassIIH(:,3)+1;
    restClassIIH = [restClassIIH width height];
end

if size(restClassIIWa,1)~=0
    restClassIIWa1 = restClassIIWa(:,1:2) + thresholdrow;
    restClassIIWa2 = restClassIIWa(:,3:4) + thresholdcolumn;
    restClassIIWa =[restClassIIWa1 restClassIIWa2];
    height = restClassIIWa(:,2)-restClassIIWa(:,1)+1;
    width = restClassIIWa(:,4)-restClassIIWa(:,3)+1;
    restClassIIWa = [restClassIIWa width height];
end


setnotes = struct();
setnotes = setfield(setnotes, 'noteheadstem', [{}]);
if size(setnoteheadstem.noteheadstem,1)~=0
    notehead = cell2mat(setnoteheadstem.noteheadstem(:,1));
    notehead1 = notehead(:,1:2) + thresholdrow;
    notehead2 = notehead(:,3:4) + thresholdcolumn;
    notehead =[notehead1 notehead2];
    height = notehead(:,2)-notehead(:,1)+1;
    width = notehead(:,4)-notehead(:,3)+1;
    notehead = [notehead width height];
    
    stem = cell2mat(setnoteheadstem.noteheadstem(:,2));
    stem1 = stem(:,1:2) + thresholdrow;
    stem2 = stem(:,3) + thresholdcolumn;
    stem = [stem1 stem2 stem(:,end)];    
    
    for j=1:size(notehead,1)
        flag = cell2mat(setnoteheadstem.noteheadstem(j,4));
        if size(flag,1) == 0
            flag=[];
        else
            flag1 = flag(:,1:2) + thresholdrow;
            flag2 = flag(:,3:4) + thresholdcolumn;
            flag=[flag1 flag2];
            height = flag(2)-flag(1)+1;
            width = flag(4)-flag(3)+1;
            flag = [flag width height];
        end
        
        setnotes = setfield(setnotes, 'noteheadstem', [setnotes.noteheadstem; {notehead(j,:) stem(j,:) cell2mat(setnoteheadstem.noteheadstem(j,3)) flag}]);
    end
end


setopennotes = struct();
setopennotes = setfield(setopennotes, 'noteheadstem', [{}]);
if size(setOpenNoteheadstem.OpenNoteheadstem,1)~=0
    notehead = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(:,1));
    notehead1 = notehead(:,1:2) + thresholdrow;
    notehead2 = notehead(:,3:4) + thresholdcolumn;
    notehead =[notehead1 notehead2];
    height = notehead(:,2)-notehead(:,1)+1;
    width = notehead(:,4)-notehead(:,3)+1;
    notehead = [notehead width height];
    
    stem = cell2mat(setOpenNoteheadstem.OpenNoteheadstem(:,2));
    stem1 = stem(:,1:2) + thresholdrow;
    stem2 = stem(:,end) + thresholdcolumn;
    stem = [stem1 stem2];
    for j=1:size(notehead,1)
        setopennotes = setfield(setopennotes, 'noteheadstem', [setopennotes.noteheadstem; {notehead(j,:) stem(j,:) [] []}]);
    end
    
end


setOfSymbols = struct('ScoreID',i,'Rests',restClass,'TimeSignatures',TimeSignature,'Dots',dotClass,'OpenNoteHeadWithoutStem',setOpenNotehead,...
    'Accidental',accidentalClass,'Clefs',ClefsClass,'Keys',keySignature,'BarLines',barlines,'Accent',accentClass,'Beams',BeamsClass,...
    'OpenNoteheadStem',setopennotes,'NoteheadStem',setnotes,'WholeRest',restClassIIW,'HalfRest',restClassIIH,...
    'DoubleWholeRest',restClassIIWa);