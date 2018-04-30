function [p]=sideFlag1(noteHead,colStem,i,val_sideFlag1)
%Procura num intervalo de [1,6] pixeis
%em que a haste possa estar afastada da cabe�a de nota
for j=1:val_sideFlag1 %6
    %D� a coluna da stem onde a igualdade for verdadeira.
    p=colStem(find((colStem-j)==noteHead(i,4)));
    if size(p,2)~=0
        return
    end
end
for j=1:round(val_sideFlag1/2) %3
    %D� a coluna da stem onde a igualdade for verdadeira.
    p=colStem(find((colStem+j)==noteHead(i,4)));
    if size(p,2)~=0
        return
    end
end