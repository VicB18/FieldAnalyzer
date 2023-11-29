function f=PointInsidePolygon(Px,Py,Polyx,Polyy)%number of intersection of polygon sides with a beam from (0,0) to +X direction
x=Polyx-Px;
y=Polyy-Py;

n=length(x);
xmax=max(x); xmin=min(x);
ymax=max(y); ymin=min(y);
if sqrt((x(1)-x(n))^2+(y(1)-y(n))^2)>sqrt((xmax-xmin)^2+(ymax-ymin)^2)/10000
    n=n+1;
    x(n)=x(1);
    y(n)=y(1);
end

IntersectionN=0;
for i=1:n-1
    if x(i)>=0 && x(i+1)>=0 && y(i)*y(i+1)<0
        IntersectionN=IntersectionN+1;
    elseif x(i)*x(i+1)<=0 && y(i)*y(i+1)<0 && (x(i)+x(i+1))/2>0
        IntersectionN=IntersectionN+1;
    end
end
f=IntersectionN/2~=floor(IntersectionN/2);
% figure; hold on; plot(x,y); plot(0,0,'*');