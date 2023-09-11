#!/usr/bin/bash
# Creates checkerboard surfaces for each atlas label
atlasDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels/atlas"
dataDir="/nfs/masi/leeh43/PHOTON_all_nii/QAed_images_MRI/unbiased_25_T2FLAIR"
templateDir="${dataDir}/unbiased_template"
transformsDir="${dataDir}/reg_output"
labelDir="${dataDir}/label_fix"
workingDir="/nfs/masi/saundam1/outputs/eye_atlas/checkerboard_12/deformation"
cbDir="${workingDir}/checkerboard"
inputDir="${workingDir}/inputs"
outputDir="${workingDir}/outputs"

mkdir -p $workingDir $cbDir $inputDir $outputDir

for label in {1,3,5,7}; do

	echo "Generating surface for label ${label}"
	
	mkdir -p ${cbDir}/${label} ${inputDir}/${label} ${outputDir}/${label}

	for subject in {10730_20070517_MR_8,11156_20321114_MR_5,11298_19920723_MR_9,11441_19921123_MR_1,11447_20030427_MR_1}; do

		# Generate checkerboard
		python checkerboard_generate.py --input_label ${labelDir}/${subject}_T2WFLAIR.nii.gz --grid_size 4 --view 0 --output_cb ${cbDir}/${label}/atlasSeg_final.nii.gz --num_colors 11

		# Apply transformation from atlas to subject space
		echo "Applying transformation from subject ${subject}"

		mkdir -p ${outputDir}/${label}/${subject}

		affine=$(find ${transformsDir} -type f -name "MY${subject}*GenericAffine.mat")
		invWarp=$(find ${transformsDir} -type f -name "MY${subject}*InverseWarp.nii.gz")
		warp=$(find ${transformsDir} -type f -name "MY${subject}*Warp.nii.gz")

		# Apply transformations to checkerboard 
		antsApplyTransforms -d 3 -i ${cbDir}/${label}/atlasSeg_final.nii.gz -r ${atlasDir}/${label}/atlasSeg_final.nii.gz -o ${inputDir}/${label}/atlasSeg_final.nii.gz -n NearestNeighbor -t $warp -t $affine  

		echo "Making surface for subject ${subject}"

		# Create surface
		python convert_surface_vtk.py --input_dir ${atlasDir}/${label} --cb_dir ${inputDir}/${label} --output_dir ${outputDir}/${label}/${subject}
	done
done


