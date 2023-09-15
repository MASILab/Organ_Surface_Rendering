# Atlas Surface Rendering

By Peter Lee, modified by Adam Saunders

This repository contains code for generating a VTK surface rendering from NIFTI images to show the deformation from registering subjects to an atlas. 

## Usage

### Executables
There are in total 3 python files: customize_colormap.py (customize your own 2D colormap with CIELa*b*), checkerboard_generate.py (generate a checkerboard file) and convert_surface_vtk.py (Convert checkerboard NIFTI to VTK file for surface visualization).

## Step-by-Step Pipeline

### 1) \[Optional\] Create your own customized 2D colormap with CIELAB color space
The CIELAB color space expresses color as three values: L* for the lightness from black (0) to white (100), a* from green (-) to red (+), and b* from blue (-) to yellow (+). Since 512 by 512 2D colormap will generate a large amount of colors, a downsample factor is used to reduce the numbers of color sample for better visualization. The generated .json file as output, can be input into Paraview (A public, open-source visualization platform for surface and volume) as colormap. 

We provide a 2D colormap with cielab_colormap.json. You can directly apply this colormap in Paraview for convenience. If not, just run the following argurments to adjust your own parameters for colormap.

Parameters for generating 2D colormap:
1) xy dimension (xy_dim): 512 (Default)
2) brigheness value (bright_value): 0.8 (Default, range: 0 - 1)
3) Downsample factor of color (d_value): 16 (Default)
4) Output directory (output_dir): '' (Default)

```bash
python customize_colormap.py --xy_dim 512 --bright_value 0.8 --d_value 16 --output_dir '/colormaps/...'
```

### 2) Generate Checkerboard Pattern
A 3D label image is used as an input for generating the checkerboard pattern with the same dimension as the input image.

Both python files are called with the following arguments:
1) 3D label image (input_label): '' (Default)
3) Checkerboard grid size (grid_size): 8 (Default)
4) Planar view of checkerboard (view): 1 (Default, 0: Axial, 1: Coronal, 2: Sagittal)
5) Output file (output_cb): '' (Default)
6) Number of colors (num_colors): Number of colors to use in checkerboard, including background

```bash
python checkerboard_generate.py --input_label '/inputs/.../label.nii.gz' --grid_size 8 --view 1 --output_cb '/checkerboards/.../checkerboard.nii.gz'
```

### 3) Extract vertices information and generating surface as .vtk file
The checkerboard pattern contains voxel-wise information as NIFTI format in step 2. We then extract all vertices, faces and normals using marching cubes and use these informations to generate a VTK file for visualization. The Python file convert_surface_vtk.py efficienly overlays the checkerboard to the label and output as surface VTK file, which can be easily visualized by directly input into Paraview.

If the surface rendering is not smoothed enough for visualization, there is a filter in Paraview called Smooth and you can apply a certain number of iterations to smooth the surface for better visualization of the checkerboard.

Parameters to generate the vtk file:
1) label directory (input_dir): '' (Default)
2) Checkerboard directory (cb_dir): '' (Default)
3) VTK output directory (output_dir): '' (Default)


```bash
python convert_surface_vtk.py --input_dir 'inputs/...' --cb_dir 'checkerboards/...' --output_dir '/outputs/...'
```

The vtk file can be visualized in Paraview as the below screenshot:
![kidney_atlas_result_surface](https://user-images.githubusercontent.com/54121206/91504224-1eeded80-e892-11ea-85cb-eab33fb6aabd.png)

For questions, contact ho.hin.lee@vanderbilt.edu.
