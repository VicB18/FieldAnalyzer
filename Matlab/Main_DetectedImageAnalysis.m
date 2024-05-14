% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\';
% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\ControlChemical\';
% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\OLD\ControlWild\';
DataFolder='D:\FieldRobot\SjT_SB_2023_07_05\Drone\';
% DataFolder='D:\FieldRobot\SjT_SB_2023_06_27\Drone\';
% DataFolder='D:\FieldRobot\SjT_SB_2023_06_27\DroneQ\';
% DataFolder='D:\FieldRobot\SjT_SB_2023_06_27\GoPro\';
% DataFolder='D:\FieldRobot\Rapi_Spinach_2023_09_27\Drone\';
Draw=0;
PlantDist=0.1;%m
RowMargin=0.05;%+-m distance from the row line to test weeds in the rows
MapDensityRes=1;%m
MapPix_Meter=50;%[pix/meter]

[ImageX,ImageY,ImageDir,ImageScaleK,ImageList,FieldBoundary]=GetImageParam(DataFolder,0);

T=readtable(T,[DataFolder 'DetectedPlants.csv'],'Delimiter',';','WriteVariableNames',true);
DetectedPlantsX=table2array(T(:,1));
DetectedPlantsY=table2array(T(:,2));
DetectedPlantsW=table2array(T(:,3));
DetectedPlantsH=table2array(T(:,4));
DetectedPlantsClass=table2array(T(:,5));
DetectedPlantsCounted=table2array(T(:,6));
PlantImageNo=table2array(T(:,7));


% A=imread([DataFolder ImageList{1}]);
% [h,w,a]=size(A);
% i=1; while i<length(ImageX) && ImageScaleK(i)==0, i=i+1; end
% ImageRm=sqrt(w*w+h*h)/2/ImageScaleK(i);%meters
% MapXmin=min(ImageX)-ImageRm; MapYmax=max(ImageY)+ImageRm;
% ImageRectX=zeros(length(ImageX),4);
% ImageRectY=zeros(length(ImageX),4);

