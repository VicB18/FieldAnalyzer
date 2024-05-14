function RunYOLOv8Detection(DataFolder,YOLOv8SoftwareFolder,YOLOv8VenvFolder)
ProcessingFolder='YOLOv8/';
YOLOv8ModelFile='SugarBeetWeeds.pt';
DataFolder=strrep(DataFolder,'\','/');
% s=['DetectionModelYOLOv8 ' YOLOv8SoftwareFolder YOLOv8ModelFile newline ...
%      'FieldImagesYOLOv8 ' DataFolder ProcessingFolder newline ...
%      ''];
% writelines(s,[YOLOv8SoftwareFolder 'DetectionParams.txt']);
fileID = fopen([YOLOv8SoftwareFolder 'DetectionParams.txt'],'w');
fprintf(fileID,['DetectionModelYOLOv8 ' YOLOv8SoftwareFolder YOLOv8ModelFile '\n']);
fprintf(fileID,['FieldImagesYOLOv8 ' DataFolder ProcessingFolder]);
fclose(fileID);

% s_Prog=['C:\Users\03138529\Desktop\FieldRobotIntegration\FieldAnalyzerVenv\Scripts\activate' ...
% ' && ' ...
% 'python C:\Users\03138529\Desktop\FieldRobotIntegration\Software\FieldDetect.py'];
s_Prog=[YOLOv8VenvFolder 'Scripts/activate' ...
' && ' ...
'python ' YOLOv8SoftwareFolder 'FieldDetect.py'];
status=system(s_Prog);
