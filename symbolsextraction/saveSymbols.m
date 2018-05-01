function count = saveSymbols(symbols, type, count, score,FILE)

if strcmp('noteheads',type)
    for j=1:size(symbols.noteheadstem,1)
        nH = cell2mat(symbols.noteheadstem(j,1));
        stem = cell2mat(symbols.noteheadstem(j,2));
        flag = cell2mat(symbols.noteheadstem(j,4));

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
        %
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);

        a = max(symbol(3)-5,1);
        b = min(symbol(4)+5,size(score,2));
        imwrite(score(symbol(1):symbol(2),a:b), filename,'png')
        count=count+1;

    end
elseif strcmp('openNoteheads',type)

    for j=1:size(symbols.OpenNoteheadstem,1)
        nH = cell2mat(symbols.OpenNoteheadstem(j,1));
        stem = cell2mat(symbols.OpenNoteheadstem(j,2));
        flag = cell2mat(symbols.OpenNoteheadstem(j,4));

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
        %
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);


        a = max(symbol(3)-5,1);
        b = min(symbol(4)+5,size(score,2));

        imwrite(score(symbol(1):symbol(2),a:b), filename,'png')
        count=count+1;

    end
elseif strcmp('beams',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end
elseif strcmp('barlines',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end 
elseif strcmp('TimeSignatureN',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end 
elseif strcmp('TimeSignatureL',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end     
elseif strcmp('accents',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end  
elseif strcmp('rests',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end 
elseif strcmp('wholerests',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end    
elseif strcmp('halfrests',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end    
elseif strcmp('doublewholerests',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end       
elseif strcmp('dots',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end    
elseif strcmp('keySignature',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end
elseif strcmp('clefs',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end
elseif strcmp('accidentals',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end
elseif strcmp('openNoteheadsI',type)
    for i=1:size(symbols,1)
        filename=sprintf('symbol%d.png',count);
        filename=strcat(FILE, '\', type, '\', filename);
        imwrite(score(symbols(i,1):symbols(i,2),symbols(i,3):symbols(i,4)), filename,'png')
        count=count+1;
    end
end