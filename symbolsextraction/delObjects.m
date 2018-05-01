function img=delObjects(img,obj,flag)

if flag==0
    for j=1:size(obj,1)
        img(obj(j,1):obj(j,2),obj(j,3):obj(j,4))=1;
    end
elseif flag==1
    for j=1:size(obj.noteheadstem,1)
        nH = cell2mat(obj.noteheadstem(j,1));
        stem = cell2mat(obj.noteheadstem(j,2));
        img(nH(1):nH(2),nH(3):nH(4)) = 1;


        a = max(stem(1,3)-5,1);
        b = min(stem(1,3)+5,size(img,2));
        img(stem(1,1):stem(1,2),a:b) = 1;
    end
elseif flag==2
    for j=1:size(obj.noteheadstem,1)
        flag = cell2mat(obj.noteheadstem(j,4));
        if size(flag,1) ~= 0
            img(flag(1):flag(2),flag(3):flag(4)) = 1;
        end
    end
elseif flag==3
    for j=1:size(obj.OpenNoteheadstem,1)
        nH = cell2mat(obj.OpenNoteheadstem(j,1));
        stem = cell2mat(obj.OpenNoteheadstem(j,2));
        img(nH(1):nH(2),nH(3):nH(4)) = 1;


        a = max(stem(1,3)-5,1);
        b = min(stem(1,3)+5,size(img,2));
        img(stem(1,1):stem(1,2),a:b) = 1;
    end
end

return