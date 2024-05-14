# ###python -m venv C:/Users/03138529/Desktop/FieldAnalyzer/PlantDetectionVenv
# conda create -n C:/Users/03138529/Desktop/FieldAnalyzer/PlantDetectionVenv python=3.8
# C:/Users/03138529/Desktop/FieldAnalyzer/PlantDetectionVenv/Scripts/activate.bat
# cd C:/Users/03138529/Dropbox/Luke/FieldAnalyzer/Software
# python Main_ImageResize.py

import os 
from PIL import Image
import math
# import shutil

ImageN=1280
OverLap=100
OriginalDataFolder='C:/Users/03138529/Desktop/SugarBeet/Original'
DataFolder='C:/Users/03138529/Desktop/SugarBeet'
# OriginalDataFolder='F:/FieldRobot/SjT2023_06_27/Drone'
# DataFolder='F:/FieldRobot/SjT2023_06_27/DroneResized'
images = [os.path.join(OriginalDataFolder, x) for x in os.listdir(OriginalDataFolder) if x[-3:] == "jpg" or x[-3:] == "JPG"]

for f in images:#[5:6]
    fn=os.path.basename(f)
    print(fn)
    im = Image.open(f)
    [N,M]=im.size
    # Nk=math.ceil(N/(ImageN-OverLap))
    # Mk=math.ceil(M/(ImageN-OverLap))
    Nk=math.ceil(N/(ImageN))
    Mk=math.ceil(M/(ImageN))
    Nol=math.floor((ImageN*Nk-N)/(Nk-1))
    if Nol<OverLap:
        Nk=Nk+1
        Nol=math.floor((ImageN*Nk-N)/(Nk-1))
    Mol=math.floor((ImageN*Mk-M)/(Mk-1))
    if Mol<OverLap:
        Mk=Mk+1
        Mol=math.floor((ImageN*Mk-M)/(Mk-1))

    # t=0
    for i in range(Nk):
        for j in range(Mk):
            # im1 = im.crop((i*(ImageN-OverLap), j*(ImageN-OverLap), min(i*(ImageN-OverLap)+ImageN,N), min(j*(ImageN-OverLap)+ImageN,M)))
            im1 = im.crop((i*(ImageN-Nol), j*(ImageN-Mol), i*(ImageN-Nol)+ImageN, j*(ImageN-Mol)+ImageN))
            # t=t+1
            # im1.save(DataFolder+'/'+fn[:-4]+'_'+str(t)+fn[-4:])
            im1.save(DataFolder+'/'+fn[:-4]+'_'+str(i)+'_'+str(j)+fn[-4:])
    # shutil.move(f, DataFolder+'/'+os.path.basename(f))
