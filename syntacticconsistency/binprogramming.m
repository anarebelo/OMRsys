function newx = binprogramming(P,alpha, N, D)

f = -P(:)';

%subject to
[n, k] = size(P);

%each symbol belongs to only one class
b = ones(n,1);
A = zeros(n,n*k);
for i=1:n
    A(i,i:n:end) = 1;
end

%accents
b1 = 0;
A1 = zeros(1,n*k);
A1(n+1:n+n) = 1;
A1(2*n+1:18*n) = -1;

%accidentals
b2 = ones(n,1);
A2 = zeros(n-1,n*k);
for i=1:n
    A2(i,i) = 1;
    for j=3:18
        A2(i,(j-1)*n+i+1) = -1;
    end
end

A = [A; A1; A2];
b = [b; b1; b2];


beq = N;
Aeq = zeros(1,n*k);
previous = 0;
for i=1:k
    Aeq(1,previous+1:previous+n) = D*alpha(i);
    previous = previous+n;
end

[x,fval,exitflag] = bintprog(f,A,b,Aeq,beq);
if exitflag == inf
    newx = [];
else
    newx = reshape(x,n,k);
end
