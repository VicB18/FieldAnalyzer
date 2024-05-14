function [ClusterPointX,ClusterPointY,ClusterN]=ImageClustering(A,xi,yi,Err_in,Margin_in)%A
[n,m]=size(A);
% Err_in=0.005;
C=zeros(n,m);
C(xi,yi)=1;
Visited=zeros(n,m);
ClusterPointX=zeros(n*m,1); ClusterPointY=zeros(n*m,1);
PointN=1;
ClusterPointX(PointN)=xi; ClusterPointY(PointN)=yi;
dx=[1 -1 0 0];
dy=[0 0 1 -1];
% cla; imshow(A); hold on;
while PointN>0
    xi=ClusterPointX(PointN);
    yi=ClusterPointY(PointN);
% plot(yi,xi,'*');
    if Visited(xi,yi)==1
        PointN=PointN-1;
        continue;
    end
    Visited(xi,yi)=1;
    for i=1:4
        xi1=xi+dx(i);
        yi1=yi+dy(i);
        if xi1<n-Margin_in && xi1>Margin_in && yi1<m-Margin_in && yi1>Margin_in
            if C(xi1,yi1)==0 && A(xi1,yi1)~=0 && abs(A(xi1,yi1)-A(xi,yi))<Err_in% && abs(A(xi1,yi1)-Zobst(xi1,yi1))>0.05
                C(xi1,yi1)=1;
                PointN=PointN+1;
                ClusterPointX(PointN)=xi1; ClusterPointY(PointN)=yi1;
%                 plot(yi1,xi1,'.');
            end
        end
    end
end
ClusterN=0;
for i=1:n
    for j=1:m
        if C(i,j)==0
            A(i,j)=0;
        else
            ClusterN=ClusterN+1;
            ClusterPointX(ClusterN)=i; ClusterPointY(ClusterN)=j;
% plot(j,i,'o');
        end
    end
end
