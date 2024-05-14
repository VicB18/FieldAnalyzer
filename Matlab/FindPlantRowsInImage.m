function [LineTheta,RowDist,FirstRowToOrigin,RowN]=FindPlantRowsInImage(PointX,PointY)%,ClusterN,ClusterInd,Wmin
RMax=abs(mean(PointX))+abs(mean(PointY))+max(PointY)-min(PointY)+max(PointX)-min(PointX);
% LineThetaInitGuessN=20;
% LineThetaInitGuess=linspace(-pi/2-0.05,pi/2+0.05,LineThetaInitGuessN+1);
Fmin=10^6;
P.PointX=PointX;
P.PointY=PointY;
P.Draw=0;

k=10;%pix/m
marg=5;%pix
xmin=min(PointX)-marg/k; xmax=max(PointX);
ymin=min(PointY)-marg/k; ymax=max(PointY);
n=ceil((xmax-xmin)*k)+2*marg;
m=ceil((ymax-ymin)*k)+2*marg;
A=zeros(n,m);
for i=1:length(PointX)
    a=floor((PointX(i)-xmin)*k); b=floor((PointY(i)-ymin)*k);
    A(a,b)=1;
end
% figure; imshow(A);
[H,theta] = hough(im2gray(A));
Hmax=max(max(H));
B=H>Hmax*0.5;
S=sum(B);
% figure; plot(theta,S,'.');
[a,b]=max(S);
LineThetaInitGuess=pi/2-theta(b)*pi/180;

% H1=imadjust(rescale(H));
% H1=rescale(H);
% imshow(H1,'XData',theta,'YData',rho,'InitialMagnification','fit');
% xlabel('\theta'); ylabel('\rho'); axis on, axis normal;
% B=H1==1;
% imshow(B,'XData',theta,'YData',rho,'InitialMagnification','fit');
% xlabel('\theta'); ylabel('\rho'); axis on, axis normal;
% S=sum(H);
% figure; plot(theta,S,'.');

for RowN_i=5:25
    P.RowN=RowN_i;
    lb=[LineThetaInitGuess-5*pi/180 0 0.1]; ub=[LineThetaInitGuess+5*pi/180 RMax 2];
    gaDat.FieldD=[lb; ub];
    gaDat.indini=[LineThetaInitGuess RMax/2 0.5];
    gaDat.Objfun='ParallelLinesObjFun';
    gaDat.MAXGEN=50/2;
    gaDat.NIND=100/2;
    gaDat.Pm=0.25;
    P.PointX=PointX;
    P.PointY=PointY;
    P.Draw=0;
    gaDat.ObjfunPar=P;
    gaDat.Disp=0;
    gaDat=ga(gaDat);
    if Fmin>gaDat.fxmin
        Fmin=gaDat.fxmin;
%         xmin=gaDat.xmin;
        xmin=[gaDat.xmin RowN_i];
    end
end
LineTheta=xmin(1);
FirstRowToOrigin=xmin(2);
RowDist=xmin(3);
RowN=round(xmin(4));

% P.Draw=1;
% P.RowN=xmin(4);
% disp(['F= ' num2str(ParallelLinesObjFun(xmin,P),2) ', q= ' num2str(xmin,2)])

return


% for LineThetaInitGuess_i=1:LineThetaInitGuessN
%     disp(LineThetaInitGuess_i);
%     for RowN_i=5:25
%         P.RowN=RowN_i;
% %     x0=[(LineThetaInitGuess(LineThetaInitGuess_i)+LineThetaInitGuess(LineThetaInitGuess_i+1))/2 RMax 0.5 RowN_i];
%     x0=[(LineThetaInitGuess(LineThetaInitGuess_i)+LineThetaInitGuess(LineThetaInitGuess_i+1))/2 RMax 0.5];
%     [x,f]=fminsearch(@(x)ParallelLinesObjFun(x,P),x0);
% 
%     if Fmin>f
%         Fmin=f;
%         xmin=[x RowN_i];
%     end
%     end
% end
% P.Draw=1;
% P.RowN=xmin(4);
% disp(['F= ' num2str(ParallelLinesObjFun(xmin,P),2) ', q= ' num2str(xmin,2)])
% LineTheta=xmin(1);
% FirstRowToOrigin=xmin(2);
% RowDist=xmin(3);
% RowN=xmin(4);

for LineThetaInitGuess_i=1:LineThetaInitGuessN
%     disp([num2str(LineThetaInitGuess_i) '  ' num2str(Fmin)]);
    for RowN_i=5:25
        P.RowN=RowN_i;

%     lb=[LineThetaInitGuess(LineThetaInitGuess_i) 0 0 5]; ub=[LineThetaInitGuess(LineThetaInitGuess_i+1) RMax 5 25];
        lb=[LineThetaInitGuess(LineThetaInitGuess_i) 0 0]; ub=[LineThetaInitGuess(LineThetaInitGuess_i+1) RMax 5];
        gaDat.FieldD=[lb; ub];
    %     gaDat.indini=[(LineThetaInitGuess(LineThetaInitGuess_i)+LineThetaInitGuess(LineThetaInitGuess_i+1))/2 RMax/2 0.5 19];
        gaDat.indini=[(LineThetaInitGuess(LineThetaInitGuess_i)+LineThetaInitGuess(LineThetaInitGuess_i+1))/2 RMax/2 0.5];
        gaDat.Objfun='ParallelLinesObjFun';
        gaDat.MAXGEN=50/2;
        gaDat.NIND=100/2;
        gaDat.Pm=0.25;
        P.PointX=PointX;
        P.PointY=PointY;
        P.Draw=0;
        gaDat.ObjfunPar=P;
        gaDat.Disp=0;
        gaDat=ga(gaDat);
        if Fmin>gaDat.fxmin
            Fmin=gaDat.fxmin;
    %         xmin=gaDat.xmin;
            xmin=[gaDat.xmin RowN_i];
        end
    end
end
% P.Draw=1;
% P.RowN=xmin(4);
% disp(['F= ' num2str(ParallelLinesObjFun(xmin,P),2) ', q= ' num2str(xmin,2)])

LineTheta=xmin(1);
FirstRowToOrigin=xmin(2);
RowDist=xmin(3);
RowN=round(xmin(4));
% % LinesKB.LinesK=-ones(RowN,1)/tan(LineTheta);
% % LinesKB.LinesB=(FirstRowToOrigin-RowDist*(0:(RowN-1)))/sin(LineTheta);

    return

P.Draw=0;
n=100;
lt=linspace(-pi/2-0.05,pi/2+0.05,n);
% FirstRowToOrigin=RMax;
rd=linspace(0.05,1,n);
% RowN=round(x(4));
[LT,RD]=meshgrid(lt,rd,n);
FF=LT*0;
% d=0.5-0.02;
% rn=13;
x=[0 FirstRowToOrigin 0 RowN];
for i=1:n
    x(1)=lt(i);
    for j=1:n
        x(3)=rd(j);
        FF(i,j)=ParallelLinesObjFun(x,P);
    end
end
surf(LT,RD,FF);

[mF,w]=min(FF);
[mmF,k]=min(mF);
LT(w(k))
RD(k)
FF(w(k),k)
x(1)=LT(w(k)); x(3)=RD(k);
P.Draw=1;
figure; ParallelLinesObjFun(x,P);
P.Draw=0;