% % MapDensityRes=1;%m
% MapXminR=ceil(MapXmin)+MapDensityRes;
% MapYminR=ceil(MapYmin)+MapDensityRes;
% [xx,yy]=meshgrid(MapXminR:MapDensityRes:(MapXmax-MapDensityRes),MapYminR:MapDensityRes:(MapYmax-MapDensityRes));
% MapDensityX=xx(:);
% MapDensityY=yy(:);
% MapDensityXpix=floor((MapDensityX-MapXmin)*MapPix_Meter)+1;
% MapDensityYpix=floor((MapYmax-MapDensityY)*MapPix_Meter)+1;   
% T=table(MapDensityX,MapDensityY,MapDensityXpix,MapDensityYpix,'VariableNames',{'X','Y','Xpix','Ypix'});
% writetable(T,[DataFolder 'Maps\' 'MapDensity__' num2str(MapDensityRes) '.csv'],'Delimiter',';');
% 
% plot(MapDensityXpix,MapDensityYpix,'.')
% 
% T=readtable([DataFolder 'Maps\' 'MapDensity__' num2str(MapDensityRes) '.csv'],'Delimiter',';');
% MapDensityX=table2array(T(:,1));
% MapDensityY=table2array(T(:,2));
% MapDensityXpix=table2array(T(:,3));
% MapDensityYpix=table2array(T(:,4));
% A=imread([DataFolder ImageList{1}]);
% [ImageN,ImageM,a]=size(A);
% MapDensityPlant=zeros(length(MapDensityX),1);
% MapDensityWeed=zeros(length(MapDensityX),1);
% 
% PlantX=zeros(length(ImageX)*100,1); PlantY=PlantX; PlantW=PlantX; PlantH=PlantX;
% WeedX=zeros(length(ImageX)*100,1); WeedY=PlantX; WeedW=PlantX; WeedH=PlantX;
% % PlantImageNo=zeros(length(ImageX),1); WeedImageNo=zeros(length(ImageX),1);
% PlantN=0; WeedN=0;

% if Draw
%     figure; axis equal; hold on;
%     load([DataFolder 'Map']);
%     imshow(MapImage); hold on;
% end

for Image_i=1:length(ImageX)
    disp(Image_i);
    if ImageDir(Image_i)==0
        continue;
    end
    FileName=ImageList{Image_i};

    disp(FileName);
    if ~isfile([DataFolder 'Detection\' FileName(1:end-4) '.txt'])
        disp('No BB file.');
        continue;
    end

    if Draw
        DrawImageBB(DataFolder,[DataFolder 'Detection\'],FileName,ImageScaleK(Image_i));
    end
    
    T=readtable([DataFolder 'Detection\' FileName(1:end-4) '.txt']);
    Class=table2array(T(:,1));
    BB_cx_pix=round(table2array(T(:,2))*ImageN);
    BB_cy_pix=round(table2array(T(:,3))*ImageM);
    % BB_w=round(table2array(T(:,4))*N);
    % BB_h=round(table2array(T(:,5))*M);
    
    BB_cx_m=(BB_cx_pix-ImageM/2)/ImageScaleK(Image_i);
    BB_cy_m=(ImageN/2-BB_cy_pix)/ImageScaleK(Image_i);
    % BB_w=BB_w/PixToMeterK;
    % BB_h=BB_h/PixToMeterK;

    BB_cx_rot=BB_cx_m*cos(ImageDir(Image_i))-BB_cy_m*sin(ImageDir(Image_i))+ImageX(Image_i);
    BB_cy_rot=BB_cx_m*sin(ImageDir(Image_i))+BB_cy_m*cos(ImageDir(Image_i))+ImageY(Image_i);
    PlantBB_cx=BB_cx_rot(Class==0);
    PlantBB_cy=BB_cy_rot(Class==0);
    WeedBB_cx=BB_cx_rot(Class==1);
    WeedBB_cy=BB_cy_rot(Class==1);

    x=[-0.5 0.5 0.5 -0.5]*w/ImageScaleK(Image_i); y=[-0.5 -0.5 0.5 0.5]*h/ImageScaleK(Image_i);
    ImageRectX(Image_i,:)=x*cos(ImageDir(Image_i))-y*sin(ImageDir(Image_i))+ImageX(Image_i);
    ImageRectY(Image_i,:)=x*sin(ImageDir(Image_i))+y*cos(ImageDir(Image_i))+ImageY(Image_i);

    poly_i=polyshape(ImageRectX(Image_i,:),ImageRectY(Image_i,:)); %plot(M2PixX(ImageRectX(Image_i,:),MapXmin,MapPix_Meter),M2PixY(ImageRectY(Image_i,:),MapYmax,MapPix_Meter))
    for Image_j=1:Image_i-1
        poly_j=polyshape(ImageRectX(Image_j,:),ImageRectY(Image_j,:)); %plot(M2PixX(ImageRectX(Image_j,:),MapXmin,MapPix_Meter),M2PixY(ImageRectY(Image_j,:),MapYmax,MapPix_Meter))
        polyout=intersect(poly_i,poly_j); %plot(M2PixX(polyout.Vertices(:,1),MapXmin,MapPix_Meter),M2PixY(polyout.Vertices(:,2),MapYmax,MapPix_Meter))
        if ~isempty(polyout.Vertices)
            qin=inpolygon(PlantBB_cx,PlantBB_cy,polyout.Vertices(:,1),polyout.Vertices(:,2));
            PlantBB_cx=PlantBB_cx(~qin);
            PlantBB_cy=PlantBB_cy(~qin); %plot(M2PixX(PlantBB_cx,MapXmin,MapPix_Meter),M2PixY(PlantBB_cy,MapYmax,MapPix_Meter),'.')
            qin=inpolygon(WeedBB_cx,WeedBB_cy,polyout.Vertices(:,1),polyout.Vertices(:,2));
            WeedBB_cx=WeedBB_cx(~qin);
            WeedBB_cy=WeedBB_cy(~qin); %plot(M2PixX(WeedBB_cx,MapXmin,MapPix_Meter),M2PixY(WeedBB_cy,MapYmax,MapPix_Meter),'.')
        end
    end

    PlantX(PlantN+(1:length(PlantBB_cx)))=PlantBB_cx;
    PlantY(PlantN+(1:length(PlantBB_cx)))=PlantBB_cy;
    WeedX(WeedN+(1:length(WeedBB_cx)))=WeedBB_cx;
    WeedY(WeedN+(1:length(WeedBB_cx)))=WeedBB_cy;

    PlantImageNo(PlantN+(1:length(PlantBB_cx)))=Image_i;
    WeedImageNo(WeedN+(1:length(WeedBB_cx)))=Image_i;
    PlantN=PlantN+length(PlantBB_cx);
    WeedN=WeedN+length(WeedBB_cx);
    
    
end

PlantX=PlantX(1:PlantN);
PlantY=PlantY(1:PlantN);
WeedX=WeedX(1:WeedN);
WeedY=WeedY(1:WeedN);

s=MapDensityRes*MapDensityRes;
for DensitySample_i=1:length(MapDensityX)
    q=MapDensityX(DensitySample_i)-MapDensityRes/2<PlantX & PlantX<MapDensityX(DensitySample_i)+MapDensityRes/2 & MapDensityY(DensitySample_i)-MapDensityRes/2<PlantY & PlantY<MapDensityY(DensitySample_i)+MapDensityRes/2;
    MapDensityPlant(DensitySample_i)=sum(q)/s;
    q=MapDensityX(DensitySample_i)-MapDensityRes/2<WeedX & WeedX<MapDensityX(DensitySample_i)+MapDensityRes/2 & MapDensityY(DensitySample_i)-MapDensityRes/2<WeedY & WeedY<MapDensityY(DensitySample_i)+MapDensityRes/2;
    MapDensityWeed(DensitySample_i)=sum(q)/s;
end

mi=min(min(MapDensityPlant));
MapDensityPlantS=sort(MapDensityPlant);
MaxPlantDensity=MapDensityPlantS(floor(0.95*length(MapDensityPlant)));
PlantColor_k=1/(MaxPlantDensity-mi);
PlantColor_b=-PlantColor_k*mi;
MapDensityPlant_Color=ones(length(MapDensityPlant),3);
MapDensityPlant_Color(:,1)=1-(MapDensityPlant*PlantColor_k+PlantColor_b);
MapDensityPlant_Color(:,2)=1-(MapDensityPlant*PlantColor_k+PlantColor_b);

mi=min(min(MapDensityWeed));
MapDensityWeedS=sort(MapDensityWeed);
MaxWeedDensity=MapDensityWeedS(floor(0.95*length(MapDensityWeed)));
WeedColor_k=1/(MaxWeedDensity-mi);
WeedColor_b=-WeedColor_k*mi;
MapDensityWeed_Color=ones(length(MapDensityPlant),3);
MapDensityWeed_Color(:,1)=1-(MapDensityWeed*WeedColor_k+WeedColor_b);
MapDensityWeed_Color(:,2)=1-(MapDensityWeed*WeedColor_k+WeedColor_b);

load([DataFolder 'Map']);

MapImagePlantDensity=MapImage;
MapImageWeedDensity=MapImage;
q=(1:MapDensityRes*MapPix_Meter)-floor(MapDensityRes*MapPix_Meter/2);
for DensitySample_i=1:length(MapDensityX)
    MapImagePlantDensity(MapDensityYpix(DensitySample_i)+q,MapDensityXpix(DensitySample_i)+q,3)=uint8((1-(MapDensityPlant(DensitySample_i)*PlantColor_k+PlantColor_b))*256);
    MapImageWeedDensity(MapDensityYpix(DensitySample_i)+q,MapDensityXpix(DensitySample_i)+q,3)=uint8((1-(MapDensityWeed(DensitySample_i)*WeedColor_k+WeedColor_b))*256);
end
q=-1:1;
for Plant_i=1:length(PlantX)
    MapImagePlantDensity(M2PixY(PlantY(Plant_i),MapYmax,MapPix_Meter)+q,M2PixX(PlantX(Plant_i),MapXmin,MapPix_Meter)+q,1)=uint8(256);
    MapImagePlantDensity(M2PixY(PlantY(Plant_i),MapYmax,MapPix_Meter)+q,M2PixX(PlantX(Plant_i),MapXmin,MapPix_Meter)+q,2)=uint8(0);
    MapImagePlantDensity(M2PixY(PlantY(Plant_i),MapYmax,MapPix_Meter)+q,M2PixX(PlantX(Plant_i),MapXmin,MapPix_Meter)+q,3)=uint8(0);
end
for Weed_i=1:length(WeedX)
    MapImageWeedDensity(M2PixY(WeedY(Weed_i),MapYmax,MapPix_Meter),M2PixX(WeedX(Weed_i)+q,MapXmin,MapPix_Meter)+q,1)=uint8(256);
    MapImageWeedDensity(M2PixY(WeedY(Weed_i),MapYmax,MapPix_Meter),M2PixX(WeedX(Weed_i)+q,MapXmin,MapPix_Meter)+q,2)=uint8(0);
    MapImageWeedDensity(M2PixY(WeedY(Weed_i),MapYmax,MapPix_Meter),M2PixX(WeedX(Weed_i)+q,MapXmin,MapPix_Meter)+q,3)=uint8(0);
end
% plot(M2PixX(PlantBB_cx,MapXmin,MapPix_Meter),M2PixY(PlantBB_cy,MapYmax,MapPix_Meter),'.')

[n,m,q]=size(MapImage);
y_margin=20; x_margin=20;
sq=floor((n-2*y_margin)/MaxPlantDensity);
q=(1:sq)-floor(sq/2);
for i=1:MaxPlantDensity
    MapImagePlantDensity(y_margin-floor(sq/2)+i*sq+q,m-x_margin-sq+q,3)=uint8((1-(i*PlantColor_k+PlantColor_b))*256);
    MapImagePlantDensity=AddTextToImage(MapImagePlantDensity,[int2str(i) '/m2'],[y_margin-floor(sq/2*1.5)+i*sq m-x_margin-sq-floor(sq/2)],[0 1 1],'Arial',100);
end
sq=floor((n-2*y_margin)/MaxWeedDensity);
q=(1:sq)-floor(sq/2);
for i=1:MaxWeedDensity
    MapImageWeedDensity(y_margin-floor(sq/2)+i*sq+q,m-x_margin-sq+q,3)=uint8((1-(i*WeedColor_k+WeedColor_b))*256);
    MapImageWeedDensity=AddTextToImage(MapImageWeedDensity,[int2str(i) '/m2'],[y_margin-floor(sq/2*1.5)+i*sq m-x_margin-sq-floor(sq/2)],[0 1 1],'Arial',100);
end

figure;
imshow(MapImagePlantDensity);
hold on; xlabel('East-west, [m]'); ylabel('South-north, [m]');
title('Plant density');
% scatter((PlantX-MapXmin)*MapPix_Meter,(MapYmax-PlantY)*MapPix_Meter,1,'rv');
imwrite(MapImagePlantDensity,[DataFolder 'Maps\' 'MapImagePlantDensity__' num2str(MapPix_Meter) '.jpg']);%,'Quality',100

figure;
imshow(MapImageWeedDensity);
hold on; xlabel('East-west, [m]'); ylabel('South-north, [m]');
title('Weed density');
% scatter((WeedX-MapXmin)*MapPix_Meter,(MapYmax-WeedY)*MapPix_Meter,1,'rv');
imwrite(MapImageWeedDensity,[DataFolder 'Maps\' 'MapImageWeedDensity__' num2str(MapPix_Meter) '.jpg']);%,'Quality',100

% X_patch=zeros(4,length(MapDensityX)); Y_patch=zeros(4,length(MapDensityX));
% for i=1:length(MapDensityX)
%     X_patch(1,i)=MapDensityX(i)-MapDensityRes/2;
%     X_patch(2,i)=MapDensityX(i)+MapDensityRes/2;
%     X_patch(3,i)=MapDensityX(i)+MapDensityRes/2;
%     X_patch(4,i)=MapDensityX(i)-MapDensityRes/2;
%     Y_patch(1,i)=MapDensityY(i)-MapDensityRes/2;
%     Y_patch(2,i)=MapDensityY(i)-MapDensityRes/2;
%     Y_patch(3,i)=MapDensityY(i)+MapDensityRes/2;
%     Y_patch(4,i)=MapDensityY(i)+MapDensityRes/2;
% end

% figure;
% imshow(MapImagePlantDensity,'XData',[min(MapDensityX) max(MapDensityX)],'YData',[min(MapDensityY) max(MapDensityY)]);
% axis('on','image'); hold on; xlabel('East-west, [m]'); ylabel('South-north, [m]');
% title('Plant density');


% figure; axis equal;
% imshow(MapImage,'XData',[min(MapDensityX) max(MapDensityX)],'YData',[min(MapDensityY) max(MapDensityY)]);
% axis('on','image'); hold on; xlabel('East-west, [m]'); ylabel('South-north, [m]');
% % scatter(MapDensityX,max(MapDensityY)+min(MapDensityY)-MapDensityY,[],MapDensityPlant_Color,'.');%,'SizeData',1
% patch(X_patch,max(MapDensityY)+min(MapDensityY)-Y_patch,MapDensityWeed,'EdgeColor','none','FaceAlpha',0.3);
% colorbar;
% title('Plant density');
% 
% figure; axis equal;
% imshow(MapImage,'XData',[min(MapDensityX) max(MapDensityX)],'YData',[min(MapDensityY) max(MapDensityY)]);
% axis('on','image'); hold on; xlabel('Easr-west, [m]'); ylabel('South-north, [m]');
% scatter(MapDensityX,max(MapDensityY)+min(MapDensityY)-MapDensityY,[],MapDensityWeed_Color,'.');%,'SizeData',1
% title('Weed density');

return;
%pix
x=min(MapDensityX)-MapDensityRes/2;
while x<max(MapDensityX)+MapDensityRes
    plot(([x x]-MapXmin)*MapPix_Meter,(MapYmax-[min(MapDensityY) max(MapDensityY)])*MapPix_Meter,'color',[0.5 1 0.5]);
    x=x+MapDensityRes;
end
y=min(MapDensityY)-MapDensityRes/2;
while y<max(MapDensityY)+MapDensityRes
    plot(([min(MapDensityX) max(MapDensityX)]-MapXmin)*MapPix_Meter,(MapYmax-[y y])*MapPix_Meter,'color',[0.5 1 0.5]);
    y=y+MapDensityRes;
end

for DensitySample_i=1:length(MapDensityPlant)
    if MapDensityPlant(DensitySample_i)~=0
        text((MapDensityX(DensitySample_i)-MapXmin)*MapPix_Meter,(MapYmax-MapDensityY(DensitySample_i))*MapPix_Meter,num2str(MapDensityPlant(DensitySample_i)),'HorizontalAlignment','left');
    end
end

for DensitySample_i=1:length(MapDensityWeed)
    if MapDensityWeed(DensitySample_i)~=0
        text((MapDensityX(DensitySample_i)-MapXmin)*MapPix_Meter,(MapYmax-MapDensityY(DensitySample_i))*MapPix_Meter,num2str(MapDensityWeed(DensitySample_i)),'HorizontalAlignment','right');
    end
end

% %meters
% x=min(MapDensityX)-MapDensityRes/2;
% while x<max(MapDensityX)+MapDensityRes
%     plot([x x],[min(MapDensityY) max(MapDensityY)],'color',[0.5 1 0.5]);
%     x=x+MapDensityRes;
% end
% y=min(MapDensityY)-MapDensityRes/2;
% while y<max(MapDensityY)+MapDensityRes
%     plot([min(MapDensityX) max(MapDensityX)],[y y],'color',[0.5 1 0.5]);
%     y=y+MapDensityRes;
% end

% for i=1:length(MapDensityPlant)
%     if MapDensityPlant(i)~=0
%         text(MapDensityX(i),max(MapDensityY)+min(MapDensityY)-MapDensityY(i),num2str(MapDensityPlant(i)));
%     end
% end
% 
% for i=1:length(MapDensityWeed)
%     if MapDensityWeed(i)~=0
%         text(MapDensityX(i),max(MapDensityY)+min(MapDensityY)-MapDensityY(i),num2str(MapDensityWeed(i)));
%     end
% end