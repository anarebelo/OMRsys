function filename = assign_name_file_second(name,number,flag)

if flag == 0 
    name1 = sprintf('classes%d',number);
    filename = strcat('symbols_detected_secondary\', name1, '\', name);

    % %%Folders
    % If the folder exist it is necessary to remove it before create it again
    if isdir(filename) == 1
        rmdir(filename,'s')
        mkdir(filename)
        mkdir(strcat(filename,'\beams'))
        mkdir(strcat(filename,'\noteheads'))
        mkdir(strcat(filename,'\accidentals'))
        mkdir(strcat(filename,'\openNoteheads'))
        mkdir(strcat(filename,'\openNoteheadsI'))
        mkdir(strcat(filename,'\clefs'))
        mkdir(strcat(filename,'\keySignature'))
        mkdir(strcat(filename,'\dots'))
        mkdir(strcat(filename,'\accents'))
        mkdir(strcat(filename,'\TimeSignatureN'))
        mkdir(strcat(filename,'\TimeSignatureL'))
        mkdir(strcat(filename,'\rests'))
        mkdir(strcat(filename,'\wholerests'))
        mkdir(strcat(filename,'\halfrests'))
        mkdir(strcat(filename,'\doublewholerests'))
        mkdir(strcat(filename,'\barlines'))
    else
        mkdir(filename)
        mkdir(strcat(filename,'\beams'))
        mkdir(strcat(filename,'\noteheads'))
        mkdir(strcat(filename,'\accidentals'))
        mkdir(strcat(filename,'\openNoteheads'))
        mkdir(strcat(filename,'\openNoteheadsI'))
        mkdir(strcat(filename,'\clefs'))
        mkdir(strcat(filename,'\keySignature'))
        mkdir(strcat(filename,'\dots'))
        mkdir(strcat(filename,'\accents'))
        mkdir(strcat(filename,'\TimeSignatureN'))
        mkdir(strcat(filename,'\TimeSignatureL'))
        mkdir(strcat(filename,'\rests'))
        mkdir(strcat(filename,'\wholerests'))
        mkdir(strcat(filename,'\halfrests'))
        mkdir(strcat(filename,'\doublewholerests'))
        mkdir(strcat(filename,'\barlines'))
    end
else   
    %The second time
    %if the folder doesn't exist then we will create it
    name1 = sprintf('classes%d',number);
    filename = strcat('symbols_detected_secondary\', name1, '\', name);
    if isdir(filename) == 0
        mkdir(filename)
        mkdir(strcat(filename,'\beams'))
        mkdir(strcat(filename,'\noteheads'))
        mkdir(strcat(filename,'\accidentals'))
        mkdir(strcat(filename,'\openNoteheads'))
        mkdir(strcat(filename,'\openNoteheadsI'))
        mkdir(strcat(filename,'\clefs'))
        mkdir(strcat(filename,'\keySignature'))
        mkdir(strcat(filename,'\dots'))
        mkdir(strcat(filename,'\accents'))
        mkdir(strcat(filename,'\TimeSignatureN'))
        mkdir(strcat(filename,'\TimeSignatureL'))
        mkdir(strcat(filename,'\rests'))
        mkdir(strcat(filename,'\wholerests'))
        mkdir(strcat(filename,'\halfrests'))
        mkdir(strcat(filename,'\doublewholerests'))
        mkdir(strcat(filename,'\barlines'))
    end
end
