function symbol = extractPointsRest(image,threshold,spaceHeight)


symbol = 0;
se = strel('disk',threshold);
openBW = imopen(image,se);
% figure, imshow(openBW)
% imwrite(openBW,'openBW.png','png')


BW3 = bwmorph(1-openBW,'thin',Inf);
% figure, imshow(BW3)
% imwrite(BW3,'thinObj.png','png')

%Numero de pontos finais
if length(find(BW3 == 0))== 0
    return
end
terminating_pts = find_skel_ends(BW3);

if size(terminating_pts,1) > 6
    return
end

[M, N] = size(image);

% img = 1-BW3;
% for i=1:size(terminating_pts,1)
%     img(terminating_pts(i,2),terminating_pts(i,1)) = 0.5;
% end
% % figure, imshow(img)
% imwrite(img,'terminatingPoints.png','png')


if size(terminating_pts,1) ~= 0
    %Divisão em duas partes
    if size(terminating_pts,1) == 2
        numberOfSplits = 2;
        %Divisão da imagem em 2 partes
        numberofpts = 0;
        rowStep = round(size(BW3,1)/2);
        for i=1:rowStep:size(BW3,1)
            a = min(i+rowStep-1,size(BW3,1));
            img = BW3(i:a,:);
            if size(img,1) < 2
                return
            end
            pts = find_skel_ends(img);
            if size(pts,1) ~= 0
                ptsScaled = [pts(:,1) (pts(:,2) + i) - 1];
                extraPts = setdiff(ptsScaled, terminating_pts, 'rows');
                numberofpts = numberofpts + (size(ptsScaled,1) - size(extraPts,1));
            end
        end
    else
        %Divisão da imagem em 4 partes
        numberOfSplits = 4;
        numberofpts = 0;
        rowStep = round(size(BW3,1)/2);
        columnStep = round(size(BW3,2)/2);
        for i=1:rowStep:size(BW3,1)
            for j=1:columnStep:size(BW3,2)
                a = min(i+rowStep-1,size(BW3,1));
                b = min(j+columnStep-1,size(BW3,2));
                img = BW3(i:a,j:b);
                %             figure, imshow(img)
                pts = find_skel_ends(img);
                if size(pts,1) ~= 0
                    ptsScaled = [(pts(:,1) + j) - 1 (pts(:,2) + i) - 1];
                    extraPts = setdiff(ptsScaled, terminating_pts, 'rows');

                    numberofpts = numberofpts + (size(ptsScaled,1) - size(extraPts,1));
                end

                %             img = 1-BW3;
                %             for k=1:size(ptsScaled,1)
                %                 img(ptsScaled(k,2),ptsScaled(k,1)) = 0.5;
                %             end
                %             figure, imshow(img)
                %             pause
            end
        end
    end

    if numberofpts == size(terminating_pts,1)
        %First verification
        %Number of black runs
        %     figure, imshow(1-BW3')
        [runsblack]=numberBlackRuns(1-BW3',spaceHeight);
        if runsblack <=2
            %Second verification
            if numberOfSplits == 4
                columns = terminating_pts(:,1);
                rows = terminating_pts(:,2);

                auxDiff = diff(columns);
                idx = find(auxDiff==0);

                if size(idx,1) == 1
                    IDX = {};
                    IDX = [IDX idx(1)];
                elseif size(idx,1) == 0
                    IDX = {};
                else
                    idxidx = [];
                    IDX = {};
                    flag = -1;
                    for i=1:size(idx,1)-1
                        if idx(i+1) == idx(i)+1
                            idxidx=[idxidx idx(i) idx(i+1)];
                            flag = 1;
                        else
                            if flag == 1
                                IDX = [IDX idxidx];
                                flag = 0;
                            else
                                IDX = [IDX idx(i)];
                                flag = 2;
                            end
                            idxidx=[];
                        end
                        if i == size(idx,1)-1
                            if flag == 1
                                IDX = [IDX idxidx];
                            elseif flag == 0
                                IDX = [IDX idx(size(idx,1))];
                            elseif flag == 2
                                IDX = [IDX idx(size(idx,1))];
                            end
                        end

                    end
                end
                count = 0;
                %Compare the values
                if size(IDX,1) ~=0
                    for i=1:size(IDX,2)
                        A = cell2mat(IDX(i));
                        first = min(A);
                        last  = max(A);
                        %                     rows(last+1) - round(M/2)
                        %                     rows(first) - round(M/2)
                        %                     (rows(last+1)-rows(first))

                        if (rows(last+1) - round(M/2)) < spaceHeight && (rows(last+1) - round(M/2))>0 && (round(M/2) - rows(first)) < spaceHeight && (round(M/2) - rows(first))>0 && (rows(last+1)-rows(first))>spaceHeight
                            return
                        else
                            %Não entra nenhuma vez no passo anterior logo todos
                            %os valores com as colunas iguais não satisfazem as
                            %condições anteriores. Pode ser símbolo.
                            count = count+1;
                        end
                    end
                else
                    %Simbolo
                    symbol = 1;
                end
                if count == size(IDX,2)
                    symbol = 1;
                end
            else
                %Simbolo
                symbol = 1;
            end
        end
    end
end