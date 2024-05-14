function F=ParallelLinesObjFun(x,P)%
%https://en.wikipedia.org/wiki/Hough_transform
PointX=P.PointX;
PointY=P.PointY;
LineTheta=x(1);
FirstRowToOrigin=x(2);
RowDist=x(3);
% RowN=round(x(4));
RowN=P.RowN;
E=zeros(RowN,length(PointX));
ctt=1/tan(LineTheta);
st=sin(LineTheta);
for Row_i=1:RowN
    r=FirstRowToOrigin-RowDist*(Row_i-1);
%     xp=(PointX+r*cta/sa-PointY*cta)/(1+cta*cta);
%     yp=r/sa-xp*cta;
%     d=sqrt((xp-PointX).^2+(yp-PointY).^2);
    LinesK=-ctt;
    LinesB=r/st;
    y=PointX*LinesK+LinesB;
    dy=PointY-y;
    d=abs(dy*st);
    E(Row_i,:)=d;
%     E(Row_i,:)=abs(PointX*sin(RowDir)+PointY*cos(RowDir)-(FirstRowToOrigin-RowDist*(Row_i-1)));
end
[MinE,LineNo]=min(E);
IncludedLinesN=length(unique(LineNo));
% F=max(MinE)+RowN-IncludedLinesN;
F=mean(MinE)+RowN-IncludedLinesN;

if P.Draw
    % RowN=round(x(4));
    LinesK=-ones(RowN,1)/tan(LineTheta);
    % RowDist=x(3);
    LinesB=(FirstRowToOrigin-RowDist*(0:(RowN-1)))/sin(LineTheta);
    % figure;
    cla; hold on; axis equal;
    plot(PointX,PointY,'.');
    
    for Row_i=1:RowN
        q=LineNo==Row_i;
        PlotFittedLine(PointX,PointY,LinesK(Row_i),LinesB(Row_i));
        plot(PointX(q),PointY(q),'.');
    end
end
