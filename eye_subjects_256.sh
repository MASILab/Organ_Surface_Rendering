#!/usr/bin/bash
# Creates checkerboard surfaces for each atlas label
atlasDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels/atlas"
transformsDir="/nfs/masi/leeh43/PHOTON_all_nii/QAed_images_MRI/unbiased_25_T2FLAIR/reg_output_sres"

for subject in {10730_20070517_MR_8,11156_20321114_MR_5,11298_19920723_MR_9,11441_19921123_MR_1,11447_20030427_MR_1}; do

	echo "Applying transform to subject ${subject}"

	labelDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels/${subject}"
	transformedLabelDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256/${subject}/transformed_labels"
	cbDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256/${subject}/checkerboard"
	inputDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256/${subject}/inputs"
	outputDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_256/${subject}/outputs"

	# Make folders if they don't exist
	mkdir -p ${cbDir} ${outputDir} ${inputDir} ${transformedLabelDir}

	for label in {1,3,5,7}; do

		# Make folder if it doesnt exist
		mkdir -p ${cbDir}/${label} ${outputDir}/${label} ${inputDir}/${label} ${transformedLabelDir}/${label}
			
		echo "Applying transformation to label ${label}"

		# Apply transformations to label
		antsApplyTransforms -d 3 -i ${labelDir}/${label}/${subject}_T2WFLAIR.nii.gz -r ${atlasDir}/${label}/atlasSeg_final.nii.gz -o ${transformedLabelDir}/${label}/${subject}_T2WFLAIR.nii.gz -n NearestNeighbor -t ${transformsDir}/MY${subject}*Warp.nii.gz -t ${transformsDir}/MY${subject}*GenericAffine.mat

		echo "Making checkerboard for label ${label}"

		# Generate checkerboard
		python checkerboard_generate.py --input_label ${transformedLabelDir}/${label}/${subject}_T2WFLAIR.nii.gz --grid_size 4 --view 0 --output_cb ${cbDir}/${label}/${subject}_T2WFLAIR.nii.gz --num_colors 255

		echo "Applying transformation to checkerboard for ${label}"

		# Apply transformations to checkerboard
		antsApplyTransforms -d 3 -i ${cbDir}/${label}/${subject}_T2WFLAIR.nii.gz -r ${atlasDir}/${label}/atlasSeg_final.nii.gz -o ${inputDir}/${label}/${subject}_T2WFLAIR.nii.gz -n NearestNeighbor -t ${transformsDir}/MY${subject}*Warp.nii.gz -t ${transformsDir}/MY${subject}*GenericAffine.mat

		echo "Making surface for label ${label}"

		# Create surface
		python convert_surface_vtk.py --input_dir ${transformedLabelDir}/${label} --cb_dir ${cbDir}/${label} --output_dir ${outputDir}/${label}

	done

done
