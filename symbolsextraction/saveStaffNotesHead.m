function [newsymbolNoteHead, flag] = saveStaffNotesHead(newsymbolNoteHead, symbolNoteHead, setrows, spaceHeight, lineHeight, k, newSymbol, i, control)

%typeNoteHead -> 0 closed notehead
%typeNoteHead -> 1 open notehead


flag = 0;
ss = [symbolNoteHead(k,1:2)' ones(2,1)];
aux = [ss; setrows];
[value idx]=sort(aux(:,1));
aux = aux(idx,:);
idxone=find(aux(:,2)==1);
aux1 = aux(idxone(1):idxone(2),:);


if control == 0
    % equal rows -> overlap a staffline
    index = find(diff(aux1(:,1))==0);
    if isempty(index)==0
        number = find(ss(1) == setrows(:,1));
        pitch = choosescale(number);
        newsymbolNoteHead = [newsymbolNoteHead; i pitch-1 newSymbol];
        flag = 1;
        return
    end
end

if size(aux1,1)==4
    if aux1(2,1) - aux1(1,1) == 1
        aux1(2,:) = [];
    elseif aux1(4,1) - aux1(3,1) == 1
        aux1(3,:) = [];
    end
end

if size(aux1,1)<=3
    %On a staffline
    if length(find(diff(aux1(:,1))>spaceHeight/3) == 1) == 2
        number = find(aux1(2) == setrows(:,1));
        pitch = choosescale(number);
        newsymbolNoteHead = [newsymbolNoteHead; i pitch newSymbol];
        %On a staffspace
    else
        %If we have a staffline
        if length(find(aux1(:,2)==2)) ~= 0
            number = find(aux1(2) == setrows(:,1));
            pitch = choosescale(number);
            [v idxmin] = min(diff(aux1(:,1)));
            if idxmin == 1
                newsymbolNoteHead = [newsymbolNoteHead; i pitch-1 newSymbol];
            else
                newsymbolNoteHead = [newsymbolNoteHead; i pitch+1 newSymbol];
            end
        else
            %If we do not have a staffline
            if idxone(1)==6
                if abs(aux(5) - aux(6)) < spaceHeight/3
                    newsymbolNoteHead = [newsymbolNoteHead; i 1 newSymbol];
                else
                    numberledgerline = findledgerline(aux(5),aux(6),spaceHeight);
                    if size(numberledgerline,1)~=0
                        pitch = choosescale(numberledgerline);
                        newsymbolNoteHead = [newsymbolNoteHead; i pitch newSymbol];
                    else
                        newsymbolNoteHead = [newsymbolNoteHead; []];
                        return;
                    end
                end
            elseif idxone(1)==1
                if abs(aux(3) - aux(2)) < spaceHeight/3
                    newsymbolNoteHead = [newsymbolNoteHead; i 11 newSymbol];
                else
                    numberledgerline = findledgerline(aux(3),aux(2),spaceHeight);
                    if size(numberledgerline,1)~=0
                        pitch = choosescale(numberledgerline);
                        newsymbolNoteHead = [newsymbolNoteHead; i pitch newSymbol];
                    else
                        newsymbolNoteHead = [newsymbolNoteHead; []];
                        return;
                    end
                end
            else
                vl=aux(idxone(1)-1,1);
                number = find(vl == setrows(:,1));
                pitch = choosescale(number);
                newsymbolNoteHead = [newsymbolNoteHead; i pitch newSymbol];
            end
        end
    end   
else
    %Chords
    % equal rows -> overlap a staffline -> noteheads on a spaceHeight
    index = find(diff(aux1(:,1))==0);
    if isempty(index)==0
        number = find(ss(1) == setrows(:,1));
        pitch = choosescale(number);
        newsymbolNoteHead = [newsymbolNoteHead; i pitch-1 newSymbol];

        vv = abs(ss(2,1)-ss(1,1));
        % All noteheads detected
        if vv < spaceHeight + 2*lineHeight
            return
        else
            %Noteheads missed
            if vv >= 2*spaceHeight & vv < 3*spaceHeight
                newsymbolNoteHead = [newsymbolNoteHead; i pitch-3 newSymbol];
            elseif vv >= 3*spaceHeight & vv < 4*spaceHeight
                newsymbolNoteHead = [newsymbolNoteHead; i pitch-3 newSymbol; i pitch-5 newSymbol];
            elseif vv >= 4*spaceHeight & vv < 5*spaceHeight
                newsymbolNoteHead = [newsymbolNoteHead; i pitch-3 newSymbol; i pitch-5 newSymbol; i pitch-7 newSymbol];
            end
        end

    else
        % Noteheads on a staffline
        if diff(aux1(1:2,1))>spaceHeight/3 & diff(aux1(1:2,1))<=spaceHeight/2
            number = find(aux1(2) == setrows(:,1));
            pitch = choosescale(number);
            newsymbolNoteHead = [newsymbolNoteHead; i pitch newSymbol];

            vv = abs(ss(2,1)-ss(1,1));
            %The remaining noteheads
            if vv >= 2*spaceHeight & vv < 3*spaceHeight
                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol];
            elseif vv >= 3*spaceHeight & vv < 4*spaceHeight
                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol; i pitch-4 newSymbol];
            elseif vv >= 4*spaceHeight & vv < 5*spaceHeight
                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol; i pitch-4 newSymbol; i pitch-6 newSymbol];
            end

        else
            % Noteheads in a spaceheight without overlapping on a staffline
            if idxone(1)==6
                if abs(aux(end-1) - aux(end)) >= spaceHeight & abs(aux(end-1) - aux(end))< spaceHeight+2*lineHeight
                    newsymbolNoteHead = [newsymbolNoteHead; i 1 newSymbol];

                    vv = abs(ss(2,1)-ss(1,1));

                    % All noteheads detected
                    if vv < spaceHeight + 2*lineHeight
                        return
                    else
                        %The remaining noteheads
                        if vv >= 2*spaceHeight & vv < 3*spaceHeight
                            newsymbolNoteHead = [newsymbolNoteHead; i -1 newSymbol];
                        elseif vv >= 3*spaceHeight & vv < 4*spaceHeight
                            newsymbolNoteHead = [newsymbolNoteHead; i -1 newSymbol; i -3 newSymbol];
                        elseif vv >= 4*spaceHeight & vv < 5*spaceHeight
                            newsymbolNoteHead = [newsymbolNoteHead; i -1 newSymbol; i -3 newSymbol; i -5 newSymbol];
                        end
                    end

                else
                    numberledgerline = findledgerline(aux(end-1),aux(end),spaceHeight);
                    if size(numberledgerline,1)~=0
                        pitch = choosescale(numberledgerline);
                        newsymbolNoteHead = [newsymbolNoteHead; i pitch newSymbol];

                        vv = abs(ss(2,1)-ss(1,1));

                        % All noteheads detected
                        if vv < spaceHeight + 2*lineHeight
                            return
                        else
                            %The remaining noteheads
                            if vv >= 2*spaceHeight & vv < 3*spaceHeight
                                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol];
                            elseif vv >= 3*spaceHeight & vv < 4*spaceHeight
                                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol; i pitch-4 newSymbol];
                            elseif vv >= 4*spaceHeight & vv < 5*spaceHeight
                                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol; i pitch-4 newSymbol; i pitch-6 newSymbol];
                            end
                        end
                    else
                        newsymbolNoteHead = [newsymbolNoteHead; []];
                        return;
                    end
                end
            elseif idxone(1)==1
                %spaceHeight
                if abs(aux(2) - aux(1)) >= spaceHeight & abs(aux(2) - aux(1)) < spaceHeight+2*lineHeight
                    newsymbolNoteHead = [newsymbolNoteHead; i 11 newSymbol];

                    vv = abs(ss(2,1)-ss(1,1));
                    % All noteheads detected
                    if vv < spaceHeight + 2*lineHeight
                        return
                    else
                        %The remaining noteheads
                        if vv >= 2*spaceHeight & vv < 3*spaceHeight
                            newsymbolNoteHead = [newsymbolNoteHead; i 9 newSymbol];
                        elseif vv >= 3*spaceHeight & vv < 4*spaceHeight
                            newsymbolNoteHead = [newsymbolNoteHead; i 9 newSymbol; i 7 newSymbol];
                        elseif vv >= 4*spaceHeight & vv < 5*spaceHeight
                            newsymbolNoteHead = [newsymbolNoteHead; i 9 newSymbol; i 7 newSymbol; i 5 newSymbol];
                        end
                    end
                else
                    %staffLine
                    numberledgerline = findledgerline(aux(2),aux(1),spaceHeight);
                    if size(numberledgerline,1)~=0
                        pitch = choosescale(numberledgerline);
                        newsymbolNoteHead = [newsymbolNoteHead; i pitch newSymbol];

                        vv = abs(ss(2,1)-ss(1,1));
                        % All noteheads detected
                        if vv < spaceHeight + 2*lineHeight
                            return
                        else
                            %The remaining noteheads
                            if vv >= 2*spaceHeight & vv < 3*spaceHeight
                                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol];
                            elseif vv >= 3*spaceHeight & vv < 4*spaceHeight
                                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol; i pitch-4 newSymbol];
                            elseif vv >= 4*spaceHeight & vv < 5*spaceHeight
                                newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol; i pitch-4 newSymbol; i pitch-6 newSymbol];
                            end
                        end
                    else
                        newsymbolNoteHead = [newsymbolNoteHead; []];
                        return;
                    end
                end
            else
                vl=aux(idxone(1)-1,1);
                number = find(vl == setrows(:,1));
                pitch = choosescale(number);
                newsymbolNoteHead = [newsymbolNoteHead; i pitch newSymbol];

                vv = abs(ss(2,1)-ss(1,1));
                % All noteheads detected
                if vv < spaceHeight + 2*lineHeight
                    return
                else
                    %The remaining noteheads
                    if vv >= 2*spaceHeight & vv < 3*spaceHeight
                        newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol];
                    elseif vv >= 3*spaceHeight & vv < 4*spaceHeight
                        newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol; i pitch-4 newSymbol];
                    elseif vv >= 4*spaceHeight & vv < 5*spaceHeight
                        newsymbolNoteHead = [newsymbolNoteHead; i pitch-2 newSymbol; i pitch-4 newSymbol; i pitch-6 newSymbol];
                    end
                end
            end
        end
    end

end

return