function [BeamsBetweenTwoNoteHeads, noteHeadWithBeams, setnoteheadstem]=noteHeadsBeams(setnoteheadstem,setnoteheadstemO,BeamWithoutNotehead,beamsWithOneNotehead,spaceHeight,lineHeight)

%find the noteheads of the beams
noteHead = [];
rangenumber = 6;
SymbolBeam=[];


for i=1:size(beamsWithOneNotehead,1)
    beam = beamsWithOneNotehead(i,:);


    %left of the beam
    idx1=-1;
    for l=1:size(setnoteheadstem.noteheadstem,1)
        A = cell2mat(setnoteheadstem.noteheadstem(l,2));
        colStem = A(:,3);

        for j=1:size(colStem,1)
            for k=1:12
                if (colStem(j)-k) == beam(3) & ((abs(beam(2)-A(j,1)) < spaceHeight) || (abs(beam(1)-A(j,2)) < spaceHeight) || (beam(1) >= A(j,1) & beam(2)<=A(j,2)) ||   (abs(beam(1)-A(j,1)) < spaceHeight & beam(2)<=A(j,2)) || (abs(beam(2)-A(j,2)) < spaceHeight & beam(1)>=A(j,1)))
                    idx1=j;
                    break;
                elseif (colStem(j)+k) == beam(3) & ((abs(beam(2)-A(j,1)) < spaceHeight) || (abs(beam(1)-A(j,2)) < spaceHeight) || (beam(1) >= A(j,1) & beam(2)<=A(j,2)) ||   (abs(beam(1)-A(j,1)) < spaceHeight & beam(2)<=A(j,2)) || (abs(beam(2)-A(j,2)) < spaceHeight & beam(1)>=A(j,1)))
                    idx1=j;
                    break;
                elseif colStem(j) == beam(3) & ((abs(beam(2)-A(j,1)) < spaceHeight) || (abs(beam(1)-A(j,2)) < spaceHeight) || (beam(1) >= A(j,1) & beam(2)<=A(j,2)) ||   (abs(beam(1)-A(j,1)) < spaceHeight & beam(2)<=A(j,2)) || (abs(beam(2)-A(j,2)) < spaceHeight & beam(1)>=A(j,1)))
                    idx1=j;
                    break;
                end
            end
            if idx1>-1
                break;
            end
        end
        if idx1>-1
            break;
        end
    end

    %right of the beam
    idx2=-1;
    for ll=1:size(setnoteheadstem.noteheadstem,1)
        A = cell2mat(setnoteheadstem.noteheadstem(ll,2));
        colStem = A(:,3);

        for u=1:size(colStem,1)
            for k=1:12
                if (colStem(u)-k) == beam(4) & ((abs(beam(2)-A(u,1)) < spaceHeight) || (abs(beam(1)-A(u,2)) < spaceHeight) || (beam(1) >= A(u,1) & beam(2)<=A(u,2)) ||   (abs(beam(1)-A(u,1)) < spaceHeight & beam(2)<=A(u,2)) || (abs(beam(2)-A(u,2)) < spaceHeight & beam(1)>=A(u,1)))
                    idx2=u;
                    break;
                elseif (colStem(u)+k) == beam(4) & ((abs(beam(2)-A(u,1)) < spaceHeight) || (abs(beam(1)-A(u,2)) < spaceHeight) || (beam(1) >= A(u,1) & beam(2)<=A(u,2)) ||   (abs(beam(1)-A(u,1)) < spaceHeight & beam(2)<=A(u,2)) || (abs(beam(2)-A(u,2)) < spaceHeight & beam(1)>=A(u,1)))
                    idx2=u;
                    break;
                elseif colStem(u) == beam(4) & ((abs(beam(2)-A(u,1)) < spaceHeight) || (abs(beam(1)-A(u,2)) < spaceHeight) || (beam(1) >= A(u,1) & beam(2)<=A(u,2)) ||   (abs(beam(1)-A(u,1)) < spaceHeight & beam(2)<=A(u,2)) || (abs(beam(2)-A(u,2)) < spaceHeight & beam(1)>=A(u,1)))
                    idx2=u;
                    break;
                end
            end
            if idx2>-1
                break;
            end
        end
        if idx2>-1
            break;
        end
    end

    if idx1>-1 || idx2>-1
        if idx1 > -1
            noteHeadRejected = cell2mat(setnoteheadstem.noteheadstem(l,1));
            Stem = cell2mat(setnoteheadstem.noteheadstem(l,2));
            indice = l;
        end
        if idx2 > -1
            noteHeadRejected = cell2mat(setnoteheadstem.noteheadstem(ll,1));
            Stem = cell2mat(setnoteheadstem.noteheadstem(ll,2));
            indice = ll;
        end

        noteHeadRej = noteHeadRejected(:,1:4);
        id = find(noteHeadRej(:,1) == beam(1) & noteHeadRej(:,2) == beam(2) & noteHeadRej(:,3) == beam(3) & noteHeadRej(:,4) == beam(4));
        noteHeadRejected(id,:) = [];

        if size(noteHeadRejected,1)~=0
            % notehead at end of the beam
            if beam(5) == 1 || beam(5) == 4

                %notehead at left of a beam (notehead at the begin of the beam)
                [resultNH,v] = findnH(noteHeadRejected,beam,3,4,rangenumber);
                if resultNH>-1
                    nH = noteHeadRejected;
                    result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                    if result == 1
                        noteHead=[noteHead; indice];
                        setnoteheadstem.noteheadstem(indice,3) = {beam(1:4)};
                        SymbolBeam=[SymbolBeam; beam(1:4)];
                    else
                        %notehead at right of a beam (notehead at the begin of the beam)
                        [resultNH,v] = findnH(noteHeadRejected,beam,3,3,rangenumber);
                        if resultNH>-1
                            nH = noteHeadRejected;
                            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                            if result == 1
                                noteHead=[noteHead; indice];
                                setnoteheadstem.noteheadstem(indice,3) = {beam(1:4)};
                                SymbolBeam=[SymbolBeam; beam(1:4)];
                            else

                                setnoteheadstemO.noteheadstem(beam(1,end),3) = {[]};
                            end
                        end
                    end
                else
                    %notehead at right of a beam (notehead at the begin of the beam)
                    [resultNH,v] = findnH(noteHeadRejected,beam,3,3,rangenumber);
                    if resultNH>-1
                        nH = noteHeadRejected;
                        result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                        if result == 1
                            noteHead=[noteHead; indice];
                            setnoteheadstem.noteheadstem(indice,3) = {beam(1:4)};
                            SymbolBeam=[SymbolBeam; beam(1:4)];
                        else

                            setnoteheadstemO.noteheadstem(beam(1,end),3) = {[]};
                        end
                    end
                end

                % notehead at begin of the beam
            elseif beam(5) == 2 || beam(5) == 3
                %notehead at left of a beam (notehead at the end of the beam)
                [resultNH,v] = findnH(noteHeadRejected,beam,4,4,rangenumber);
                if resultNH>-1
                    nH = noteHeadRejected;
                    result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                    if result == 1
                        noteHead=[noteHead; indice];
                        setnoteheadstem.noteheadstem(indice,3) = {beam(1:4)};
                        SymbolBeam=[SymbolBeam; beam(1:4)];
                    else
                        %notehead at right of a beam (notehead at the end of the beam)
                        [resultNH,v] = findnH(noteHeadRejected,beam,4,3,rangenumber);
                        if resultNH>-1
                            nH = noteHeadRejected;
                            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                            if result == 1
                                noteHead=[noteHead; indice];
                                setnoteheadstem.noteheadstem(indice,3) = {beam(1:4)};
                                SymbolBeam=[SymbolBeam; beam(1:4)];
                            else
                                setnoteheadstemO.noteheadstem(beam(1,end),3) = {[]};
                            end
                        end
                    end
                else
                    %notehead at right of a beam (notehead at the end of the beam)
                    [resultNH,v] = findnH(noteHeadRejected,beam,4,3,rangenumber);
                    if resultNH>-1
                        nH = noteHeadRejected;
                        result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                        if result == 1
                            noteHead=[noteHead; indice];
                            setnoteheadstem.noteheadstem(indice,3) = {beam(1:4)};
                            SymbolBeam=[SymbolBeam; beam(1:4)];
                        else

                            setnoteheadstemO.noteheadstem(beam(1,end),3) = {[]};
                        end
                    end
                end
            end
        end
    end
