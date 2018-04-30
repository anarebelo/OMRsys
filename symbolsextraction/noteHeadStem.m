function [NewnoteHead, newStem, noteHeadRejected, setnoteheadstem]=noteHeadStem(val_verifyNoteHeadStem1,val_verifyNoteHeadStem2,stem,noteHead,imgWithoutStem,flag,val_sideFlag,orderID)

NewnoteHead=[];
newStem=[];
setnoteheadstem = struct();
setnoteheadstem = setfield(setnoteheadstem, 'noteheadstem', [{}]);

noteHeadRejected=[];

for i=1:size(noteHead,1)
    n=noteHead(i,:);
    [noteHead1, st] = verifyNoteHeadStem(val_verifyNoteHeadStem1,val_verifyNoteHeadStem2, n, stem,val_sideFlag);

    if size(st,1)>1
        %Stems with only one pixel of width
        st = delStems(st);
    end

    if size(noteHead1,2)~=0
        if flag==0
            if orderID == 1
                [accept]=restricted(imgWithoutStem(noteHead1(1,1):noteHead1(1,2),noteHead1(1,3):noteHead1(1,4)));
            else
                %[accept]= restricted_second(imgWithoutStem(noteHead1(1,1):noteHead1(1,2),noteHead1(1,3):noteHead1(1,4)));
                accept = 1;
            end
            if accept == 1
                NewnoteHead=[NewnoteHead; noteHead1];
                newStem =[newStem; st];

                setnoteheadstem = setfield(setnoteheadstem, 'noteheadstem', [setnoteheadstem.noteheadstem; {noteHead1 st [] []}]);
            else
                noteHeadRejected = [noteHeadRejected; noteHead1];
            end
        else
            NewnoteHead=[NewnoteHead; noteHead1];
            newStem =[newStem; st];

            setnoteheadstem = setfield(setnoteheadstem, 'noteheadstem', [setnoteheadstem.noteheadstem; {noteHead1 st [] []}]);
        end
    end
end