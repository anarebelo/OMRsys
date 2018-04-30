function notes_cd = read_confidencedegree(degree)

%% -----------------------------Read confidence degree data----------------------------

notes_cd               = [];
% degree.clef            = [];
% degree.TimeSignatureN  = [];
% degree.TimeSignatureL  = [];
% degree.barlines        = [];
% degree.beams           = [];
% degree_rests           = [];
% degree_keySignature    = [];
% degree_accidentals     = [];
% degree_semibreve_breve = [];
% degree_dots            = [];
% degree_accents         = [];
% degree_whole           = [];
% degree_half            = [];
% degree_doublewhole     = [];
% degree_notes           = [];
% degree_opennotes       = [];
field_names = fieldnames(degree);
for i=1:size(field_names,1)
    a        = field_names{i};
    name     = field_names(i);
    
    if strcmp('clef',name)
        degree_clef = getfield(degree,a);
        if size(degree_clef,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_clef(:,1)) repmat(1,size(degree_clef,1),1)];
        end
    elseif strcmp('rests',name)
        degree_rests = getfield(degree,a);
        if size(degree_rests,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_rests(:,1)) repmat(2,size(degree_rests,1),1)];
        end
    elseif strcmp('keySignature',name)
        degree_keySignature = getfield(degree,a);
        if size(degree_keySignature,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_keySignature(:,1)) repmat(3,size(degree_keySignature,1),1)];
        end
    elseif strcmp('accidentals',name)
        degree_accidentals = getfield(degree,a);
        if size(degree_accidentals,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_accidentals(:,1)) repmat(4,size(degree_accidentals,1),1)];
        end
    elseif strcmp('TimeSignatureN',name)
        degree_TimeSignatureN = getfield(degree,a);
        if size(degree_TimeSignatureN,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_TimeSignatureN(:,1)) repmat(5,size(degree_TimeSignatureN,1),1)];
        end
    elseif strcmp('TimeSignatureL',name)
        degree_TimeSignatureL = getfield(degree,a);
        if size(degree_TimeSignatureL,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_TimeSignatureL(:,1)) repmat(6,size(degree_TimeSignatureL,1),1)];
        end
    elseif strcmp('semibreve_breve',name)
        degree_semibreve_breve = getfield(degree,a);
        if size(degree_semibreve_breve,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_semibreve_breve(:,1)) repmat(7,size(degree_semibreve_breve,1),1)];
        end
    elseif strcmp('dots',name)
        degree_dots = getfield(degree,a);
        if size(degree_dots,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_dots(:,1)) repmat(8,size(degree_dots,1),1)];
        end
    elseif strcmp('accents',name)
        degree_accents = getfield(degree,a);
        if size(degree_accents,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_accents(:,1)) repmat(9,size(degree_accents,1),1)];
        end
    elseif strcmp('barlines',name)
        degree_barlines = getfield(degree,a);
        if size(degree_barlines,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_barlines(:,1)) repmat(10,size(degree_barlines,1),1)];
        end
    elseif strcmp('wholerests',name)
        degree_whole = getfield(degree,a);
        if size(degree_whole,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_whole(:,1)) repmat(11,size(degree_whole,1),1)];
        end
    elseif strcmp('halfrests',name)
        degree_half = getfield(degree,a);
        if size(degree_half,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_half(:,1)) repmat(12,size(degree_half,1),1)];
        end
    elseif strcmp('doublewholerests',name)
        degree_doublewhole = getfield(degree,a);
        if size(degree_doublewhole,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_doublewhole(:,1)) repmat(13,size(degree_doublewhole,1),1)];
        end
    elseif strcmp('beams',name)
        degree_beams = getfield(degree,a);
        if size(degree_beams,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_beams(:,1)) repmat(14,size(degree_beams,1),1)];
        end
    elseif strcmp('noteheads',name)
        degree_notes = getfield(degree,a);
        if size(degree_notes,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_notes(:,1)) repmat(15,size(degree_notes,1),1)];
        end
    elseif strcmp('opennoteheads',name)
        degree_opennotes = getfield(degree,a);
        if size(degree_opennotes,1)~=0
            notes_cd = [notes_cd; cell2mat(degree_opennotes(:,1)) repmat(16,size(degree_opennotes,1),1)];
        end
    end
end