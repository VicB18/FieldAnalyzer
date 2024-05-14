function DrawImageBB(ImageDataFolder,LabelDataFolder,FileName)%,Dir
ClassColor=[0 1 0; 1 0 0];
A=imread([ImageDataFolder FileName]);
% [N,M,~]=size(A);
[Ny,Nx,~]=size(A);
% if Dir==1
%     [Nx,Ny,a]=size(A);
% else
%     [Ny,N,a]=size(A);
% end
T=readtable([LabelDataFolder FileName(1:end-4) '.txt']);
if isempty(T)
    Class=[];
else
    Class=table2array(T(:,1));
    BB_x=round(table2array(T(:,2))*Nx);
    BB_y=round(table2array(T(:,3))*Ny);
    BB_w=round(table2array(T(:,4))*Nx);
    BB_h=round(table2array(T(:,5))*Ny);
end
figure; 
imshow(A);
hold on; title(FileName);
plot(1,1,'Color',ClassColor(1,:));
plot(1,1,'Color',ClassColor(2,:));
for j=1:length(Class)
    plot(BB_x(j)+BB_w(j)/2*[-1 1 1 -1 -1],BB_y(j)+BB_h(j)/2*[-1 -1 1 1 -1],'Color',ClassColor(Class(j)+1,:),'LineWidth',2);
%     text(BB_x(j),BB_y(j),num2str(j));
end
legend('Plant','Weed');
