#!/usr/bin/bash
# Creates checkerboard surfaces for each atlas label
labelDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels/atlas"
cbDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_12/atlas/checkerboard"
outputDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_12/atlas/outputs"

# Make folders if they don't exist
mkdir -p ${cbDir} ${outputDir}

for label in {1,3,5,7}; do

	# Make folder if it doesnt exist
	mkdir -p ${cbDir}/${label} ${outputDir}/${label}

	echo "Making checkerboard for label ${label}"

	# Generate checkerboard
	python checkerboard_generate.py --input_label ${labelDir}/${label}/atlasSeg_final.nii.gz --grid_size 4 --view 0 --output_cb ${cbDir}/${label}/atlasSeg_final.nii.gz --num_colors 11

	echo "Making surface for label ${label}"

	# Create surface
	python convert_surface_vtk.py --input_dir ${labelDir}/${label} --cb_dir ${cbDir}/${label} --output_dir ${outputDir}/${label}

done
