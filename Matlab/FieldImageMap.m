function FieldImageMap(DataFolder,MapPix_Meter,Draw)
if ~exist([DataFolder 'Maps\'], 'dir')
    mkdir([DataFolder 'Maps\']);
end
Drone4m=570;

FieldImageData=GetImageParam(DataFolder,0);

MapDxm=FieldImageData.FieldBoundary.MapXmax-FieldImageData.FieldBoundary.MapXmin;
MapDym=FieldImageData.FieldBoundary.MapYmax-FieldImageData.FieldBoundary.MapYmin;
MapImage=zeros(floor(MapDym*MapPix_Meter)+2,floor(MapDxm*MapPix_Meter)+2,3,'uint8')+255;
for Image_i=1:length(FieldImageData.ImageX)
    disp([FieldImageData.ImageList{Image_i} ', ' num2str(Image_i) ' / ' num2str(length(FieldImageData.ImageX))])
    if FieldImageData.ImageDir(Image_i)==0
        continue;
    end
    A=imread([DataFolder FieldImageData.ImageList{Image_i}]);%figure; imshow(A); imshow(A1);
    if FieldImageData.ImageScaleK(Image_i)==0
        FieldImageData.ImageScaleK(Image_i)=Drone4m;
    end
    ImageResizeK=MapPix_Meter/FieldImageData.ImageScaleK(Image_i);
    A1=imresize(A,ImageResizeK);
    A1=imrotate(A1,FieldImageData.ImageDir(Image_i)*180/pi,'bilinear','loose');
    [n,m,~]=size(A1);

    XImCorner=floor(M2PixX(FieldImageData.ImageX(Image_i),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter)-m/2)+1;
    YImCorner=floor(M2PixY(FieldImageData.ImageY(Image_i),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter)-n/2)+1;

    for xi=1:m
        for yi=1:n
            if A1(yi,xi,1)~=0
                MapImage(YImCorner+yi,XImCorner+xi,1)=A1(yi,xi,1);
                MapImage(YImCorner+yi,XImCorner+xi,2)=A1(yi,xi,2);
                MapImage(YImCorner+yi,XImCorner+xi,3)=A1(yi,xi,3);
            end
        end
    end
%     imshow(MapImage); hold on;
%     plot(floor((ImageX(i)-MapXmin)*MapPix_Meter)+1,floor((MapYmax-ImageY(i))*MapPix_Meter)+1,'.')
end

imwrite(MapImage,[DataFolder 'Maps\' 'MapImage__' num2str(MapPix_Meter) '.jpg'])
save([DataFolder 'Map'],'MapImage'); %load([DataFolder 'Map']);

if Draw
    figure; hold on;
    imshow(MapImage); hold on;
    ImageXpix=floor(M2PixX(FieldImageData.ImageX,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter))+1;    
    ImageYpix=floor(M2PixY(FieldImageData.ImageY,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter))+1;
    plot(ImageXpix,ImageYpix,'o')
end