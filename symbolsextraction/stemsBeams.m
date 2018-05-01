function [SymbolBeam, associatedBeam,BeamWithoutNotehead,setnoteheadstem]=stemsBeams(setnoteheadstem, beams,spaceHeight,lineHeight)


%find the noteheads of the beams
SymbolBeam = [];
associatedBeam = [];
BeamWithoutNotehead = [];
rangenumber = 12;

for i=1:size(beams,1)
    beam = beams(i,:);

    %left of the beam
    idx1=-1;
    for l=1:size(setnoteheadstem.noteheadstem,1)
        A = cell2mat(setnoteheadstem.noteheadstem(l,2));
        colStem = A(:,3);

        for j=1:size(colStem,1)
            for k=1:12
                if (colStem(j)-k) == beam(3) & ((abs(beam(2)-A(j,1)) < spaceHeight) || (abs(beam(1)-A(j,2)) < spaceHeight) || (beam(1) >= A(j,1) & beam(2)<=A(j,2)) ||   (abs(beam(1)-A(j,1)) < spaceHeight & beam(2)<=A(j,2)) || (abs(beam(2)-A(j,2)) < spaceHeight & beam(1)>=A(j,1)) )
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

    %Between two stems is a beam
    %Necessary to find the noteheads associated. If they do not exist then
    %it is not a beam and it is not considered
    if idx1>-1 && idx2>-1

        if l ~= ll
            NewnoteHead = cell2mat(setnoteheadstem.noteheadstem([l; ll],1));
        else
            continue;
        end


        %notehead at left of a beam (notehead at the end of the beam)
        [resultNH,v] = findnH(NewnoteHead,beam,4,4,rangenumber);

        if resultNH>-1
            nH = NewnoteHead(v,:);
            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

            if result == 1
                %notehead at right of a beam (notehead at the begin of the beam)
                [resultNH,v] = findnH(NewnoteHead,beam,3,3,rangenumber);

                if resultNH>-1
                    nH = NewnoteHead(v,:);
                    result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                    if result == 1
                        SymbolBeam = [SymbolBeam; beam];
                        setnoteheadstem.noteheadstem(l,3) = {beam};
                        setnoteheadstem.noteheadstem(ll,3) = {beam};
                    else
                        %notehead at left of a beam (notehead at the begin of the beam)
                        [resultNH,v] = findnH(NewnoteHead,beam,3,4,rangenumber);

                        if resultNH>-1
                            nH = NewnoteHead(v,:);
                            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                            if result == 1
                                SymbolBeam = [SymbolBeam; beam];
                                setnoteheadstem.noteheadstem(l,3) = {beam};
                                setnoteheadstem.noteheadstem(ll,3) = {beam};
                            end
                        end
                    end
                else
                    %notehead at left of a beam (notehead at the begin of the beam)
                    [resultNH,v] = findnH(NewnoteHead,beam,3,4,rangenumber);

                    if resultNH>-1
                        nH = NewnoteHead(v,:);
                        result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                        if result == 1
                            SymbolBeam = [SymbolBeam; beam];
                            setnoteheadstem.noteheadstem(l,3) = {beam};
                            setnoteheadstem.noteheadstem(ll,3) = {beam};
                        end
                    end
                end
            end
        else
            %notehead at right of a beam (notehead at the end of the beam)
            [resultNH,v] = findnH(NewnoteHead,beam,4,3,rangenumber);

            if resultNH>-1
                nH = NewnoteHead(v,:);
                result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                if result == 1
                    %notehead at right of a beam (notehead at the begin of the beam)
                    [resultNH,v] = findnH(NewnoteHead,beam,3,3,rangenumber);

                    if resultNH>-1
                        nH = NewnoteHead(v,:);
                        result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                        if result == 1
                            SymbolBeam = [SymbolBeam; beam];
                            setnoteheadstem.noteheadstem(l,3) = {beam};
                            setnoteheadstem.noteheadstem(ll,3) = {beam};
                        else
                            %notehead at left of a beam (notehead at the begin of the beam)
                            [resultNH,v] = findnH(NewnoteHead,beam,3,4,rangenumber);

                            if resultNH>-1
                                nH = NewnoteHead(v,:);
                                result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                                if result == 1
                                    SymbolBeam = [SymbolBeam; beam];
                                    setnoteheadstem.noteheadstem(l,3) = {beam};
                                    setnoteheadstem.noteheadstem(ll,3) = {beam};
                                end
                            end
                        end
                    else
                        %notehead at left of a beam (notehead at the begin of the beam)
                        [resultNH,v] = findnH(NewnoteHead,beam,3,4,rangenumber);

                        if resultNH>-1
                            nH = NewnoteHead(v,:);
                            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                            if result == 1
                                SymbolBeam = [SymbolBeam; beam];
                                setnoteheadstem.noteheadstem(l,3) = {beam};
                                setnoteheadstem.noteheadstem(ll,3) = {beam};
                            end
                        end
                    end
                end
            end
        end
    elseif idx1>-1 || idx2>-1
        if idx1 > -1
            NewnoteHead = cell2mat(setnoteheadstem.noteheadstem(l,1));
            indice = l;
        end
        if idx2 > -1
            NewnoteHead = cell2mat(setnoteheadstem.noteheadstem(ll,1));
            indice = ll;
        end

        %notehead at left of a beam (notehead at the end of the beam)
        [resultNH,v] = findnH(NewnoteHead,beam,4,4,rangenumber);

        if resultNH>-1
            nH = NewnoteHead;
            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

            if result == 1
                associatedBeam=[associatedBeam; beam 1 indice];
                setnoteheadstem.noteheadstem(indice,3) = {beam};
            else
                %notehead at left of a beam (notehead at the begin of the beam)
                [resultNH,v] = findnH(NewnoteHead,beam,3,4,rangenumber);

                if resultNH>-1
                    nH = NewnoteHead;
                    result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                    if result == 1
                        associatedBeam=[associatedBeam; beam 2 indice];
                        setnoteheadstem.noteheadstem(indice,3) = {beam};
                    else
                        %notehead at right of a beam (notehead at the begin of the beam)
                        [resultNH,v] = findnH(NewnoteHead,beam,3,3,rangenumber);

                        if resultNH>-1
                            nH = NewnoteHead;
                            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                            if result == 1
                                associatedBeam=[associatedBeam; beam 3 indice];
                                setnoteheadstem.noteheadstem(indice,3) = {beam};
                            else
                                %notehead at right of a beam (notehead at the end of the beam)
                                [resultNH,v] = findnH(NewnoteHead,beam,4,3,rangenumber);

                                if resultNH>-1
                                    nH = NewnoteHead;
                                    result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                                    if result == 1
                                        associatedBeam=[associatedBeam; beam 4 indice];
                                        setnoteheadstem.noteheadstem(indice,3) = {beam};
                                    else
                                        % Do not exist any notehead but exist a beam
                                        BeamWithoutNotehead=[BeamWithoutNotehead; beam];
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            %notehead at left of a beam (notehead at the begin of the beam)
            [resultNH,v] = findnH(NewnoteHead,beam,3,4,rangenumber);

            if resultNH>-1
                nH = NewnoteHead;
                result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                if result == 1
                    associatedBeam=[associatedBeam; beam 2 indice];
                    setnoteheadstem.noteheadstem(indice,3) = {beam};
                else
                    %notehead at right of a beam (notehead at the begin of the beam)
                    [resultNH,v] = findnH(NewnoteHead,beam,3,3,rangenumber);

                    if resultNH>-1
                        nH = NewnoteHead;
                        result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                        if result == 1
                            associatedBeam=[associatedBeam; beam 3 indice];
                            setnoteheadstem.noteheadstem(indice,3) = {beam};
                        else
                            %notehead at right of a beam (notehead at the end of the beam)
                            [resultNH,v] = findnH(NewnoteHead,beam,4,3,rangenumber);

                            if resultNH>-1
                                nH = NewnoteHead;
                                result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                                if result == 1
                                    associatedBeam=[associatedBeam; beam 4 indice];
                                    setnoteheadstem.noteheadstem(indice,3) = {beam};
                                else
                                    % Do not exist any notehead but exist a beam
                                    BeamWithoutNotehead=[BeamWithoutNotehead; beam];
                                end
                            end
                        end
                    end
                end
            else
                %notehead at right of a beam (notehead at the begin of the beam)
                [resultNH,v] = findnH(NewnoteHead,beam,3,3,rangenumber);

                if resultNH>-1
                    nH = NewnoteHead;
                    result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                    if result == 1
                        associatedBeam=[associatedBeam; beam 3 indice];
                        setnoteheadstem.noteheadstem(indice,3) = {beam};
                    else
                        %notehead at right of a beam (notehead at the end of the beam)
                        [resultNH,v] = findnH(NewnoteHead,beam,4,3,rangenumber);

                        if resultNH>-1
                            nH = NewnoteHead;
                            result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                            if result == 1
                                associatedBeam=[associatedBeam; beam 4 indice];
                                setnoteheadstem.noteheadstem(indice,3) = {beam};
                            else
                                % Do not exist any notehead but exist a beam
                                BeamWithoutNotehead=[BeamWithoutNotehead; beam];
                            end
                        end
                    end
                else

                    %notehead at right of a beam (notehead at the end of the beam)
                    [resultNH,v] = findnH(NewnoteHead,beam,4,3,rangenumber);

                    if resultNH>-1
                        nH = NewnoteHead;
                        result =  rowpositionbeam(beam,nH,spaceHeight,lineHeight);

                        if result == 1
                            associatedBeam=[associatedBeam; beam 4 indice];
                            setnoteheadstem.noteheadstem(indice,3) = {beam};
                        else
                            % Do not exist any notehead but exist a beam
                            BeamWithoutNotehead=[BeamWithoutNotehead; beam];
                        end

                    end
                end
            end
        end
    end

end

return