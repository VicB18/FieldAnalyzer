function FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,ROIPolygon)
Draw=1;
PlantDist=0.1;%m
RowMargin=0.1;%+-m distance from the row line to test weeds in the rows

FieldImageData=GetImageParam(DataFolder,0);

TDetectedPlants=readtable([DataFolder 'DetectedPlants.csv'],'Delimiter',';');
DetectedPlantsX=table2array(TDetectedPlants(:,1));
DetectedPlantsY=table2array(TDetectedPlants(:,2));
DetectedPlantsW=table2array(TDetectedPlants(:,3));
DetectedPlantsH=table2array(TDetectedPlants(:,4));
DetectedPlantsClass=table2array(TDetectedPlants(:,5));
DetectedPlantsCounted=table2array(TDetectedPlants(:,6));
DetectedPlantImageNo=table2array(TDetectedPlants(:,7));

TImageParam=readtable([DataFolder 'ImageParam.csv']);
% ImageList=table2array(TImageParam(:,1));
% ImageX=table2array(TImageParam(:,2));
% ImageY=table2array(TImageParam(:,3));
% ImageDir=table2array(TImageParam(:,4));
% ImageScaleK=table2array(TImageParam(:,5));
% ImageRow=table2array(TImageParam(:,6));
LineTheta=table2array(TImageParam(:,7));
RowDist=table2array(TImageParam(:,8));
FirstRowToOrigin=table2array(TImageParam(:,9));
RowN=table2array(TImageParam(:,10));

%Plant and weed area density
SamplingSquarArea=MapDensityRes*MapDensityRes;

q=DetectedPlantsClass==0 & DetectedPlantsCounted;
PlantX=DetectedPlantsX(q);
PlantY=DetectedPlantsY(q);
PlantW=DetectedPlantsW(q);
PlantH=DetectedPlantsH(q);
% PlantImageNo=DetectedPlantImageNo(q);
q=DetectedPlantsClass==1 & DetectedPlantsCounted;
WeedX=DetectedPlantsX(q);
WeedY=DetectedPlantsY(q);
WeedImageNo=DetectedPlantImageNo(q);
WeedW=DetectedPlantsW(q);
WeedH=DetectedPlantsH(q);

if isempty(ROIPolygon)
    xmin=ceil(FieldImageData.FieldBoundary.MapXmin+MapDensityRes);
    xmax=(FieldImageData.FieldBoundary.MapXmax-MapDensityRes);
    ymin=ceil(FieldImageData.FieldBoundary.MapYmin+MapDensityRes);
    ymax=(FieldImageData.FieldBoundary.MapYmax-MapDensityRes);
    ROIPolygon=[xmin xmax xmax xmin; ymin ymin ymax ymax];
else
    xmin=ceil(min(ROIPolygon(1,:))+MapDensityRes);
    xmax=(max(ROIPolygon(1,:))-MapDensityRes);
    ymin=ceil(min(ROIPolygon(2,:))+MapDensityRes);
    ymax=(max(ROIPolygon(2,:))-MapDensityRes);
end
[xx,yy]=meshgrid(xmin:MapDensityRes:xmax,ymin:MapDensityRes:ymax);
MapDensitySamplePointX=xx(:);
MapDensitySamplePointY=yy(:);
qin=inpolygon(MapDensitySamplePointX,MapDensitySamplePointY,ROIPolygon(1,:),ROIPolygon(2,:));
MapDensitySamplePointX=MapDensitySamplePointX(qin);
MapDensitySamplePointY=MapDensitySamplePointY(qin);
MapDensityXpix=floor(M2PixX(MapDensitySamplePointX,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter))+1;
MapDensityYpix=floor(M2PixY(MapDensitySamplePointY,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter))+1;   
qin=inpolygon(PlantX,PlantY,ROIPolygon(1,:),ROIPolygon(2,:));
PlantX=PlantX(qin); PlantY=PlantY(qin);
PlantW=PlantW(qin); PlantH=PlantH(qin);
qin=inpolygon(WeedX,WeedY,ROIPolygon(1,:),ROIPolygon(2,:));
WeedX=WeedX(qin); WeedY=WeedY(qin);
WeedW=WeedW(qin); WeedH=WeedH(qin);

