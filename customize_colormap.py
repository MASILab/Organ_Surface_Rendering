# -*- coding: utf-8 -*-
"""
Created on Fri Aug 21 16:55:21 2020

@author: peter
"""

import os
import nibabel as nib
import numpy as np
from PIL import Image
from skimage.color import rgb2lab, lab2rgb


import argparse
parser = argparse.ArgumentParser(description='Scripts pipeline of generating vtk file for surface rendering')
# All working dirs
parser.add_argument('--xy_dim',  default='512', 
                    help='x & y dimension of 2D colormap')
   
parser.add_argument('--bright_value',  default='0.8', 
                    help='brightness value of the CIE La*b* colormap (L)')

parser.add_argument('--d_value',  default='16', 
                    help='Downsample factor of color')

parser.add_argument('--output_dir',  default='C:/Users/peter', 
                    help='root path of directory with surface rendered vtk file')

opt = parser.parse_args()

x = np.linspace(-1.28,1.28,512)
y = np.linspace(-1.28,1.28,512)

X, Y = np.meshgrid(x, y)
CLR = np.ones((X.shape[0], X.shape[1], 3))
CLR[:,:,0][CLR[:,:,0]!=0] = 0.8
CLR[:,:,1] = Y
CLR[:,:,2] = X

cie = lab2rgb(CLR*100)
color_list = []

color_value = np.linspace(1,512, int(opt.xy_dim) * int(opt.xy_dim))

i = 0
value_list = []
r_list = []
g_list = []
b_list = []
final_matrix = np.zeros((4,))
for x in range(0,cie.shape[0], int(opt.d_value)):
    for y in range(0,cie.shape[1], int(opt.d_value)):
            r_value = cie[x,y,0]
            g_value = cie[x,y,1]
            b_value = cie[x,y,2]
            value = color_value[i*int(opt.d_value)]
            
            a = np.array((value, r_value, g_value, b_value))
            if i == 0:
                final_matrix += a
            else:
                final_matrix = np.concatenate((final_matrix, a))
            i += 1
            
import json
data = [{
        "ColorSpace" : "RGB",
        "Name" : "Preset 2",
        "RGBPoints" : list(final_matrix)
}]


f_data = json.dumps(data, indent=4)
output_path = os.path.join(opt.output_dir, 'customize_colormap.json')
with open(output_path, 'w') as json_file:
    json_file.write(f_data)
        


