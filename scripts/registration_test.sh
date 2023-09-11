# Test registration
atlasDir="/nfs/masi/saundam1/outputs/eye_atlas/atlas_labels/atlas"
dataDir="/nfs/masi/leeh43/PHOTON_all_nii/QAed_images_MRI/unbiased_25_T2FLAIR"
templateDir="${dataDir}/unbiased_template"
transformsDir="${dataDir}/reg_output"
labelDir="${dataDir}/label_fix"
workingDir="/nfs/masi/saundam1/outputs/eye_atlas/test"
cbDir="${workingDir}/checkerboard"
inputDir="${workingDir}/inputs"
outputDir="${workingDir}/outputs"

mkdir -p $inputDir $outputDir

for subject in {10730_20070517_MR_8,11156_20321114_MR_5,11298_19920723_MR_9,11441_19921123_MR_1,11447_20030427_MR_1}; do
	affine=$(find ${transformsDir} -type f -name "MY${subject}*GenericAffine.mat")
	invWarp=$(find ${transformsDir} -type f -name "MY${subject}*InverseWarp.nii.gz")
	warp=$(find ${transformsDir} -type f -name "MY${subject}*Warp.nii.gz")

	cp ${labelDir}/${subject}_T2WFLAIR.nii.gz $inputDir
	cp ${atlasDir}/atlasSeg_final.nii.gz $inputDir

	# Apply transformations
	antsApplyTransforms -d 3 -v 1 -i ${labelDir}/${subject}_T2WFLAIR.nii.gz -r ${atlasDir}/atlasSeg_final.nii.gz -o ${outputDir}/${subject}_T2WFLAIR.nii.gz -n NearestNeighbor -t $warp -t $affine

done
