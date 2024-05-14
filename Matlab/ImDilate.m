function A1=ImDilate(A,r)
A1=A;
[n,m]=size(A);
pInd=zeros(r*r,2);
pIndN=0;
for i=-r:r
    for j=-r:r
        if i*i+j*j<=r*r
            pIndN=pIndN+1;
            pInd(pIndN,1)=i;
            pInd(pIndN,2)=j;
        end
    end
end

for i=r:n-r
    for j=r:m-r
        if A(i,j)~=0 && (A(i+1,j)==0 || A(i-1,j)==0 || A(i,j+1)==0 || A(i,j-1)==0)
            for k=1:pIndN
                A1(i+pInd(k,1),j+pInd(k,2))=1;
            end
        end
    end
end
            