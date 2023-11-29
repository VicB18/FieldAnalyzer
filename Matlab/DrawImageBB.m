function DrawBB(ImageDataFolder,LabelDataFolder,FileName,PixM)
ClassColor=[1 0 0; 0 0 1];
A=imread([ImageDataFolder FileName]);
[N,M,a]=size(A);
T=readtable([LabelDataFolder FileName(1:end-4) '.txt']);
Class=table2array(T(:,1));
BB_x=round(table2array(T(:,2))*N)/PixM;
BB_y=round(table2array(T(:,3))*M)/PixM;
BB_w=round(table2array(T(:,4))*N)/PixM;
BB_h=round(table2array(T(:,5))*M)/PixM;
figure; 
imshow(A,'XData',[0 M/PixM],'YData',[0 N/PixM]);
hold on; title(FileName);
for j=1:length(Class)
    plot(BB_x(j)+BB_w(j)/2*[-1 1 1 -1 -1],BB_y(j)+BB_h(j)/2*[-1 -1 1 1 -1],'Color',ClassColor(Class(j)+1,:));
end