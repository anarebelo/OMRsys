function [image,threshold]=joinsymbols(img,spaceHeight)


imgInput = img;
img = 1-img;
L = bwlabel(img);
s  = regionprops(L, 'BoundingBox');
BoundingBoxs = round(cat(1, s.BoundingBox));

%Join the objects
if size(BoundingBoxs,1) > 1 && size(BoundingBoxs,1) < 5
%     symbol1 = [BoundingBoxs(1,2) BoundingBoxs(1,4) BoundingBoxs(1,1) BoundingBoxs(1,3)];
    threshold = 1;
    while size(BoundingBoxs,1) > 1
        se = strel('disk',threshold-1);
        openBW = imopen(imgInput,se);
        %                 figure, imshow(openBW)

        L = bwlabel(1-openBW);
        s  = regionprops(L, 'BoundingBox');
        BoundingBoxs = round(cat(1, s.BoundingBox));
        %                 size(BoundingBoxs,1)
        %                 pause
        %                 close all

        threshold = threshold+1;
        if threshold > spaceHeight
            image = imgInput;
            return
        end
    end
    if size(BoundingBoxs,1) == 1
        image = openBW;
    end
else
    threshold = 1;
    image = imgInput;
end

