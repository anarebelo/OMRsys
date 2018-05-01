function pitch = choosescale(number)

pitch = inf;
if number == 1
    pitch = 10;
elseif number == 2
    pitch = 8;
elseif number == 3
    pitch = 6;
elseif number == 4
    pitch = 4;
elseif number == 5
    pitch = 2;
end
%up ledger lines
if number == -1
    pitch = 12;
elseif number == -2
    pitch = 13;
elseif number == -3
    pitch = 14;
elseif number == -4
    pitch = 15;
elseif number == -5
    pitch = 16;
elseif number == -6
    pitch = 17;
elseif number == -7
    pitch = 18;
end
%down ledger lines
if number == 6
    pitch = 0;
elseif number == 7
    pitch = -1;
elseif number == 8
    pitch = -2;
elseif number == 9
    pitch = -3;
elseif number == 10
    pitch = -4;
elseif number == 11
    pitch = -5;
elseif number == 12
    pitch = -6;
end