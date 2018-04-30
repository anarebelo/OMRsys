function numberofsigns = countnumberofsigns(typeofsymbol,denominator,ID)

%Rests1ID          = 01
%Rests2ID          = 02
%WholeRestID       = 03
%HalfRestID        = 04
%DoubleWholeRestID = 05
%DotsID            = 11
%MinimID           = 21
%NotesFlagsID      = 22
%QuarterID         = 23

numberofsigns = 0;
if size(typeofsymbol,1) ~= 0
    if ID == 01
        numberofsigns = length(find(typeofsymbol == 17))*(denominator/4);
    elseif ID == 02    
        numberofsigns = length(find(typeofsymbol == 1))*(denominator/32) + length(find(typeofsymbol == 4))*(denominator/64) + ...
            length(find(typeofsymbol == 5))*(denominator/8) + length(find(typeofsymbol == 6))*(denominator/16);
    elseif ID == 03
        numberofsigns = length(find(typeofsymbol == 5))*denominator;
    elseif ID == 04
        numberofsigns = length(find(typeofsymbol == 5))*(denominator/2); 
    elseif ID == 05
        numberofsigns = length(find(typeofsymbol == 3))*denominator;    
    elseif ID == 11
        numberofsigns = length(find(typeofsymbol == 1))*(denominator/4)*0.5 + length(find(typeofsymbol == 2))*(denominator/8)*0.5 + ...
            length(find(typeofsymbol == 3))*(denominator/16)*0.5 + length(find(typeofsymbol == 4))*(denominator/32)*0.5 + ...
            length(find(typeofsymbol == 5))*(denominator/64)*0.5 + length(find(typeofsymbol == 6))*denominator*0.5 + ...
            length(find(typeofsymbol == 7))*denominator*0.5 + length(find(typeofsymbol == 8))*(denominator/2)*0.5;  
    elseif ID == 0305
        numberofsigns = length(find(typeofsymbol == 5))*denominator + length(find(typeofsymbol == 3))*denominator;
    elseif ID == 21
        numberofsigns = length(find(typeofsymbol == 15))*(denominator/2);
    elseif ID == 22
        numberofsigns = length(find(typeofsymbol == 1))*(denominator/32) + length(find(typeofsymbol == 2))*(denominator/64) + ...
            length(find(typeofsymbol == 3))*(denominator/8) + length(find(typeofsymbol == 4))*(denominator/16);
    elseif ID == 23
        numberofsigns = length(find(typeofsymbol == 13))*(denominator/4);    
    end
else
    return
end