# -*- coding: utf-8 -*-
"""
Created on Fri Aug 14 14:04:07 2020

@author: peter

Modified 8/16/2023 by Adam Saunders
- Changed deprecated functions from nibabel and skimage
Modified 9/13/2023 by Adam Saunders
- Added support for anisotropic voxels
"""

import os
import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

from skimage import measure

def write_property(fn, v, f, prop): 
    fp = open(fn, 'w')
    len_v = v.shape[0]
    len_f = f.shape[0]
    
    fp.write("# vtk DataFile Version 3.0\nvtk output\nASCII\nDATASET POLYDATA\n")
    fp.write(f"POINTS {len_v} float\n") 
    for row in v:
        fp.write(f"{row[0]} {row[1]} {row[2]}\n")
    fp.write(f"POLYGONS {len_f} {len_f * 4}\n")
    for row in f:
        fp.write(f"3 {row[0]} {row[1]} {row[2]}\n")
    fp.write(f"POINT_DATA {len_v}\n")
    fp.write(f"FIELD ScalarData {len(prop)}\n")
    for key in prop.keys():
        fp.write(f"{key} 1 {len_v} float\n")
        val = prop[key]
        for num in val:
            fp.write(f"{num}\n") 
        fp.close()
    
import argparse
parser = argparse.ArgumentParser(description='Scripts pipeline of generating vtk file for surface rendering')
# All working dirs
parser.add_argument('--input_dir',  default='', 
                    help='root path of directory with organ ground truth label')

parser.add_argument('--cb_dir',  default='', 
                    help='root path of directory with atlas/deformed checkerboard')

parser.add_argument('--output_dir',  default='', 
                    help='root path of directory with surface rendered vtk file')

opt = parser.parse_args()


dir_path = os.path.join(opt.input_dir)
for label in os.listdir(dir_path):
    # label = 'TumaControl_001148_2752753200225131_201_transfered.nii.gz'
    # for label in os.listdir(dir_path):
    kidney_label = os.path.join(dir_path, label)
    checkerboard_pattern = os.path.join(opt.cb_dir, label)
    
    k_nib = nib.load(kidney_label)
    k_np = k_nib.get_fdata()
    k_spacing = k_nib.header.get_zooms()
    c_b = nib.load(checkerboard_pattern)
    c_np = c_b.get_fdata()
    
    # Generate surface with correct voxel spacing and isotropic spacing
    verts, faces, normals, values = measure.marching_cubes(k_np, 0, method='lewiner', spacing=k_spacing)
    verts_flat, _, _, _ = measure.marching_cubes(k_np, 0, method='lewiner')
    
    import math 
    new_list = []
    values_list = list(values)
    verts_list = list(verts_flat)
    for v in verts_list:
        # Sample value of checkerboard at isotropic spacing 
        x, y, z = v[0], v[1], v[2]
        new_value = c_np[int(x), int(y), int(z)]
        new_list.append(new_value)
        
        
    new_v = np.array(new_list)
    
    vtk_path = os.path.join(opt.output_dir)
    txt_path = os.path.join(vtk_path, label.split('.nii.gz')[0] + '.vtk')
    write_property(txt_path, verts, faces, {'feature_name': new_v})

