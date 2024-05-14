function [LinesK,LinesB,MinClusterN,MinClusterInd,Wmin]=KMeansClustering_ParallelLines(X,Y,K,sigma_k,Draw)%InitGuess,InitGuessN,%sigma_k - coefficient for the std
N=length(X);
CX=mean(X); X=X-CX;
CY=mean(Y); Y=Y-CY;
ClusterInd=zeros(K,N); ClusterN=zeros(K,1);
Wmin=zeros(K,1)+10^10;

% figure; cla; hold on; axis equal; plot(X,Y,'.');

dX=max(X)-min(X);
dY=max(Y)-min(Y);
Dmax=sqrt(dX^2+dY^2)/K;
Dmin=min(dX,dY)/K;
ann=10;
dnn=10;
bonn=3;
d=linspace(Dmin,Dmax,dnn);
a=linspace(0,pi*(ann-1)/ann,ann);
bo=linspace(-0.5,0.5,bonn);
LinesK_init=zeros(ann*dnn,K);
LinesB_init=zeros(ann*dnn,K);
KK=linspace(-K/2,K/2,K);
InitGuessN=0;
for di=1:dnn
    for ai=1:ann
        for bi=1:bonn
            InitGuessN=InitGuessN+1;
            LinesK_init(InitGuessN,:)=tan(a(ai))+KK*0;
            LinesB_init(InitGuessN,:)=d(di)/cos(a(ai))*KK+d(di)*bo(bi);

% if abs(tan(a(ai)))<1
%     for j=1:K
%         plot([min(X) max(X)],[min(X) max(X)]*LinesK_init(InitGuessN,j)+LinesB_init(InitGuessN,j));
%     end
% else
%     for j=1:K
%         plot(([min(Y) max(Y)]-LinesB_init(InitGuessN,j))./LinesK_init(InitGuessN,j),[min(Y) max(Y)]);
%     end
% end   

        end
    end
end

for InitGuess_i=1:InitGuessN
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
        W=zeros(K,1);
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
        for i=1:K
            if ClusterN(i)<=2
                W(i)=max(Wmin)/(ClusterN(i)+0.0001);
            else
                Xm=X(ClusterInd(i,1:ClusterN(i)));
                Ym=Y(ClusterInd(i,1:ClusterN(i)));
% PlotFittedLine(Xm,Ym,LinesKm(i),LinesBm(i));
                [b,k1,RMSE]=LinRegression(Xm,Ym,0,0);
                LinesKm(i)=k1;
                LinesBm(i)=b;
                W(i)=RMSE;
            end
            
        end
        Niter=Niter+1;
    end

    if max(Wmin)>max(W)-0.0001*0 && GoodInitGuess
        Wmin=W;
        MinClusterInd=ClusterInd;
        MinClusterN=ClusterN;
        LinesK=LinesKm;
        LinesB=LinesBm;
    end
end

LinesB=CY-LinesK*CX+LinesB;