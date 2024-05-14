function f=RectIntersectRect(Rect1X,Rect1Y,Rect2X,Rect2Y)
f=false;
for i=1:4
    if PointInsidePolygon(Rect1X(i),Rect1Y(i),Rect2X,Rect2Y)
        f=true;
        return;
    end
end
for i=1:4
    if PointInsidePolygon(Rect2X(i),Rect2Y(i),Rect1X,Rect1Y)
        f=true;
    end
end