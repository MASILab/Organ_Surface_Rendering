#!/usr/bin/bash
# Creates VTK surface of eye atlas

transformsDir="/nfs/masi/leeh43/PHOTON_all_nii/QAed_images_MRI/unbiased_25_T2FLAIR/reg_output"
atlasDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels/atlas_roi"
cbDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard"

# Loop over labels

# Generate checkerboard pattern
python checkerboard_generate.py --test True --input_label ${atlasDir}/atlasSeg_final.nii.gz --grid_size 16 --view 0 --output_cb ${cbDir}/checkerboard_test.nii.gz

# Apply deformation to checkerboard
# Transformation is a stack, so it is applied in reverse order
antsApplyTransforms -d 3 -i ${cbDir}/checkerboard_test.nii.gz -r ${atlasDir}/atlasSeg_final.nii.gz -o ${cbDir}/atlasSeg_final.nii.gz -n NearestNeighbor -t ${transformsDir}/MY13853_20141114_MR_5_T2WFLAIR241Warp.nii.gz -t ${transformsDir}/MY13853_20141114_MR_5_T2WFLAIR240GenericAffine.mat

# Generate .vtk
python convert_surface_vtk.py --input_dir ${atlasDir} --cb_dir ${cbDir} --output_dir ${cbDir}
