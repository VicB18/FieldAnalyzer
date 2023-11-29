function [PM,MinClusterN,MinClusterInd,Wmin]=KMeansClustering_Point(P,k,sigma_k,Draw)%InitGuess,InitGuessN,%sigma_k - coefficient for the std
[N,m]=size(P);
ClusterInd=zeros(k,N); ClusterN=zeros(k,1);
Wmin=zeros(k,1)+10^10;
if k==1
    
end
if N<=k
    PM(1:N,:)=P; PM(N+1:k)=P(1,:)'*ones(1,k-N);
    MinClusterInd(:,1)=1:k;
    MinClusterN=ones(k,1);
    return;
end

InitGuessN=prod((N-k+1):N)/prod(2:k);
P1=P; N1=N;
while InitGuessN>10000
    dmin=1000;
    for i=1:N1-1
        D=sqrt((P1(i,1)-P1((i+1):N1,1)).^2+(P1(i,2)-P1((i+1):N1,2)).^2+(P1(i,3)-P1((i+1):N1,3)).^2);
        [d,j]=min(D);
            if d<dmin
                dmin=d;
                imin=i;
                jmin=j+i;
            end
    end
    
    p=(P1(imin,:)+P1(jmin,:))/2;
    P1(imin,:)=p;
    P1(jmin,:)=P1(N1,:);
    N1=N1-1;

    InitGuessN=prod((N1-k+1):N1)/prod(2:k);
end
InitGuess=nchoosek(1:N1,k);%all composition of 1:k
% plot3(P(:,1),P(:,2),P(:,3),'.');
% hold on;
% plot3(P1(1:N1,1),P1(1:N1,2),P1(1:N1,3),'or');

Replace(N1,1)=0;
for i=1:N1
    dmin=1000;
    for j=1:N
        d=sqrt(sum((P1(i,:)-P(j,:)).^2));
        if d<dmin
            dmin=d;
            jmin=j;
        end
    end
    Replace(i)=jmin;
%     plot3(P(jmin,1),P(jmin,2),P(jmin,3),'gx');
end
for i=1:InitGuessN
    for j=1:k
        InitGuess(i,j)=Replace(InitGuess(i,j));
    end
end

for InitGuess_i=1:InitGuessN
    %initial guess
    u=InitGuess(InitGuess_i,:);
    Pm=P(u,:);
    GoodInitGuess=1;
    
% cla; plot(P(:,1),P(:,2),'.'); hold on;
% for i=1:k
%     plot(Pm(i,1),Pm(i,2),'r*');
% end
    
    Pmprev=Pm+1;
    Niter=0;
    while sum(sum((Pm-Pmprev).^2))>0.001 && Niter<100
        Pmprev=Pm;
        ClusterN=ClusterN*0;
        W=zeros(k,1);
        for i=1:N
            r=(Pm(:,1)-P(i,1)).^2+(Pm(:,2)-P(i,2)).^2+(Pm(:,3)-P(i,3)).^2;
            [d,di]=min(r);
            ClusterN(di)=ClusterN(di)+1;
            ClusterInd(di,ClusterN(di))=i;
        end
        if ~isempty(find(ClusterN==0))
            GoodInitGuess=0;
            break;
        end
% cla; plot(P(:,1),P(:,2),'.'); hold on;
% for j=1:k
%     plot(Pm(j,1),Pm(j,2),'r*');
% end
        for i=1:k
            if ClusterN(i)==1
                Pm(i,:)=P(ClusterInd(i,1:ClusterN(i)),:);
            else
%                 Pm(i,:)=mean(P(ClusterInd(i,1:ClusterN(i)),:));
                w=P(ClusterInd(i,1:ClusterN(i)),:);
                M=mean(w);
% plot(M(1),M(2),'g*');
                r=sqrt(sum((ones(ClusterN(i),1)*M-w).^2,2));
                rm=mean(r);
