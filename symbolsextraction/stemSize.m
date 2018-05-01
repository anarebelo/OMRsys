function [stemInicialRow, stemFinalRow, stemAux]=stemSize(colStem,stem,pos,p,spaceHeight)

if find(colStem==p)==1
    final=pos(find(colStem==p))-1;
    inicio=1;
else
    final=pos(find(colStem==p))-1;
    inicio=pos(find(colStem==p)-1)+2;
end
%A stem para a noteHead
stemAux=stem(inicio:final);
%As linhas iniciais onde começa a stem
stemInicialRow=stemAux(1:2:end);
%As linhas finais onde termina a stem
stemFinalRow=stemAux(2:2:end);
%Altura da stem
stemHeight=stemFinalRow-stemInicialRow;
%Encontrar as posições onde a altura da stem é superior a
%2*spaceHeight para impedir de contar barras pequenas
HH=find(stemHeight>=2*spaceHeight);
% stemHeight=stemHeight(HH);
%Fico apenas com as linhas inicias onde as alturas sao superiores
stemInicialRow=stemInicialRow(HH);
%Fico apenas com as linhas finais onde as alturas sao superiores
stemFinalRow=stemFinalRow(HH);