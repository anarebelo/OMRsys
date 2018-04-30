function [object]=BFSnoteheads(P, w, h,imageWithoutLines)

global visitedMatrixObjects

object=[];
Q=[P(1) P(2)];
z=size(Q,2);
hit = 0;
while z~=0
    hit = hit+1;
    M=Q(1:2);

    if z >= 4
        Q=Q(3:z);
        k = size(Q,2)+1;
    else
        %Avoid create zero elements
        k = 1;
        Q = [];
    end

    if visitedMatrixObjects(M(1),M(2))==1
        %N
        if M(1)-1>=1 & imageWithoutLines(M(1)-1,M(2))==0
            if visitedMatrixObjects(M(1)-1,M(2)) ==1
                Q(k) = M(1)-1;
                k=k+1;
                Q(k) = M(2);
                k=k+1;
            end
        end

        %W
        if M(2)-1>=1 & imageWithoutLines(M(1),M(2)-1)==0
            if visitedMatrixObjects(M(1),M(2)-1) == 1
                Q(k) = M(1);
                k=k+1;
                Q(k) =  M(2)-1;
                k=k+1;
            end
        end

        %S
        if M(1)+1<=h & imageWithoutLines(M(1)+1,M(2))==0
            if visitedMatrixObjects(M(1)+1,M(2)) ==1
                Q(k) = M(1)+1;
                k=k+1;
                Q(k) = M(2);
                k=k+1;
            end
        end

        %E
        if M(2)+1<=w & imageWithoutLines(M(1),M(2)+1)==0
            if visitedMatrixObjects(M(1),M(2)+1) == 1
                Q(k) = M(1);
                k=k+1;
                Q(k) = M(2)+1;
                k=k+1;
            end
        end

        %NW
        if M(1)-1>=1 & M(2)-1>=1 & imageWithoutLines(M(1)-1,M(2)-1)==0
            if visitedMatrixObjects(M(1)-1,M(2)-1) == 1
                Q(k) = M(1)-1;
                k=k+1;
                Q(k) = M(2)-1;
                k=k+1;
            end
        end

        %NE
        if M(1)-1>=1 & M(2)+1<=w & imageWithoutLines(M(1)-1,M(2)+1)==0
            if visitedMatrixObjects(M(1)-1,M(2)+1) ==1
                Q(k) = M(1)-1;
                k=k+1;
                Q(k) = M(2)+1;
                k=k+1;
            end
        end

        %SW
        if M(1)+1<=h & M(2)-1>=1 & imageWithoutLines(M(1)+1,M(2)-1)==0
            if visitedMatrixObjects(M(1)+1,M(2)-1) ==1
                Q(k) =  M(1)+1;
                k=k+1;
                Q(k) = M(2)-1;
                k=k+1;
            end
        end

        %SE
        if M(1)+1<=h & M(2)+1<=w & imageWithoutLines(M(1)+1,M(2)+1)==0
            if visitedMatrixObjects(M(1)+1,M(2)+1) == 1
                Q(k) = M(1)+1;
                k=k+1;
                Q(k) = M(2)+1;
                k=k+1;
            end
        end
        object=[object M(1) M(2)];
    end
    %Visited
    visitedMatrixObjects( M(1), M(2) ) = 0;
    z=size(Q,2);
end

if hit == 1
    object = [];
end
return