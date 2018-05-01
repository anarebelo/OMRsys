function csv = search_for(name,names,type)

csv = [];
if type == 1 
    for i=1:length(names)
        aux = names{i};
        if size(aux,2) <= 4
            continue
        end
        nameCSV = aux(1:end-4);
        format = aux(end-3:end);
        
        %     [nameCSV format] = strtok(names{i},'.');
        
        if (strcmp(format,'.csv') == 1 )
            if type == 0
                nameCSV = strtok(nameCSV,'_');
            elseif type==1
                name_all = [];
                remain = nameCSV;
                while true
                    [nameCSV remain]= strtok(remain,'-');
                    if isempty(remain), break; end
                    name_all = [name_all '-' nameCSV];
                end
                nameCSV = name_all(2:end);
            end
            if (strcmp(nameCSV,name) == 1)
                csv = names{i};
                return;
            end
        elseif (strcmp(format,'.txt') == 1 )
            if type == 0
                nameCSV = strtok(nameCSV,'_');
            elseif type==1
                name_all = [];
                remain = nameCSV;
                while true
                    [nameCSV remain]= strtok(remain,'-');
                    if isempty(remain), break; end
                    name_all = [name_all '-' nameCSV];
                end
                nameCSV = name_all(2:end);
            end
            if (strcmp(nameCSV,name) == 1)
                csv = names{i};
                return;
            end
        end
    end
elseif type == 2
    for i=1:length(names)
        aux = names{i};
        idx = strfind(aux, '-');
        
        N = aux(1:idx-1);
        if strcmp(name,N)
          csv = aux;
          return
        end  
    end
else
    csv = [];
    for i=1:length(names)
        aux = names{i};
        idx = strfind(aux, '-');
        
        N = aux(1:idx-1);
        if strcmp(name,N)
          csv = [csv i];
        end  
    end
end

return
