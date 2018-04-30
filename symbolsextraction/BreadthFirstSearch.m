function [object]=BreadthFirstSearch(P, w, h, imageWithoutLines,threshold)

global visitedMatrix

object=[];
% Q[y x N S E W NE NW SE SW]
Q=[P(1) P(2) 0 0 0 0 0 0 0 0];
z=size(Q,2);
% threshold=3;

while z~=0
    M=Q(1:10);
    if z >= 11
        Q=Q(11:z);
        k = size(Q,2)+1;
    else
        %Avoid create zero elements
        k = 1;
        Q = [];
    end

    if visitedMatrix(M(1),M(2))==1
        %N
        if M(1)-1>=1 & imageWithoutLines(M(1)-1,M(2))==0
            if visitedMatrix(M(1)-1,M(2)) ==1
                Q(k)        = M(1)-1;
                Q(k+1)      = M(2);
                Q(k+2)      = 0;
                Q(k+3:k+9)  = M(4:10);
                k=k+10;
            end
        elseif M(1)-1>=1 & imageWithoutLines(M(1)-1,M(2))==1 & M(3)<threshold
            if visitedMatrix(M(1)-1,M(2)) ==1
                Q(k)        = M(1)-1;
                Q(k+1)      = M(2);
                Q(k+2)      = M(3)+1;
                Q(k+3:k+9)  = M(4:10);
                k=k+10;
            end
        end

        %W
        if M(2)-1>=1 & imageWithoutLines(M(1),M(2)-1)==0
            if visitedMatrix(M(1),M(2)-1) == 1
                Q(k)       = M(1);
                Q(k+1)     = M(2)-1;
                Q(k+2:k+4) = M(3:5);
                Q(k+5)     = 0;
                Q(k+6:k+9) = M(7:10);
                k=k+10;
            end
        elseif M(2)-1>=1 & imageWithoutLines(M(1),M(2)-1)==1 & M(6)<threshold
            if visitedMatrix(M(1),M(2)-1) == 1
                Q(k)       = M(1);
                Q(k+1)     = M(2)-1;
                Q(k+2:k+4) = M(3:5);
                Q(k+5)     = M(6)+1;
                Q(k+6:k+9) = M(7:10);
                k = k +10;
            end
        end

        %S
        if M(1)+1<=h & imageWithoutLines(M(1)+1,M(2))==0
            if visitedMatrix(M(1)+1,M(2)) ==1
                Q(k) = M(1)+1;
                Q(k+1) = M(2);
                Q(k+2) = M(3);
                Q(k+3) = 0;
                Q(k+4:k+9) = M(5:10);
                k=k+10;
            end
        elseif M(1)+1<=h & imageWithoutLines(M(1)+1,M(2))==1 & M(4)<threshold
            if visitedMatrix(M(1)+1,M(2)) ==1
                Q(k)   = M(1)+1;
                Q(k+1) = M(2);
                Q(k+2) = M(3);
                Q(k+3) = M(4)+1;
                Q(k+4:k+9) = M(5:10);
                k=k+10;
            end
        end

        %E
        if M(2)+1<=w & imageWithoutLines(M(1),M(2)+1)==0
            if visitedMatrix(M(1),M(2)+1) == 1
                Q(k)       = M(1);
                Q(k+1)     = M(2)+1;
                Q(k+2:k+3) = M(3:4);
                Q(k+4)     = 0;
                Q(k+5:k+9) = M(6:10);
                k=k+10;
            end
        elseif M(2)+1<=w & imageWithoutLines(M(1),M(2)+1)==1 & M(5)<threshold
            if visitedMatrix(M(1),M(2)+1) == 1
                Q(k)       = M(1);
                Q(k+1)     = M(2)+1;
                Q(k+2:k+3) = M(3:4);
                Q(k+4)     = M(5)+1;
                Q(k+5:k+9) = M(6:10);
                k=k+10;
            end
        end
        object=[object M(1) M(2)];
    end
    %Visited
    visitedMatrix( M(1), M(2) ) = 0;
    z=size(Q,2);
end

return