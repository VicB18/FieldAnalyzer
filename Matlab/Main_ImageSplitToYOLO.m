% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\';
% DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\ControlChemical\';
DataFolder='C:\Users\03138529\Desktop\PaimioSugarBeet\ControlWild\';
TrainFolder='train\';
LabelFolder='Labels\';
Draw=0;

FileList=dir(DataFolder);
for i=3:length(FileList)
    ImageFileName=FileList(i).name;
    if contains(ImageFileName,'.jpg') || contains(ImageFileName,'.JPG')
        ImageYOLOSlice(DataFolder,ImageFileName,[DataFolder TrainFolder]);
    end
end
