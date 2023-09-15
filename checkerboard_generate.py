# -*- coding: utf-8 -*-
"""
Created on Sat Aug 15 00:53:45 2020

@author: peter

Modified by Adam Saunders
8/17/2023
- Now creates a single checkerboard pattern with the number of colors determined by your grid size
- Also added test option to show NIFTI
8/29/2023
- Added ability to control number of colors
"""

import os
import numpy as np

import os
import nibabel as nib
import numpy as np
import math
from PIL import Image

import argparse
parser = argparse.ArgumentParser(description='Scripts pipeline of generating vtk file for surface rendering')
# All working dirs
parser.add_argument('--input_label',  default='', 
                    help='Input label for generating same dimension checkerboard')

parser.add_argument('--grid_size',  default='8', 
                    help='Grid Size for checkerboard', type=int)

parser.add_argument('--view',  default='1', 
                    help='Choosing the planar view for checkerboard: 0: Axial, 1: Coronal, 2: Sagittal', type=int)

parser.add_argument('--output_cb',  default='', 
                    help='output path for checkerboard file in nifti format')

parser.add_argument('--num_colors', default='12', 
                    help='number of colors to use (including background) for checkerboard', type=int)

opt = parser.parse_args()

file_path = os.path.join(opt.input_label)
seg_nb = nib.load(file_path)
seg_data = seg_nb.get_fdata()
affine = seg_nb.affine
header = seg_nb.header

# Get foreground colors
fg_colors = opt.num_colors - 1

# Calculate number of blocks to use based on largest dimension
max_dim = np.max((seg_data.shape))
max_colors = math.ceil(max_dim / (2*opt.grid_size))
num_blocks = 2*max_colors

# Define blank matrix and cells
matrix = np.zeros((max_dim, max_dim))
grid = np.ones((opt.grid_size, opt.grid_size), dtype=int)
blank = np.zeros((opt.grid_size, opt.grid_size))

# Create block matrix, a matrix with all the values we need with grid size 1
blocks = np.zeros((num_blocks, num_blocks), dtype=int)
for i in range(0, num_blocks):
    for j in range(0, num_blocks):
        if (i + j) % 2 == 0:
            blocks[i][j] = 0
        else:
            blocks[i][j] = (i*num_blocks + j) % fg_colors + 1

# Repeat for grid size to create pattern
checkerboard_pattern = np.repeat(blocks, opt.grid_size, axis=1)
checkerboard_pattern = np.repeat(checkerboard_pattern, opt.grid_size, axis=0)

# Create final checkerboard based on view selected
checkerboard = np.zeros((seg_data.shape[0], seg_data.shape[1], seg_data.shape[2]))

if opt.view == 0:
    for i in range(seg_data.shape[2]):
        checkerboard[:,:,i] = checkerboard_pattern[:seg_data.shape[0],:seg_data.shape[1]]
elif opt.view == 1:
    for i in range(seg_data.shape[1]):
        checkerboard[:,i,:] = checkerboard_pattern[:seg_data.shape[0],:seg_data.shape[2]]
elif opt.view == 2:
    for i in range(seg_data.shape[0]):
        checkerboard[i,:,:] = checkerboard_pattern[:seg_data.shape[1],:seg_data.shape[2]]
        
output = nib.Nifti1Image(checkerboard, affine, header)
output_path = os.path.join(opt.output_cb)

nib.save(output, output_path)
        
        
        
