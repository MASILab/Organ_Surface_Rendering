# Organ_Surface_Rendering

This repository includes codes for efficient generating surface rendering with 2D CIELa*b* colormap checkerboard pattern 

by Peter Lee

## Usage

### Executables
There are in total 4 python files: customize_colormap.py (Customize your own 2D colormap with CIELa*b*), binary_checkerboard_generate.py (Generate binary checkerboard pattern as nifti format (value: 0 and 1)), 512_checkerboard_generate.py (Generate multi-values checkerboard pattern as nifti format (value range: 1 - 512)) and convert_surface_vtk.py (Convert checkerboard nifti to vtk file for surface visualization).

## Step-by-Step Pipeline

### 1) Create your own customized 2D colormap with CIELAB color space
The CIELAB color space expresses color as three values: L* for the lightness from black (0) to white (100), a* from green (-) to red (+), and b* from blue (-) to yellow (+). Since 512 by 512 2D colormap will generate a large amount of colors, a downsample factor is used to reduce the numbers of color sample for better visualization. The generated .json file as output, can be input into Paraview (A public, open-source visualization platform for surface and volume) as colormap. 

I have personally customized a 2D colormap with filename cielab_colormap.json. You can directly apply this colormap in Paraview for convenience. If not, just run the following argurments to adjust your own parameters for colormap.

Parameters for generating 2D colormap:
1) xy dimension (xy_dim): 512 (Default)
2) brigheness value (bright_value): 0.8 (Default, range: 0 - 1)
3) Downsample factor of color (d_value): 16 (Default)
4) Output directory (output_dir): '' (Default)

```bash
python customize_colormap.py --xy_dim 512 --bright_value 0.8 --d_value 16 --output_dir '/nfs/masi/...'
```

### 2) Generate Checkerboard Pattern (Binary / Multi-value)
Two python files are reponsible for generating binary and mutli-value checkerboard pattern as nifti format: binary_checkerboard_generate.py and checkerboard_generate.py respectively. A 3D label image (For example: atlas target label/image) is used as an input for generating the checkerboard pattern with the same dimension as the input image.

Both python files are called with the following arguments:
1) 3D label image (input_label): '' (Default)
3) Checkerboard grid size (grid_size): 8 (Default)
4) Planar view of checkerboard (view): 1 (Default, 0: Axial, 1: Coronal, 2: Sagittal)
5) Output file (output_cb): '' (Default)

```bash
python binary_checkerboard_generate.py --input_label '/nfs/masi/...' --grid_size 8 --view 1 --output_cb '/nfs/masi/.../checkerboard_binary.nii.gz'
python checkerboard_generate.py --input_label '/nfs/masi/...' --grid_size 8 --view 1 --output_cb '/nfs/masi/.../checkerboard_512.nii.gz'
```

### 3) Extract vertices information and generating surface as .vtk file
The checkerboard pattern contains voxel-wise information as nifti format in step 2. We then extract all vertices, faces and normals using marching cubes and use these informations to generate a vtk file for visualization. The python file convert_surface_vtk. efficienly overlay the checkerboard to the label and output as surface vtk file, which can be easily visualized by directly input into Paraview.

If the surface rendering is not smoothed enough for visualization, there is a filter in Paraview called Smooth and you can apply a certain number of iterations to smooth the surface for better visualization of the checkerboard.

Parameters to generate the vtk file:
1) label directory (input_dir): '' (Default)
2) Checkerboard directory (cb_dir): '' (Default)
3) Vtk output directory (output_dir): '' (Default)


```bash
python binary_checkerboard_generate.py --input_dir '/nfs/masi/...' --cb_dir '/nfs/masi/...' --output_dir '/nfs/masi/...'
```

The vtk file can be visualized in Paraview as the below screenshot:
![kidney_atlas_result_surface](https://user-images.githubusercontent.com/54121206/91504224-1eeded80-e892-11ea-85cb-eab33fb6aabd.png)

If there are any problems or need help for this github, feel free to contact me through email ho.hin.lee@vanderbilt.edu

Peter Lee
