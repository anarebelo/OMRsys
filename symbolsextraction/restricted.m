function [accept]=restricted(a)

%Para cada linha conta as sequências de pixeis brancos
matdiff=[];
for j = 2:size(a,1)-1
    k = find(a(j,:) == 1);
    count = 1;
    c=1;
    flag = 0;
    %Não aceder a matrizes com elementos não definidos
    if isempty(k) == 0
        for i = 1: length(k)-1
            if k(i)+1 == k(i+1)
                count = count+1;
                %Para o caso da contagem ter acabado e termos chegado ao
                %fim da linha
                if i == length(k)-1
                    flag = 1;
                    matdiff(j,c) = count;
                    c = c+1;
                end
            else
                matdiff(j,c) = count;
                c = c+1;
                count = 1;
            end
        end
        %Um elemento na ultima coluna e ainda não foi contabilizado
        if k(length(k)) ~= 0 && flag ~= 1
            matdiff(j,c) = 1;
        end
    end
end

threshold = 0.60;
height = size(a,1);
width = size(a,2);
% accept
% = 1 -> aceita
% = 0 -> rejeita
accept = 1;
flag2 = 0;
for i = 3: size(matdiff,1)-2
    for j = 1: size(matdiff,2)
        %Verifica se o numero de pixeis brancos é maior do que 60% da
        %largura da imagem
        if ( matdiff(i,j) ~= 0 && ((matdiff(i,j)/width) > threshold ))
            flag2 = 1;
            accept = 0;
            break;
        end
    end
end

%Verificar se existem muitos pixeis brancos por toda a imagem
values = 0;
for i=1:size(matdiff,2)-1
    values(i) = length(find(matdiff(:,i) > width/4));
end
v = max(values);
if v > height/2
    accept = 0;
    flag2 = 0;
end


%Para o caso da nota ter sido dada como inválida vamos dar uma segunda
%hipotese de remover ou nao a nota
%Mais detalhadamente esta condição serve para detectar acima ou baixo da pauta dadas
%anteriormente como não sendo uma cabeça de nota
if (flag2 == 1)
    if ( length(find(a(:,1)==0))/height <= 0.25 || length(find(a(:,size(a,2))==0))/height <= 0.25 || length(find(a(1,:)==0))/height <= 0.25 || length(find(a(size(a,1),:)==0))/height <= 0.25 )
        accept = 1;
    end
end