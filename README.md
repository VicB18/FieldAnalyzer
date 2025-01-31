# FieldAnalyzer

Instructions for taking images from fields by a drone or a robot, and software for field mapping and analysis.

http://dx.doi.org/10.3390/agronomy14102215

## Field mapping process
1.	Collecting field images by drone or robot
1.	Mapping the field
1.	Analyzing the field

## Using drone for field monitoring
### Purchasing drone
A light drone with high resolution RGB camera. One additional battery for 0.5 ha of field.

_Examples:_

DJI Mini 3 Pros, ~1000 euro, battery ~80 euro

Hubsan Zino 2+, ~500 euro, battery ~20 euro
### Flight permission
For flying a light drone a registration and a theoretical test are required.

https://www.droneinfo.fi/fi/rekisteroityminen-ja-teoriakoe
### Software for flight planning
QGroundControl is a free software for planning missions for image taking.

https://docs.qgroundcontrol.com/master/en/getting_started/download_and_install.html

https://www.youtube.com/watch?v=5xswOhhqrIQ

## Mapping a field
Usually, programs creating maps by stitching together separated drone images are expensive, work long time, and distort images. All this is not required for a simple field analysis, which can be done based on separate images. A program FieldOwl is created for a simple analysis, and it is light, free and no installation is required.

The program executable file is `FieldOwl/bin/Debug/FieldOwl.exe`.

In this example a 2ha field map was created from 1100 images taken by a drone from the 4m height. Some of the images are available at https://www.kaggle.com/datasets/victorbloch/sugarbeetfield-paimio-2023-07-05-drone.

<a href=""><img src="Pics/SjT_SB_2023_07_05_Drone_Map.jpg" width="50%" height="50%"></a>

## Image analysis
Image analysis is based on an AI approach for detecting plants on images. The YOLOv5 CNN model was trained to detect different types of cultivars and distinguish them from weeds. The mapping program FieldOwl calls the detecting CNN and creates field maps with different plant features based on the detection result.

To apply the sugar beet detecting model, the following programs must be installed.

Python: https://www.python.org/downloads/

Yolov5: `pip install -r yolov5/requirements.txt`

To resize original drone images for better detection by the sugar beet detecting model, the following script must be run.

`python Main_ImageResize.py`

To run the sugar beet detecting model:

`python detect.py --source F:/FieldRobot/SjT2023_06_27/DroneResized/ --weights runs/train/yolo_SugarBeet/weights/yolov5s6_SugarBeet.pt --conf 0.5 --name F:/FieldRobot/SjT2023_06_27/DetectionResult` 


In this example, the sugar beet plants are detected. Based on the detections, the plant counting and density are valuated.

<a href=""><img src="Pics/P2720272_10.JPG" width="42%" height="42%"></a>  <a href=""><img src="Pics/G0022115_6.JPG" width="50%" height="50%"></a>

## Software for farmers

A ready for using software Field Owl is in the folder `FieldOwl`. The program file is `FieldAnalyzer/FieldOwl/bin/Debug/FieldOwl.exe`.

<a href=""><img src="Pics/GUI.jpg" width="100%" height="100%"></a>
