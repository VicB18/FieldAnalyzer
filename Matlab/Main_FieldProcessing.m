% DataFolder='E:\FieldRobot\SjT_SB_2023_07_05\Drone\';
DataFolder='E:\FieldRobot\SjT_SB_2023_06_27\Drone\';
% DataFolder='D:\FieldRobot\SjT_SB_2023_06_27\DroneQ\';
% DataFolder='D:\FieldRobot\SjT_SB_2023_06_27\GoPro\';
% DataFolder='D:\FieldRobot\Rapi_Spinach_2023_09_27\Drone\';
% DataFolder='D:\FieldRobot\PaimioSugarBeet\ControlChemicalDrone\';
% DataFolder='D:\FieldRobot\PaimioSugarBeet\OLD\ControlWildBorderDrone\';
% DataFolder='D:\FieldRobot\PaimioSugarBeet\Drone1\';
YOLOv8SoftwareFolder='C:/Users/03138529/Desktop/FieldRobotIntegration/Software/';
YOLOv8VenvFolder='C:/Users/03138529/Desktop/FieldRobotIntegration/FieldAnalyzerVenv/';
% R=6362132;%[meter]
MapPix_Meter=50;%[pix/meter]
laOffs=60.401901; loOffs=22.662655;
RowWidth=0.5;

ImageSplitToYOLO(DataFolder,1);
RunYOLOv8Detection(DataFolder,YOLOv8SoftwareFolder,YOLOv8VenvFolder);
DetectedImageAssembling(DataFolder);

CollectingDetectedPlants(DataFolder);
RowsInImageAnalysis(DataFolder,RowWidth);
FieldImageMap(DataFolder,MapPix_Meter,1);
% ROIPolygon=boundary

MapDensityRes=1;%m
%% 2023_07_05
%Entire field
[polyX,polyY]=LaLo2CoordOffs([60.40190 60.40189 60.40220 60.40340 60.40343],[22.66265 22.66651 22.66637 22.66324 22.66298],laOffs,loOffs);
FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,[polyX; polyY]);
%All robotic
[polyX,polyY]=LaLo2CoordOffs([60.402080 60.402050 60.402770 60.402760],[22.663200 22.665500 22.663750 22.663300],laOffs,loOffs);
FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,[polyX; polyY]);
%Chemical low
[polyX,polyY]=LaLo2CoordOffs([60.402030 60.401960 60.402010 60.402070],[22.663000 22.666000 22.666000 22.663000],laOffs,loOffs);
FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,[polyX; polyY]);
%Untreated
[polyX,polyY]=LaLo2CoordOffs([60.402770 60.402780 60.402820 60.402820]+0.00001,[22.663200 22.663650 22.663550 22.663200]+0.0001,laOffs,loOffs);
FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,[polyX; polyY]);
% legend('Robotic','Chemical','Untreated');
%% 2023_06_27
%Entire field
[polyX,polyY]=LaLo2CoordOffs([60.40190 60.40189 60.40220 60.40340 60.40343],[22.66265 22.66651 22.66637 22.66324 22.66298],laOffs,loOffs);
FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,[polyX; polyY]);
%All robotic
[polyX,polyY]=LaLo2CoordOffs([60.402080 60.402050 60.402770 60.402760],[22.663200 22.665500 22.663750 22.663300],laOffs,loOffs);
FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,[polyX; polyY]);
%Chemical low
[polyX,polyY]=LaLo2CoordOffs([60.402030 60.401960 60.402010 60.402070],[22.663000 22.666000 22.666000 22.663000],laOffs,loOffs);
FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,[polyX; polyY]);
%Untreated
[polyX,polyY]=LaLo2CoordOffs([60.402770 60.402780 60.402820 60.402820]+0.00001,[22.663200 22.663650 22.663550 22.663200]+0.0001,laOffs,loOffs);
FieldDensityMap(DataFolder,MapDensityRes,MapPix_Meter,[polyX; polyY]);
% legend('Robotic','Chemical');
