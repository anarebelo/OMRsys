function [ClefsClass,keySignature,TimeSignature,scoreWithoutClefsKeySignature,count,degree,scorewithoutsymbolsdetected,scoreWithoutClefs] = submain(score,spaceHeight,lineHeight,dataY,dataX,numberLines,i,...
    initialpositions,data_staffinfo_sets,scoreTOdebug,models,count,degree,heigthKeySignatures,scorewithoutsymbolsdetected,nn,brace)


keySignature = [];
TimeSignature = [];

time = cputime;
%%Remove ledgerLines
[score]=removeLegerLines(score,spaceHeight,lineHeight,dataY,dataX,numberLines,i,initialpositions,data_staffinfo_sets);
processing_time = cputime-time;
disp(['0. Remove Ledger Lines: ', num2str(processing_time), ' secs'])


%I. Clefs detection
time = cputime;
[clefs] = findClefsSymbols(score,dataY,dataX,i,initialpositions,spaceHeight,lineHeight,numberLines,[],data_staffinfo_sets,brace);
ClefsClass = clefs;
processing_time = cputime-time;
disp(['1. Clefs detection: ', num2str(processing_time), ' secs'])

%Save Clefs Symbols
if size(ClefsClass,1)~=0
    if nn == 1
        FILE = assign_name_file('clefs_rule',0);
    else
        FILE = assign_name_file('clefs_rule',1);
    end
    count = saveSymbols(ClefsClass, 'clefs', count, score,FILE);
    degree = setfield(degree, 'clef', confidence_degree(ClefsClass,models,scoreTOdebug,'clefs',1));
    %Remove clefs
    scoreWithoutClefs=delObjects(score,ClefsClass,0);
    scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,ClefsClass,0);
else
    scoreWithoutClefs = score;
end

%II. Key Signature detection
%Acidentes sobrepostos - não detecta
if size(ClefsClass,1)~=0
    time = cputime;
    [keySignature] = findKeySignaturesSymbols(scoreWithoutClefs,dataY,dataX,i,initialpositions,spaceHeight,lineHeight,numberLines,ClefsClass,data_staffinfo_sets);
    processing_time = cputime-time;
    disp(['2. Key Signature detection: ', num2str(processing_time), ' secs'])
end

%Save Key Signature Symbols
%Este símbolo pode existir depois de cada barra métrica. Mais tarde fazer procura novamente
if size(keySignature,1)~=0
    if nn == 1
        FILE = assign_name_file('keySignature_rule',0);
    else
        FILE = assign_name_file('keySignature_rule',1);
    end
    count = saveSymbols(keySignature, 'keySignature', count, scoreWithoutClefs,FILE);
    degree = setfield(degree, 'keySignature', confidence_degree(keySignature,models,scoreWithoutClefs,'keySignature',1));
    %Remove clefs
    scoreWithoutClefsKeySignature=delObjects(scoreWithoutClefs,keySignature,0);
    scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,keySignature,0);
else
    scoreWithoutClefsKeySignature = scoreWithoutClefs;
end


%III. Time Signature detection
if size(ClefsClass,1)~=0
    if size(keySignature,1)~=0
        time = cputime;
        [TimeSignature] = findTimeSignaturesSymbols(scoreWithoutClefsKeySignature,dataY,dataX,i,initialpositions,spaceHeight,lineHeight,numberLines,keySignature,data_staffinfo_sets);
        processing_time = cputime-time;
        disp(['3. Time Signature detection: ', num2str(processing_time), ' secs'])
    else
        
        time = cputime;
        [TimeSignature] = findTimeSignaturesSymbols(scoreWithoutClefsKeySignature,dataY,dataX,i,initialpositions,spaceHeight,lineHeight,numberLines,ClefsClass,data_staffinfo_sets);
        processing_time = cputime-time;
        disp(['3. Time Signature detection: ', num2str(processing_time), ' secs'])
    end
end



%Save Time Signature Symbols
if size(TimeSignature,1)~=0
    for j=1:size(TimeSignature,1)
        TS = TimeSignature(j,:);
        if TS(end) > heigthKeySignatures
            if nn == 1
                FILE = assign_name_file('TimeSignatureN_rule',0);
            else
                FILE = assign_name_file('TimeSignatureN_rule',1);
            end
            count = saveSymbols(TS, 'TimeSignatureN', count, scoreWithoutClefsKeySignature,FILE);
            degree = setfield(degree, 'TimeSignatureN', confidence_degree(TS,models,scoreTOdebug,'TimeSignatureN',1)); % Graus para cada símbolo
        else
            if nn == 1
                FILE = assign_name_file('TimeSignatureL_rule',0);
            else
                FILE = assign_name_file('TimeSignatureL_rule',1);
            end
            count = saveSymbols(TS, 'TimeSignatureL', count, scoreWithoutClefsKeySignature,FILE);
            degree = setfield(degree, 'TimeSignatureL', confidence_degree(TS,models,scoreTOdebug,'TimeSignatureL',1));
        end
    end
    %Remove time signature
    scoreWithoutClefsKeySignature=delObjects(scoreWithoutClefsKeySignature,TimeSignature,0);
    scorewithoutsymbolsdetected=delObjects(scorewithoutsymbolsdetected,TimeSignature,0);
end
