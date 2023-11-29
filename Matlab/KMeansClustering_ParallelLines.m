function [LinesK,LinesB,MinClusterN,MinClusterInd,Wmin]=KMeansClustering_ParallelLines(X,Y,k,sigma_k,Draw)%InitGuess,InitGuessN,%sigma_k - coefficient for the std
N=length(X);
CX=mean(X);
CY=mean(Y);
ClusterInd=zeros(k,N); ClusterN=zeros(k,1);
Wmin=zeros(k,1)+10^10;

% figure; cla; hold on; axis equal; plot(X,Y,'.');

D=(max(X)-min(X)+max(Y)-min(Y))/2;
d=D/k;
InitGuessN=10;
LinesK_init=zeros(InitGuessN,k);
LinesB_init=zeros(InitGuessN,k);
a=linspace(0,pi*(InitGuessN-1)/InitGuessN,InitGuessN);
kk=linspace(-k/2,k/2,k);
for i=1:InitGuessN*0+1
    LinesK_init(i,:)=atan(a(i))+kk*0;
    LinesB_init(i,:)=d/cos(a(i))*kk+CY-CX*sin(a(i));
%     dx=max(X)-min(X); for j=1:k, plot(CX+cos(a(i))*[-dx/2 dx*2],(CX+cos(a(i))*[-dx/2 dx*2])*LinesK_init(i,j)+LinesB_init(i,j)); end
end

for InitGuess_i=1:1%InitGuessN
    %initial guess
    LinesKm=LinesK_init(InitGuess_i,:);
    LinesBm=LinesB_init(InitGuess_i,:);
    GoodInitGuess=1;
    
    LinesKmprev=LinesKm+1;
    LinesBmprev=LinesBm+1;

    Niter=0;
    while sum((LinesKm-LinesKmprev).^2)+sum((LinesBm-LinesBmprev).^2)>0.001 && Niter<100
        LinesKmprev=LinesKm;
        LinesBmprev=LinesBm;
        ClusterN=ClusterN*0;
        W=zeros(k,1);
        for i=1:N
            dy=Y(i)-(LinesKm*X(i)+LinesBm);
            r=abs(dy./cos(atan(LinesKm)));
            [d,di]=min(r);
            ClusterN(di)=ClusterN(di)+1;
            ClusterInd(di,ClusterN(di))=i;
        end
        if ~isempty(find(ClusterN==0, 1))
            GoodInitGuess=0;
            break;
        end
% cla; plot(X,Y,'.'); hold on;
% for j=1:k, plot(Pm(j,1),Pm(j,2),'r*'); end
% dx=max(X)-min(X); for j=1:k, plot(CX+cos(a(i))*[-dx/2 dx*2],(CX+cos(a(i))*[-dx/2 dx*2])*LinesK_init(i,j)+LinesB_init(i,j)); end
        for i=1:k
            if ClusterN(i)==1

            else
                Xm=X(ClusterInd(i,1:ClusterN(i)));
                Ym=Y(ClusterInd(i,1:ClusterN(i)));
%                 PlotFittedLine(Xm,Ym,LinesKm(i),LinesBm(i));
                [b,k1,R2,RMSE]=LinRegression(Xm,Ym,0,0);
                LinesKm(i)=k1;
                LinesBm(i)=b;
                W(i)=RMSE;
            end
            
        end
        Niter=Niter+1;
    end

    if max(Wmin)>max(W)-0.0001 && GoodInitGuess
        Wmin=W;
        MinClusterInd=ClusterInd;
        MinClusterN=ClusterN;
        LinesK=LinesKm;
        LinesB=LinesBm;
    end
end
