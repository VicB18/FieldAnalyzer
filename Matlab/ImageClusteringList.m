function [ListX,ListY,ListBeg,ListEnd,ListN]=ImageClusteringList(A,ObjectColor,MinSizeObject,Draw)
[n,m]=size(A);
ListX=zeros(n*m,1); ListY=zeros(n*m,1);
ListBeg=zeros(n*m,1); ListEnd=zeros(n*m,1);
if Draw
    figure; imshow(A); hold on;
end

ListN=0;
ListBeg(1)=1;
for i=1:n
    for j=1:m
        if A(i,j)==ObjectColor
            [ClusterPointX,ClusterPointY,ClusterN]=ImageClustering(A,i,j,1,1);
            if ClusterN>MinSizeObject
                ListN=ListN+1;
                for k=1:ClusterN
                    A(ClusterPointX(k),ClusterPointY(k))=1-ObjectColor;
                    ListX(ListBeg(ListN)+k-1)=ClusterPointX(k);
                    ListY(ListBeg(ListN)+k-1)=ClusterPointY(k);
                end
                ListEnd(ListN)=ListBeg(ListN)+k-1;
                ListBeg(ListN+1)=ListBeg(ListN)+k;
                if Draw
                    plot(ClusterPointY,ClusterPointX,'.');
                end
            end
        end
    end
end
