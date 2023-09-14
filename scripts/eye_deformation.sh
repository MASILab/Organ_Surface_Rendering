#!/usr/bin/bash
# Creates checkerboard surfaces for each atlas label
labelDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels"
dataDir="/nfs/masi/leeh43/PHOTON_all_nii/QAed_images_MRI/unbiased_25_T2FLAIR"
templateDir="${dataDir}/unbiased_template"
transformsDir="${dataDir}/reg_output"
#labelDir="${dataDir}/label_fix"
workingDir="/nfs/masi/saundam1/outputs/eye_atlas/test/deformation"
cbDir="${workingDir}/checkerboard"
inputDir="${workingDir}/inputs"
outputDir="${workingDir}/outputs"

mkdir -p $workingDir $cbDir $inputDir $outputDir

for label in {1,3}; do

	echo "Generating surface for label ${label}"
	
	mkdir -p ${cbDir}/${label} ${inputDir}/${label} ${outputDir}/${label}

	for subject in {10730_20070517_MR_8,11447_20030427_MR_1}; do

		# Generate checkerboard in atlas space
		#$labelDir/$subject/all/${subject}_T2WFLAIR.nii.gz
		#$labelDir/atlas/atlasSeg_final.nii.gz	
		python checkerboard_generate.py --input_label $labelDir/$subject/all/${subject}_T2WFLAIR.nii.gz	--grid_size 4 --view 0 --output_cb ${cbDir}/${label}/${subject}_T2WFLAIR.nii.gz --num_colors 1

		# Apply transformation from subject to atlas space
		echo "Applying transformation from subject ${subject}"

		mkdir -p ${outputDir}/${label}/${subject}

		affine=$(find ${transformsDir} -type f -name "MY${subject}*GenericAffine.mat")
		invWarp=$(find ${transformsDir} -type f -name "MY${subject}*InverseWarp.nii.gz")
		warp=$(find ${transformsDir} -type f -name "MY${subject}*Warp.nii.gz")

		# Apply transformations to checkerboard 
		antsApplyTransforms -d 3 -i ${cbDir}/${label}/${subject}_T2WFLAIR.nii.gz -r ${labelDir}/atlas/atlasSeg_final.nii.gz -o ${inputDir}/${label}/${subject}_T2WFLAIR.nii.gz -n NearestNeighbor -t $warp -t $affine  

		echo "Making surface for subject ${subject}"

		# Create surface
		python convert_surface_vtk.py --input_dir ${labelDir}/$subject/${label} --cb_dir ${inputDir}/${label} --output_dir ${outputDir}/${label}/${subject}
	done
done


