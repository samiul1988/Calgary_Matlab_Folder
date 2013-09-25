function b=reduce3Dmatrix(a)
% b=0;
for i=1:size(a,3)
    temp=reduce2Dmat(a(:,:,i));
    b(:,:,i)=temp;
end

%%
function b=reduce2Dmat(a)

m=1;n=1;
b=0;
for i=1:size(a,1)
    for j=1:size(a,2)
        if a(i,j)~=0
            b(m,n)=a(i,j);
            n=n+1;
        end
    end
    if any(a(i,:))
        m=m+1;
        n=1;
    end
end

