# Test if surface is being created correctly
labelDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels"
workingDir="/nfs/masi/saundam1/outputs/eye_atlas/test"
cbDir="${workingDir}/checkerboard"
outputDir="${workingDir}/outputs"
subject="11156_20321114_MR_5"

# Generate checkerboard
python checkerboard_generate.py --input_label ${labelDir}/$subject/all/${subject}_T2WFLAIR.nii.gz --grid_size 4 --view 0 --output_cb ${cbDir}/${subject}_T2WFLAIR.nii.gz --num_colors 11


# Create surface
python convert_surface_vtk.py --input_dir ${labelDir}/$subject/all --cb_dir ${cbDir}/ --output_dir ${outputDir}/
