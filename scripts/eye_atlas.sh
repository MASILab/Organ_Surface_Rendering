#!/usr/bin/bash
# Creates VTK surface of eye atlas

transformsDir="/nfs/masi/leeh43/PHOTON_all_nii/QAed_images_MRI/unbiased_25_T2FLAIR/reg_output_sres"
atlasDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256/atlas/atlas_template"
cbDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256/atlas/checkerboard"
inputDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256/atlas/inputs"
outputDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256/atlas/outputs"

# Loop over labels
for label in {atlas}; do #{1,3,5,7,atlas}

	# Copy label
	cp ${atlasDir}/atlasSeg_final.nii.gz ${inputDir}/label.nii.gz

	# Generate checkerboard pattern
	python checkerboard_generate.py --input_label ${atlasDir}/atlasSeg_final.nii.gz --grid_size 4 --view 0 --output_cb ${cbDir}/checkerboard.nii.gz --num_colors 256

	# Copy checkerboard
	cp ${cbDir}/checkerboard.nii.gz ${cbDir}/label.nii.gz

	# Apply transformation to checkerboard
	#antsApplyTransforms -d 3 -i ${cbDir}/checkerboard.nii.gz -r ${atlasDir}/atlasSeg_final.nii.gz -o ${inputDir}/checkerboard.nii.gz -n NearestNeighbor -t ${transformsDir}/MYtemplate0warp.nii.gz -t ${transformsDir}/MYtemplate0GenericAffine.mat

	# Generate .vtk
	python convert_surface_vtk.py --input_dir ${inputDir} --cb_dir ${cbDir} --output_dir ${outputDir}
done

# Perform for entire eye as well
#aDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas"

#mkdir -p ${aDir}

# Generate checkerboard pattern
#echo "Creating checkerboard"
#python checkerboard_generate.py --input_label ${aDir}/atlasSeg_final.nii.gz --grid_size 4 --view 0 --output_cb ${cbDir}/atlas/checkerboard.nii.gz
#
#echo "Generating .vtk"
## Generate .vtk
#python convert_surface_vtk.py --input_dir ${aDir} --cb_dir ${cbDir}/atlas --output_dir ${cbDir}/atlas

