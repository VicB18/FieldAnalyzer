function A=PolygonArea(x,y)
% poly=polyshape(x,y);
% plot(poly);
% a=polyarea(x,y);

n=length(x);
xmax=max(x); xmin=min(x);
ymax=max(y); ymin=min(y);
if sqrt((x(1)-x(n))^2+(y(1)-y(n))^2)>sqrt((xmax-xmin)^2+(ymax-ymin)^2)/10000
    n=n+1;
    x(n)=x(1);
    y(n)=y(1);
end

A=0;
for i=1:n-1
    A=A+(y(i)+y(i+1))/2*(x(i+1)-x(i));
end

A=abs(A);