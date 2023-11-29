% DataFolder='F:\FieldRobot\SjT_SB_2023_07_05\Drone\';
DataFolder='F:\FieldRobot\SjT_SB_2023_06_27\Drone\';
% DataFolder='F:\FieldRobot\SjT_SB_2023_06_27\GoPro\';
R=6362132;%[meter]
MapPix_Meter=50;%[pix/meter]

[X,Y,ImageDir,ScaleK,ImageList]=GetImageParam(DataFolder);

MapDx=max(X)-min(X); MapDy=max(Y)-min(Y);
MinX=min(X)*MapPix_Meter; MinY=min(Y)*MapPix_Meter; MaxY=floor(MapDy*MapPix_Meter);
Map=zeros(floor(MapDy*MapPix_Meter),floor(MapDx*MapPix_Meter),3,'uint8');
for i=1:length(X)
    disp(i);
%     if ImageDir(i)==0
%         continue;
%     end
    A=imread(ImageList{i});%figure; imshow(A); imshow(A1);
    ImageResizeK=MapPix_Meter/ScaleK(i);
    A1=imresize(A,ImageResizeK);%D(i)*Pix_Meter/n
    A1=imrotate(A1,ImageDir(i)*180/pi,'bilinear','loose');
    [n,m,l]=size(A1);

    x=floor(X(i)*MapPix_Meter-MinX);
    y=MaxY-floor(Y(i)*MapPix_Meter-MinY*0);

    for xi=1:m
        for yi=1:n
            if A1(yi,xi,1)~=0
                x3=x+xi;
                y3=y+yi;

                Map(y3,x3,1)=A1(yi,xi,1);
                Map(y3,x3,2)=A1(yi,xi,2);
                Map(y3,x3,3)=A1(yi,xi,3);
            end
        end
    end
end%imshow(Map);


figure;
imshow(Map)
% imwrite(Map,[DataFolder 'Map.jpg'])