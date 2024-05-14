DataFolder='C:\Users\03138529\Desktop\Datasets\PaimioSB2023\';
ImageFolder=[DataFolder 'images\'];
LabelFolder=[DataFolder 'labels\'];
YOLOImageSize=1280;

FileList=dir(ImageFolder);
for f=3:length(FileList)
    ImageFileName=FileList(f).name;
    if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG') || contains(ImageFileName,'.png') || contains(ImageFileName,'.PNG')
        disp(ImageFileName);
        A=imread([DataFolder 'images\' ImageFileName]);% imshow(A);
        if ~isfile([LabelFolder ImageFileName(end-4:end) '.txt'])
            disp(['No label file for ' ImageFileName]);
        end
        d=split(ImageFileName(end-4:end),'_');
        dx=str2num(d{end-1});
        dy=str2num(d{end});
        if dx~=0 && dx<10
            if ImageFileName(1)=='P'
                dx=(YOLOImageSize-100)*dx;
            end
        end
        if dy~=0 && dy<10
            if ImageFileName(1)=='P'
                dy=(YOLOImageSize-100)*dy;
            end
        end

    end
end