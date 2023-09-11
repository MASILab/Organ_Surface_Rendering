#!/usr/bin/bash
# Creates VTK surface of several eye subjects

transformsDir="/nfs/masi/leeh43/PHOTON_all_nii/QAed_images_MRI/unbiased_25_T2FLAIR/reg_output_sres"
atlasDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels"
transformedDir="/nfs/masi/saundam1/outputs/eye_atlas/labels_transformed"
labelsDir="/nfs/masi/leeh43/PHOTON_all_nii/QAed_images_MRI/unbiased_25_T2FLAIR/label_fix"
cbDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256"

# Loop over subjects
for subject in {10730_20070517_MR_8,11156_20321114_MR_5,11298_19920723_MR_9,11441_19921123_MR_1,11447_20030427_MR_1}; do

	mkdir -p ${transformedDir}/${subject} ${cbDir}/${subject}
	
	# Apply transformations to label
	antsApplyTransforms -d 3 -i ${labelsDir}/${subject}_T2WFLAIR.nii.gz -r ${atlasDir}/atlas/atlasSeg_final.nii.gz -o ${transformedDir}/${subject}/${subject}_T2WFLAIR.nii.gz -n NearestNeighbor -t ${transformsDir}/MY${subject}*Warp.nii.gz -t ${transformsDir}/MY${subject}*GenericAffine.mat

	# # Generate checkerboard patten
	python checkerboard_generate.py --input_label ${transformedDir}/${subject}/${subject}_T2WFLAIR.nii.gz --grid_size 4 --view 0 --output_cb ${cbDir}/${subject}/checkerboard.nii.gz --num_colors 256


	# Apply deformation to checkerboard
	antsApplyTransforms -d 3 -i ${cbDir}/${subject}/checkerboard.nii.gz -r ${atlasDir}/atlas/atlasSeg_final.nii.gz -o ${cbDir}/${subject}/${subject}_T2WFLAIR.nii.gz -n NearestNeighbor -t ${transformsDir}/MY${subject}*Warp.nii.gz -t ${transformsDir}/MY${subject}*GenericAffine.mat

	# # Generate .vtk
	python convert_surface_vtk.py --input_dir ${transformedDir}/${subject} --cb_dir ${cbDir}/${subject} --output_dir ${cbDir}/${subject}

done