%                 rs=std(r);
                n=ClusterN(i); ClusterN(i)=0;
                for j=1:n
                    d=r(j);
                    if d<rm*sigma_k || rm==0%rm+rs*sigma_k
                        ClusterN(i)=ClusterN(i)+1;
                        ClusterInd(i,ClusterN(i))=ClusterInd(i,j);
            %             W=W+d;%termination by the sum of the residuals
                        if W(i)<d%termination by the maximun of the residuals
                            W(i)=d;
% plot(P(ClusterInd(i,ClusterN(i)),1),P(ClusterInd(i,ClusterN(i)),2),'*k');
                        end
                    end
                end
                Pm(i,:)=mean(P(ClusterInd(i,1:ClusterN(i)),:));
            end
            
% c=[rand rand rand];
% plot(Pm(i,1),Pm(i,2),'*','Color',c);
% text(Pm(i,1),Pm(i,2),[num2str(round(ClusterN(i)/N*100)) '%'],'VerticalAlignment','bottom');
% plot(P(ClusterInd(i,1:ClusterN(i)),1),P(ClusterInd(i,1:ClusterN(i)),2),'.','Color',c);

        end
        Niter=Niter+1;
    end
    
% if m==2
%     cla;
%     for i=1:k
%         c=[rand rand rand];
%         plot(Pm(i,1),Pm(i,2),'*','Color',c);
%         text(Pm(i,1),Pm(i,2),[num2str(round(ClusterN(i)/N*100)) '%'],'VerticalAlignment','bottom');
%         plot(P(ClusterInd(i,1:ClusterN(i)),1),P(ClusterInd(i,1:ClusterN(i)),2),'.','Color',c);
%     end
% else
%     for i=1:k
%         c=[rand rand rand];
%         plot3(Pm(i,1),Pm(i,2),Pm(i,3),'*','Color',c);
%         text(Pm(i,1),Pm(i,2),Pm(i,3),[num2str(round(ClusterN(i)/N*100)) '%'],'VerticalAlignment','bottom');
%         plot3(P(ClusterInd(i,1:ClusterN(i)),1),P(ClusterInd(i,1:ClusterN(i)),2),P(ClusterInd(i,1:ClusterN(i)),3),'.','Color',c);
%     end
% end

    if max(Wmin)>max(W)-0.0001 && GoodInitGuess
        Wmin=W;
        MinClusterInd=ClusterInd;
        MinClusterN=ClusterN;
        PM=Pm;
%         Wmin
    end
end

if Draw
%     cla;
    hold on;
    cc=[1 0 0; 0 0 0.5; 0 0 1; 0 0.5 0; 0 0.5 0.5; 0 0.5 1; 0 1 0; 0 1 0.5; 0 1 1; ...
           0.5 0 0; 0.5 0 0.5; 0.5 0 1; 0.5 0.5 0; 0.5 0.5 0.5; 0.5 0.5 1; 0.5 1 0; 0.5 1 0.5; 0.5 1 1; ...
           1 0 0; 1 0 0.5; 1 0 1; 1 0.5 0; 1 0.5 0.5; 1 0.5 1; 1 1 0; 1 1 0.5; 1 1 1;];
   if k>27
       cc=rand(k,3);
   end
    for i=1:k
        c=cc(i,:);
%         c=rand(1,3);
%         c=[0 0 1];
        if m==2
            plot(PM(i,1),PM(i,2),'*','Color',c);
            text(PM(i,1),PM(i,2),[num2str(round(MinClusterN(i)/N*100)) '%'],'VerticalAlignment','bottom');
            plot(P(MinClusterInd(i,1:MinClusterN(i)),1),P(MinClusterInd(i,1:MinClusterN(i)),2),'.','Color',c);
        else
            plot3(PM(i,1),PM(i,2),PM(i,3),'*','Color',c);
            text(PM(i,1),PM(i,2),PM(i,3),[num2str(round(MinClusterN(i)/N*100)) '%'],'VerticalAlignment','bottom');
            plot3(P(MinClusterInd(i,1:MinClusterN(i)),1),P(MinClusterInd(i,1:MinClusterN(i)),2),P(MinClusterInd(i,1:MinClusterN(i)),3),'.','Color',c);
        end
    end
    axis tight;
    axis equal;
%     Wmin
end