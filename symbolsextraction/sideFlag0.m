function [p]=sideFlag0(noteHead,colStem,i,val_sideFlag0)
%Procura num intervalo de [1,6] pixeis
%em que a haste possa estar afastada da cabeça de nota
for j=1:val_sideFlag0 %6
    %Dá a coluna da stem onde a igualdade for verdadeira.
    p=colStem(find((colStem+j)==noteHead(i,3)));
    if size(p,2)~=0
        return
    end
end
for j=1:round(val_sideFlag0/2)
    %Dá a coluna da stem onde a igualdade for verdadeira.
    p=colStem(find((colStem-j)==noteHead(i,3)));
    if size(p,2)~=0
        return
    end
end