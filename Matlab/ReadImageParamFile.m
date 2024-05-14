function ImParam=ReadImageParamFile(ImParamFileName)
s=readlines(ImParamFileName);
for i=1:length(s)
    w=split(s{i},';');
    if strcmp(w{1},'ImageCenterYearthCoordPHI_la')
        ImParam.ImageCenterYearthCoordPHI_la=str2double(w{2});
    end
    if strcmp(w{1},'ImageCenterYearthCoordLambda_lo')
        ImParam.ImageCenterYearthCoordLambda_lo=str2double(w{2});
    end
    if strcmp(w{1},'ImageRelCoordMeterX')
        ImParam.ImageRelCoordMeterX=str2double(w{2});
    end
    if strcmp(w{1},'ImageRelCoordMeterY')
        ImParam.ImageRelCoordMeterY=str2double(w{2});
    end
    if strcmp(w{1},'ImageDir')
        ImParam.ImageDir=str2double(w{2});
    end
    if strcmp(w{1},'ImageScaleK')
        ImParam.ImageScaleK=str2double(w{2});
    end
end