end


for i=1:size(BeamWithoutNotehead,1)
    beam = BeamWithoutNotehead(i,:);

    %left of the beam
    idx1=-1;
    for l=1:size(setnoteheadstem.noteheadstem,1)
        A = cell2mat(setnoteheadstem.noteheadstem(l,2));
        colStem = A(:,3);

        for j=1:size(colStem,1)
            for k=1:12
                if (colStem(j)-k) == beam(3) & ((abs(beam(2)-A(j,1)) < spaceHeight) || (abs(beam(1)-A(j,2)) < spaceHeight) || (beam(1) >= A(j,1) & beam(2)<=A(j,2)) ||   (abs(beam(1)-A(j,1)) < spaceHeight & beam(2)<=A(j,2)) || (abs(beam(2)-A(j,2)) < spaceHeight & beam(1)>=A(j,1)))
                    idx1=j;
                    break;
                elseif (colStem(j)+k) == beam(3) & ((abs(beam(2)-A(j,1)) < spaceHeight) || (abs(beam(1)-A(j,2)) < spaceHeight) || (beam(1) >= A(j,1) & beam(2)<=A(j,2)) ||   (abs(beam(1)-A(j,1)) < spaceHeight & beam(2)<=A(j,2)) || (abs(beam(2)-A(j,2)) < spaceHeight & beam(1)>=A(j,1)))
                    idx1=j;
                    break;
                elseif colStem(j) == beam(3) & ((abs(beam(2)-A(j,1)) < spaceHeight) || (abs(beam(1)-A(j,2)) < spaceHeight) || (beam(1) >= A(j,1) & beam(2)<=A(j,2)) ||   (abs(beam(1)-A(j,1)) < spaceHeight & beam(2)<=A(j,2)) || (abs(beam(2)-A(j,2)) < spaceHeight & beam(1)>=A(j,1)))
                    idx1=j;
                    break;
                end
            end
            if idx1>-1
                break;
            end
        end
        if idx1>-1
            break;
        end
    end

    %right of the beam
    idx2=-1;
    for ll=1:size(setnoteheadstem.noteheadstem,1)
        A = cell2mat(setnoteheadstem.noteheadstem(ll,2));
        colStem = A(:,3);

        for u=1:size(colStem,1)
            for k=1:12
                if (colStem(u)-k) == beam(4) & ((abs(beam(2)-A(u,1)) < spaceHeight) || (abs(beam(1)-A(u,2)) < spaceHeight) || (beam(1) >= A(u,1) & beam(2)<=A(u,2)) ||   (abs(beam(1)-A(u,1)) < spaceHeight & beam(2)<=A(u,2)) || (abs(beam(2)-A(u,2)) < spaceHeight & beam(1)>=A(u,1)))
                    idx2=u;
                    break;
                elseif (colStem(u)+k) == beam(4) & ((abs(beam(2)-A(u,1)) < spaceHeight) || (abs(beam(1)-A(u,2)) < spaceHeight) || (beam(1) >= A(u,1) & beam(2)<=A(u,2)) ||   (abs(beam(1)-A(u,1)) < spaceHeight & beam(2)<=A(u,2)) || (abs(beam(2)-A(u,2)) < spaceHeight & beam(1)>=A(u,1)))
                    idx2=u;
                    break;
                elseif colStem(u) == beam(4) & ((abs(beam(2)-A(u,1)) < spaceHeight) || (abs(beam(1)-A(u,2)) < spaceHeight) || (beam(1) >= A(u,1) & beam(2)<=A(u,2)) ||   (abs(beam(1)-A(u,1)) < spaceHeight & beam(2)<=A(u,2)) || (abs(beam(2)-A(u,2)) < spaceHeight & beam(1)>=A(u,1)))
                    idx2=u;
                    break;
                end
            end
            if idx2>-1
                break;
            end
        end
        if idx2>-1
            break;
        end
    end

    if idx1>-1 || idx2>-1
        if idx1 > -1
            noteHeadRejected = cell2mat(setnoteheadstem.noteheadstem(l,1));
            Stem = cell2mat(setnoteheadstem.noteheadstem(l,2));
            indice = l;
        end
        if idx2 > -1
            noteHeadRejected = cell2mat(setnoteheadstem.noteheadstem(ll,1));
            Stem = cell2mat(setnoteheadstem.noteheadstem(ll,2));
            indice = ll;
        end

        noteHeadRej = noteHeadRejected(:,1:4);
        id = find(noteHeadRej(:,1) == beam(1) & noteHeadRej(:,2) == beam(2) & noteHeadRej(:,3) == beam(3) & noteHeadRej(:,4) == beam(4));
        noteHeadRejected(id,:) = [];

        if size(noteHeadRejected,1)~=0
            %notehead at left of a beam (notehead at the end of the beam)
            [resultNH,v] = findnH(noteHeadRejected,beam,4,4,rangenumber);

            if resultNH>-1
                nH = noteHeadRejected;
                result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                if result == 1
                    %notehead at right of a beam (notehead at the begin of the beam)
                    [resultNH,v] = findnH(noteHeadRejected,beam,3,3,rangenumber);

                    if resultNH>-1
                        nH = noteHeadRejected;
                        result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                        if result == 1
                            noteHead=[noteHead; indice];
                            setnoteheadstem.noteheadstem(indice,3) = {beam};
                            SymbolBeam=[SymbolBeam; beam];
                        else
                            %notehead at left of a beam (notehead at the begin of the beam)
                            [resultNH,v] = findnH(noteHeadRejected,beam,3,4,rangenumber);

                            if resultNH>-1

                                nH = noteHeadRejected;
                                result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                                if result == 1
                                    noteHead=[noteHead; indice];
                                    setnoteheadstem.noteheadstem(indice,3) = {beam};
                                    SymbolBeam=[SymbolBeam; beam];
                                end

                            end
                        end

                    end
                end

            else
                %notehead at right of a beam (notehead at the end of the beam)
                [resultNH,v] = findnH(noteHeadRejected,beam,4,3,rangenumber);

                if resultNH>-1

                    nH = noteHeadRejected;
                    result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                    if result == 1
                        %notehead at right of a beam (notehead at the begin of the beam)
                        [resultNH,v] = findnH(noteHeadRejected,beam,3,3,rangenumber);

                        if resultNH>-1

                            nH = noteHeadRejected;
                            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                            if result == 1
                                noteHead=[noteHead; indice];
                                setnoteheadstem.noteheadstem(indice,3) = {beam};
                                SymbolBeam=[SymbolBeam; beam];
                            else
                                %notehead at left of a beam (notehead at the begin of the beam)
                                [resultNH,v] = findnH(noteHeadRejected,beam,3,4,rangenumber);

                                if resultNH>-1

                                    nH = noteHeadRejected;
                                    result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                                    if result == 1
                                        noteHead=[noteHead; indice];
                                        setnoteheadstem.noteheadstem(indice,3) = {beam};
                                        SymbolBeam=[SymbolBeam; beam];
                                    end

                                end
                            end

                        end
                    end

                end
            end
        end
    end
end
BeamsBetweenTwoNoteHeads = SymbolBeam;
noteHeadWithBeams = noteHead;

return