# -*- coding: utf-8 -*-
"""
Created on Sat Aug 15 00:53:45 2020

@author: peter
"""

import os
import numpy as np

import os
import nibabel as nib
import numpy as np
from PIL import Image

import argparse
parser = argparse.ArgumentParser(description='Scripts pipeline of generating vtk file for surface rendering')
# All working dirs
parser.add_argument('--input_label',  default='', 
                    help='Input atlas label for generating same dimension checkerboard')
   
parser.add_argument('--color_nums',  default='512', 
                    help='Number of Colors in checkerboard')

parser.add_argument('--grid_size',  default='8', 
                    help='Grid Size for checkerboard')

parser.add_argument('--view',  default='1', 
                    help='Choosing the planar view for checkerboard: 0: Axial, 1: Coronal, 2: Sagittal')

parser.add_argument('--output_cb',  default='', 
                    help='output path for checkerboard file in nifti format')

opt = parser.parse_args()

file_path = os.path.join(opt.input_label)
seg_nb = nib.load(file_path)
seg_data = seg_nb.get_data()
affine = seg_nb.get_affine()
header = seg_nb.get_header()

matrix = np.zeros((seg_data.shape[0], seg_data.shape[1]))
grid = np.ones((opt.grid_size,opt.grid_size), dtype=int)
blank = np.zeros((opt.grid_size,opt.grid_size))

row = 0
row_1_list = []
row_2_list = []
pattern_list = []
for i in range(1,opt.color_nums+1):
    grid[grid!=0] = i
    if row % 2 == 0:
        matrix_row = np.concatenate((blank, grid), axis=1)
        row_1_list.append(matrix_row)
        num_block = opt.color_nums / (opt.grid_size * 2)
        if len(row_1_list) == num_block:
            row_1 = np.hstack(row_1_list)
            pattern_list.append(row_1)
            row += 1
            row_1_list = []
    
    else:
        matrix_row = np.concatenate((grid, blank), axis=1)
        row_2_list.append(matrix_row)
        num_block = opt.color_nums / (opt.grid_size * 2)
        if len(row_2_list) == num_block:
            row_2 = np.hstack(row_2_list)
            pattern_list.append(row_2)
            row += 1
            row_2_list = []
            

checkerboard_pattern = np.vstack(pattern_list * 5)
checkerboard = np.zeros((seg_data.shape[0], seg_data.shape[1], seg_data.shape[2]))
if opt.view == 0:
    for i in range(seg_data.shape[2]):
        checkerboard[:,:,i] = checkerboard_pattern[:seg_data.shape[0],:seg_data.shape[1]]
elif opt.view == 1:
    for i in range(seg_data.shape[1]):
        checkerboard[:,i,:] = checkerboard_pattern[:seg_data.shape[0],:seg_data.shape[2]]
elif opt.view == 2:
    for i in range(seg_data.shape[0]):
        checkerboard[0,:,:] = checkerboard_pattern[:seg_data.shape[1],:seg_data.shape[2]]
        
output = nib.Nifti1Image(checkerboard, affine, header)
output_path = os.path.join(opt.output_cb)
nib.save(output, output_path)
        
        
        