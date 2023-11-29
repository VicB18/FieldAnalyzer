DataFolder='D:\FieldRobot\';
ImageList=dir(DataFolder);
v=VideoWriter([DataFolder '_Q1.avi']);%,'Uncompressed AVI'

open(v);
for i=3:length(ImageList)
    FileName=ImageList(i).name;
    if contains(FileName,'.jpg') || contains(FileName,'.JPG')
        A=imread([DataFolder FileName]);
        writeVideo(v,A);
        disp([num2str(i) ' / ' num2str(length(ImageList))]);
    end
end
close(v);