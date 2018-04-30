function mat = search_for_mat(name,names,type)
mat = [];

[name ~]= strtok(name,'-');

for i=1:length(names)  
    aux = names{i};
    nameMAT = aux(1:end-4);
    format = aux(end-3:end);
    
%     [nameCSV format] = strtok(names{i},'.');
    
    if (strcmp(format,'.mat') == 1 )
        if type == 0
            nameMAT = strtok(nameMAT,'_');
        elseif type==1
            name_all = [];
            remain = nameMAT;
            while true
                [nameMAT remain]= strtok(remain,'-');
                if isempty(remain), break; end
                name_all = [name_all '-' nameMAT];
            end
            nameMAT = name_all(2:end);
        elseif type==2
            [nameMAT1 ~]= strtok(nameMAT,'-');
            if strcmp(name,nameMAT1)
               mat = strcat(nameMAT,format);
               return 
            end
        end
        if (strcmp(nameMAT,name) == 1)
            mat = names{i};
            return;
        end
    end
    
end
return