MapDensityPlant=zeros(length(MapDensitySamplePointX),1);
MapDensityWeed=zeros(length(MapDensitySamplePointX),1);
MapDensityWeedRow=zeros(length(MapDensitySamplePointX),1);
MapAreaPlant=zeros(length(MapDensitySamplePointX),1);
MapAreaWeed=zeros(length(MapDensitySamplePointX),1);

% load([DataFolder 'Map'],'MapImage'); figure; axis equal; hold on; imshow(MapImage); hold on;

for DensitySample_i=1:length(MapDensitySamplePointX)
    sx=MapDensitySamplePointX(DensitySample_i);
    sy=MapDensitySamplePointY(DensitySample_i);
    xl=sx-MapDensityRes/2; xr=sx+MapDensityRes/2;
    yd=sy-MapDensityRes/2; yu=sy+MapDensityRes/2;
% plot(M2PixX([xl xr xr xl xl],FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY([yd yd yu yu yd],FieldImageData.FieldBoundary.MapYmax,MapPix_Meter));
    q=xl<PlantX & PlantX<xr & yd<PlantY & PlantY<yu;
    MapDensityPlant(DensitySample_i)=sum(q)/SamplingSquarArea;
    a=sum(PlantW(q).*PlantH(q));
    MapAreaPlant(DensitySample_i)=a/SamplingSquarArea;
%     px=PlantX(q);
%     py=PlantY(q);
    q=xl<WeedX & WeedX<xr & yd<WeedY & WeedY<yu;
    MapDensityWeed(DensitySample_i)=sum(q)/SamplingSquarArea;
    a=sum(WeedW(q).*WeedH(q));
    MapAreaWeed(DensitySample_i)=a/SamplingSquarArea;
    wx=WeedX(q);
    wy=WeedY(q);

    if length(wx)<2
        continue;
    end

%Weed row density
    ImNo=WeedImageNo(q);
    ImageNoList=unique(ImNo);
    weedN=0; weedLen=0;
    for i=1:length(ImageNoList)%weeds growing in rows
        Im_i=ImageNoList(i);
        wx1=wx*cos(pi/2-LineTheta(Im_i))-wy*sin(pi/2-LineTheta(Im_i));
        wy1=wx*sin(pi/2-LineTheta(Im_i))+wy*cos(pi/2-LineTheta(Im_i));
        for j=1:RowN(Im_i)
            w=abs(FirstRowToOrigin(Im_i)-RowDist(Im_i)*(j-1)-wy1)<RowMargin;
            if sum(w)>1
% plot(M2PixX(wx(w),FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(wy(w),FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'o');
                weedN=weedN+sum(w)-1;
                weedLen=weedLen+max(wx1(w))-min(wx1(w));
            end
        end
    end
    if weedN~=0
        MapDensityWeedRow(DensitySample_i)=weedN/weedLen;
    end
end

UpLim=0.999;
ColorMax=0.8; ColorMin=0.2*0;

mi=min(min(MapDensityPlant));
MapDensityPlantS=sort(MapDensityPlant);
MaxPlantDensity=MapDensityPlantS(floor(UpLim*length(MapDensityPlant)));
PlantColor_k=(ColorMax-ColorMin)/(MaxPlantDensity-mi);
PlantColor_b=ColorMin-PlantColor_k*mi;
% MapDensityPlant_Color=zeros(length(MapDensityPlant),3);
% % MapDensityPlant_Color(:,1)=1-(MapDensityPlant*PlantColor_k+PlantColor_b);
% MapDensityPlant_Color(:,3)=1-(MapDensityPlant*PlantColor_k+PlantColor_b);

mi=min(min(MapDensityWeed));
MapDensityWeedS=sort(MapDensityWeed);
MaxWeedDensity=MapDensityWeedS(floor(UpLim*length(MapDensityWeed)));
WeedColor_k=(ColorMax-ColorMin)/(MaxWeedDensity-mi);
WeedColor_b=ColorMin-WeedColor_k*mi;
% MapDensityWeed_Color=zeros(length(MapDensityPlant),3);
% % MapDensityWeed_Color(:,1)=1-(MapDensityWeed*WeedColor_k+WeedColor_b);
% MapDensityWeed_Color(:,3)=1-(MapDensityWeed*WeedColor_k+WeedColor_b);

mi=min(min(MapDensityWeedRow));
MapDensityWeedRowS=sort(MapDensityWeedRow);
MaxWeedRowDensity=MapDensityWeedRowS(floor(UpLim*length(MapDensityWeedRow)));
WeedRowColor_k=(ColorMax-ColorMin)/(MaxWeedRowDensity-mi);
WeedRowColor_b=ColorMin-WeedRowColor_k*mi;
% MapDensityWeed_Color=zeros(length(MapDensityPlant),3);
% % MapDensityWeed_Color(:,1)=1-(MapDensityWeed*WeedColor_k+WeedColor_b);
% MapDensityWeed_Color(:,3)=1-(MapDensityWeed*WeedColor_k+WeedColor_b);

load([DataFolder 'Map'],'MapImage');
if Draw
    figure; axis equal; hold on;
    imshow(MapImage); hold on;
%     plot(M2PixX([ROIPolygon(1,:) ROIPolygon(1,1)],FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY([ROIPolygon(2,:) ROIPolygon(2,1)],FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'.g');
    plot(M2PixX(WeedX,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(WeedY,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'.r','MarkerSize',0.5);
    plot(M2PixX(PlantX,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(PlantY,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'.g','MarkerSize',0.5);
    set(gcf,'Position',[50 100 550 500]);
%     legend('Plants','Weeds');
    text(M2PixX((max(PlantX)-min(PlantX))/2,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY(min(PlantY)-3,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'East-west [m]','HorizontalAlignment','center','FontSize',12);
    text(M2PixX(min(PlantX)-3,FieldImageData.FieldBoundary.MapXmin,MapPix_Meter),M2PixY((max(PlantY)-min(PlantY))/2,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter),'South-north [m]','Rotation',90,'HorizontalAlignment','center','FontSize',12);
    w=9000; h=700;
    plot(w,h,'.g','MarkerSize',15); text(w+200,h,'Plants','FontSize',12);
    plot(w,h+500,'.r','MarkerSize',15); text(w+200,h+500,'Weeds','FontSize',12);
end

MapImagePlantDensity=MapImage*0+255;
MapImageWeedDensity=MapImage*0+255;
MapImageWeedRowDensity=MapImage*0+255;
q=(1:MapDensityRes*MapPix_Meter)-floor(MapDensityRes*MapPix_Meter/2);
qmin=min(q); qmax=max(q); [MapN,MapM,~]=size(MapImage);
for DensitySample_i=1:length(MapDensitySamplePointX)
    if 1<MapDensityXpix(DensitySample_i)+qmin && MapDensityXpix(DensitySample_i)+qmax<MapM && 1<MapDensityYpix(DensitySample_i)+qmin && MapDensityYpix(DensitySample_i)+qmax<MapN
        nn=MapDensityYpix(DensitySample_i)+q;
        mm=MapDensityXpix(DensitySample_i)+q;
        A=MapImage(nn,mm,3);
        m=median(A(:));
        A1=double(A)/double(m);
        if m~=0
            MapImagePlantDensity(nn,mm,3)=uint8(A1*(1-(MapDensityPlant(DensitySample_i)*PlantColor_k+PlantColor_b))*256);
            MapImageWeedDensity(nn,mm,3)=uint8(A1*(1-(MapDensityWeed(DensitySample_i)*WeedColor_k+WeedColor_b))*256);
            MapImageWeedRowDensity(nn,mm,3)=uint8(A1*(1-(MapDensityWeedRow(DensitySample_i)*WeedRowColor_k+WeedRowColor_b))*256);
        end
    end
end

% MapImagePlantDensity=AddDotsToImage(MapImagePlantDensity,PlantX,PlantY,2,[0 256 0],FieldImageData.FieldBoundary.MapXmin,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter);
% MapImageWeedDensity=AddDotsToImage(MapImageWeedDensity,WeedX,WeedY,2,[256 0 0],FieldImageData.FieldBoundary.MapXmin,FieldImageData.FieldBoundary.MapYmax,MapPix_Meter);

% [n,m,q]=size(MapImage);
% y_margin=20; x_margin=20;
% sq=floor((n-2*y_margin)/MaxPlantDensity);
% q=(1:sq)-floor(sq/2);
% for i=1:MaxPlantDensity
%     MapImagePlantDensity(y_margin-floor(sq/2)+i*sq+q,m-x_margin-sq+q,3)=uint8((1-(i*PlantColor_k+PlantColor_b))*256);
%     MapImagePlantDensity=AddTextToImage(MapImagePlantDensity,[int2str(i) '/m2'],[y_margin-floor(sq/2*1.5)+i*sq m-x_margin-sq-floor(sq/2)],[0 1 1],'Arial',200);
% end
% sq=floor((n-2*y_margin)/MaxWeedDensity);
% q=(1:sq)-floor(sq/2);
% for i=1:MaxWeedDensity
%     MapImageWeedDensity(y_margin-floor(sq/2)+i*sq+q,m-x_margin-sq+q,3)=uint8((1-(i*WeedColor_k+WeedColor_b))*256);
%     MapImageWeedDensity=AddTextToImage(MapImageWeedDensity,[int2str(i) '/m2'],[y_margin-floor(sq/2*1.5)+i*sq m-x_margin-sq-floor(sq/2)],[0 1 1],'Arial',200);
% end

q=MapDensityPlant~=0 | MapDensityWeed~=0;
% PlantDensityAv=mean(MapDensityPlant(q));
% WeedDensityAv=mean(MapDensityWeed(q));
disp(['PlantDensityAv ' num2str(mean(MapDensityPlant(q)),2) '+-' num2str(std(MapDensityPlant(q)),2) ' plant/m2']);
disp(['WeedDensityAv ' num2str(mean(MapDensityWeed(q)),2) '+-' num2str(std(MapDensityWeed(q)),2) ' weed/m2']);
disp(['PlantAreaAv ' num2str(mean(MapAreaPlant(q))*100,3) '+-' num2str(std(MapAreaPlant(q))*100,3) ' %']);
disp(['WeedAreaAv ' num2str(mean(MapAreaWeed(q))*100,3) '+-' num2str(std(MapAreaWeed(q))*100,3) ' %']);
q=MapDensityWeedRow~=0;
WeedRowDensityAv=mean(MapDensityWeedRow(q));
disp(['WeedRowDensityAv ' num2str(WeedRowDensityAv,2) '+-' num2str(std(MapDensityWeedRow(q)),2) ' weed/m']);

f=[0 1 0];
b=1:2:30;
figure(11);
set(gcf,'Position',[50 150 300 200]); hold on;
% title('Plant Density');
% histogram(MapDensityPlant,b,'Normalization','probability');
[y,x]=histcounts (MapDensityPlant,b,'Normalization','probability');
Y=reshape(f'*y,[],1);
X=reshape([x; x; x]+[0 1/3 2/3]'*ones(1,length(x))*(b(2)-b(1)),[],1);
bar(X(1:end-3),Y*100);
% ytix=get(gca, 'YTick'); set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)
xlabel('Plant density [1/m^2]'); ylabel('%');

figure(12);
set(gcf,'Position',[350 150 300 200]); hold on;
% title('Weed Density');
% histogram(MapDensityWeed,b,'Normalization','probability');%(q)
[y,x]=histcounts (MapDensityWeed,b,'Normalization','probability');
Y=reshape(f'*y,[],1);
X=reshape([x; x; x]+[0 1/3 2/3]'*ones(1,length(x))*(b(2)-b(1)),[],1);
bar(X(1:end-3),Y*100);
% ytix=get(gca, 'YTick'); set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)
xlabel('Weed density [1/m^2]'); ylabel('%');

b=0:0.05:1;
figure(13);
set(gcf,'Position',[50 350 300 200]); hold on;
[y,x]=histcounts (MapAreaPlant,b,'Normalization','probability');
Y=reshape(f'*y,[],1);
X=reshape([x; x; x]+[0 1/3 2/3]'*ones(1,length(x))*(b(2)-b(1)),[],1);
bar(X(1:end-3),Y*100);
% ytix=get(gca, 'YTick'); set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)
xlabel('Plant area [%]'); ylabel('%');

figure(14);
set(gcf,'Position',[350 350 300 200]); hold on;
[y,x]=histcounts (MapAreaWeed,b,'Normalization','probability');
Y=reshape(f'*y,[],1);
X=reshape([x; x; x]+[0 1/3 2/3]'*ones(1,length(x))*(b(2)-b(1)),[],1);
bar(X(1:end-3),Y*100);
% ytix=get(gca, 'YTick'); set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)
xlabel('Weed area [%]'); ylabel('%');

% figure; set(gcf,'Position',[650 250 200 150]);
% % title('Weed Row Density');
% histogram(MapDensityWeedRow,b,'Normalization','probability');%(q)
% ytix=get(gca, 'YTick'); set(gca, 'YTick',ytix, 'YTickLabel',ytix*100)
% xlabel('Weed row density [1/m]'); ylabel('%');

% TDetectedPlants=table(MapDensitySamplePointX,MapDensitySamplePointY,MapDensityPlant,MapDensityWeed,MapDensityWeedRow);
% writetable(TDetectedPlants,[DataFolder 'DensityMaps.csv'],'Delimiter',';','WriteVariableNames',true);
% imwrite(MapImagePlantDensity,[DataFolder 'Maps\' 'MapImagePlantDensity__' num2str(MapPix_Meter) '.jpg']);%,'Quality',100
% imwrite(MapImageWeedDensity,[DataFolder 'Maps\' 'MapImageWeedDensity__' num2str(MapPix_Meter) '.jpg']);%,'Quality',100
% imwrite(MapImageWeedRowDensity,[DataFolder 'Maps\' 'MapImageWeedRowDensity__' num2str(MapPix_Meter) '.jpg']);%,'Quality',100

if Draw
    figure;
    imshow(MapImagePlantDensity);
    hold on; xlabel('East-west [m]'); ylabel('South-north [m]');
    title('Plant density');
    % scatter((PlantX-MapXmin)*MapPix_Meter,(MapYmax-PlantY)*MapPix_Meter,1,'rv');
    
    figure;
    imshow(MapImageWeedDensity);
    hold on; xlabel('East-west [m]'); ylabel('South-north [m]');
    title('Weed density');
    % scatter((WeedX-MapXmin)*MapPix_Meter,(MapYmax-WeedY)*MapPix_Meter,1,'rv');

    figure;
    imshow(MapImageWeedRowDensity);
    hold on; xlabel('East-west [m]'); ylabel('South-north [m]');
    title('Weed row density');
end

return;
%pix
x=min(MapDensitySamplePointX)-MapDensityRes/2;
while x<max(MapDensitySamplePointX)+MapDensityRes
    plot(([x x]-FieldImageData.FieldBoundary.MapXmin)*MapPix_Meter,(FieldImageData.FieldBoundary.MapYmax-[min(MapDensitySamplePointY) max(MapDensitySamplePointY)])*MapPix_Meter,'color',[0.5 1 0.5]);
    x=x+MapDensityRes;
end
y=min(MapDensitySamplePointY)-MapDensityRes/2;
while y<max(MapDensitySamplePointY)+MapDensityRes
    plot(([min(MapDensitySamplePointX) max(MapDensitySamplePointX)]-FieldImageData.FieldBoundary.MapXmin)*MapPix_Meter,(FieldImageData.FieldBoundary.MapYmax-[y y])*MapPix_Meter,'color',[0.5 1 0.5]);
    y=y+MapDensityRes;
end

for DensitySample_i=1:length(MapDensityPlant)
    if MapDensityPlant(DensitySample_i)~=0
        text((MapDensitySamplePointX(DensitySample_i)-MapXmin)*MapPix_Meter,(MapYmax-MapDensitySamplePointY(DensitySample_i))*MapPix_Meter,num2str(MapDensityPlant(DensitySample_i)),'HorizontalAlignment','left');
    end
end

for DensitySample_i=1:length(MapDensityWeed)
    if MapDensityWeed(DensitySample_i)~=0
        text((MapDensitySamplePointX(DensitySample_i)-MapXmin)*MapPix_Meter,(MapYmax-MapDensitySamplePointY(DensitySample_i))*MapPix_Meter,num2str(MapDensityWeed(DensitySample_i)),'HorizontalAlignment','right');
    end
end

function Image=AddDotsToImage(Image,X,Y,s,c,MapXmin,MapYmax,MapPix_Meter)
q=(1:s)-1-floor(s/2);
for i=1:length(X)
    Image(M2PixY(Y(i),MapYmax,MapPix_Meter)+q,M2PixX(X(i),MapXmin,MapPix_Meter)+q,1)=c(1);
    Image(M2PixY(Y(i),MapYmax,MapPix_Meter)+q,M2PixX(X(i),MapXmin,MapPix_Meter)+q,2)=c(2);
    Image(M2PixY(Y(i),MapYmax,MapPix_Meter)+q,M2PixX(X(i),MapXmin,MapPix_Meter)+q,3)=c(3);
end