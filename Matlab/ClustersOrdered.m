function [Outlyer]=ClustersOrdered(X,res,WindowSize)%ClusterInd,ClusterN,
N=length(X);
ClusterN=1;
% ClusterInd=zeros(10,1);
WindowSize=floor(WindowSize/2);
w=-WindowSize:WindowSize;
ClusterNo=zeros(length(X),1);
ClusterMed=zeros(length(X),1);
Outlyer=zeros(length(X),1);

% cla; hold on; plot(1:N,X,'.'); 

i=1;
m=median(X(i+(0:WindowSize)));
ClusterMed(i)=m;
ClusterNo(i)=ClusterN;

for i=2:WindowSize
%     plot(i,X(i),'ro'); 
    m=median(X(1:(i+WindowSize)));
    if abs(ClusterMed(i-1)-m)>res
        ClusterN=ClusterN+1;
    end
    if abs(X(i)-m)>res
        Outlyer(i)=1;
%         plot(i,X(i),'ro'); 
    end
    ClusterMed(i)=m;
    ClusterNo(i)=ClusterN;
%     plot(i,ClusterMed(i),'g*'); 
end

% c=rand(1,3);
for i=(WindowSize+1):(N-WindowSize)%(WindowSize+1):(N-WindowSize)
%     plot(i,X(i),'ro'); 
    m=median(X(i+w));
    if abs(ClusterMed(i-1)-m)>res
        ClusterN=ClusterN+1;
%         c=rand(1,3);
    end
    if abs(X(i)-m)>res
        Outlyer(i)=1;
%         plot(i,X(i),'ro'); 
    end
    ClusterMed(i)=m;
    ClusterNo(i)=ClusterN;
%     plot(i,ClusterMed(i),'*','Color',c); 
end

for i=(N-WindowSize):N
%     plot(i,X(i),'ro'); 
    m=median(X((i-WindowSize):N));
    if abs(ClusterMed(i-1)-m)>res
        ClusterN=ClusterN+1;
    end
    if abs(X(i)-m)>res
        Outlyer(i)=1;
%         plot(i,X(i),'ro'); 
    end
    ClusterMed(i)=m;
    ClusterNo(i)=ClusterN;
%     plot(i,ClusterMed(i),'g*'); 
end
