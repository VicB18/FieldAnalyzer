# python -m venv C:/Users/03138529/Desktop/FieldAnalyzer/PlantDetectionVenv
# C:/Users/03138529/Desktop/FieldAnalyzer/PlantDetectionVenv/Scripts/activate.bat
# cd C:\Users\03138529\Dropbox\Luke\Fertilizing\Software
# python Main_DataSplit.py

# import torch
from IPython.display import Image  # for displaying images
import os 
import random
import shutil
from sklearn.model_selection import train_test_split
# import xml.etree.ElementTree as ET
# from xml.dom import minidom
# from tqdm import tqdm
# from PIL import Image, ImageDraw
# import numpy as np
# import matplotlib.pyplot as plt

DataFolder='SugarBeet_Dataset/'
random.seed(18)
# Read images and annotations
images = [os.path.join(DataFolder+'images', x) for x in os.listdir(DataFolder+'images') if x[-3:] == "jpg" or x[-3:] == "JPG"]
annotations = [os.path.join(DataFolder+'labels', x) for x in os.listdir(DataFolder+'labels') if x[-3:] == "txt"]

images.sort()
annotations.sort()

# Split the dataset into train-valid-test splits 
train_images, val_images, train_annotations, val_annotations = train_test_split(images, annotations, test_size = 0.2, random_state = 1)
val_images, test_images, val_annotations, test_annotations = train_test_split(val_images, val_annotations, test_size = 0.5, random_state = 1)

def move_files_to_folder(list_of_files, destination_folder):
    for f in list_of_files:
        try:
            shutil.move(f, destination_folder)
        except:
            print(f)
            assert False

# Move the splits into their folders
move_files_to_folder(train_images, DataFolder+'images/train')
move_files_to_folder(val_images, DataFolder+'images/val/')
move_files_to_folder(test_images, DataFolder+'images/test/')
move_files_to_folder(train_annotations, DataFolder+'labels/train/')
move_files_to_folder(val_annotations, DataFolder+'labels/val/')
move_files_to_folder(test_annotations, DataFolder+'labels/test/')