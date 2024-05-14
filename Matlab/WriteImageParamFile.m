function WriteImageParamFile(ImParam,ImParamFileName)
s='';
if isfield(ImParam,'ImageCenterYearthCoordPHI_la')
    s=[s 'ImageCenterYearthCoordPHI_la' ';' num2str(ImParam.ImageCenterYearthCoordPHI_la) ';' newline];
end
if isfield(ImParam,'ImageCenterYearthCoordLambda_lo')
    s=[s 'ImageCenterYearthCoordLambda_lo' ';' num2str(ImParam.ImageCenterYearthCoordLambda_lo) ';' newline];
end
if isfield(ImParam,'ImageRelCoordMeterX')
    s=[s 'ImageRelCoordMeterX' ';' num2str(ImParam.ImageRelCoordMeterX) ';' newline];
end
if isfield(ImParam,'ImageRelCoordMeterY')
    s=[s 'ImageRelCoordMeterY' ';' num2str(ImParam.ImageRelCoordMeterY) ';' newline];
end
if isfield(ImParam,'ImageDir')
    s=[s 'ImageDir' ';' num2str(ImParam.ImageDir) ';' newline];
end
if isfield(ImParam,'ImageScaleK')
    s=[s 'ImageScaleK' ';' num2str(ImParam.ImageScaleK) ';' newline];
end
writelines(s,ImParamFileName);