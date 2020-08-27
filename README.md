# Organ_Surface_Rendering

This repository includes codes for efficient generating surface rendering with 2D CIELa*b* colormap checkerboard pattern 

by Peter Lee

## Usage

### Executables
There are in total 4 python files: customize_colormap.py (Customize your own 2D colormap with CIELa*b*), binary_checkerboard_generate.py (Generate binary checkerboard pattern as nifti format (value: 0 and 1)), 512_checkerboard_generate.py (Generate multi-values checkerboard pattern as nifti format (value range: 1 - 512)) and convert_surface_vtk.py (Convert checkerboard nifti to vtk file for surface visualization).

## Step-by-Step Pipeline

### 1) Create your own customized 2D colormap with CIELAB color space
The CIELAB color space expresses color as three values: L* for the lightness from black (0) to white (100), a* from green (-) to red (+), and b* from blue (-) to yellow (+). Since 512 by 512 2D colormap will generate a large amount of colors, a downsample factor is used to reduce the numbers of color sample for better visualization. The generated .json file as output, can be input into paraview (A public, open-source visualization platform for surface and volume) as colormap.

Parameters for generating 2D colormap:
1) xy dimension (xy_dim): 512 (Default)
2) brigheness value (bright_value): 0.8 (Default, range: 0 - 1)
3) Downsample factor of color (d_value): 16 (Default)
4) Output directory (output_dir): '' (Default)

'''bash
python customize_colormap.py --xy_dim 512 --bright_value 0.8 --d_value 16 --output_dir '/nfs/masi/.....'
'''