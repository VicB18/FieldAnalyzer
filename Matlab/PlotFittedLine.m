function PlotFittedLine(x,y,k,b)
hold on;
plot(x,y,'.');

xmin=min(x);
ymin=xmin*k+b;
if ymin<min(y)
    xmin=(min(y)-b)/k;
end
xmax=max(x);
ymax=xmax*k+b;
if ymax>max(y)
    xmax=(max(y)-b)/k;
end

plot([xmin xmax],[xmin xmax]*k+b);
