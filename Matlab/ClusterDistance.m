function dmin=ClusterDistance(X1,Y1,X2,Y2)
n1=length(X1);
Niter=10;
dmin=10^10;
% figure; hold on; plot(X1,Y1,'.b'); plot(X2,Y2,'.g'); axis equal;
for i=1:Niter
    j1=ceil(n1/Niter*i);
    dd=(X1(j1)-X2).^2+(Y1(j1)-Y2).^2;
    [r,j2]=min(dd);
% plot([X1(j1) X2(j2)],[Y1(j1) Y2(j2)]);
    dd=(X2(j2)-X1).^2+(Y2(j2)-Y1).^2;
    [d,j1]=min(dd);
% plot([X1(j1) X2(j2)],[Y1(j1) Y2(j2)]);
    if dmin>d
        dmin=d;
    end
end
dmin=sqrt(dmin);