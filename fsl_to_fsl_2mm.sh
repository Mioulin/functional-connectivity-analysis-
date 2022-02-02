!/bin/bash
#
# Convert Yeo's 7 network liberal parcellation from FreeSurfer space to FSL MNI 2mm space.
# Reference network source:
# https://surfer.nmr.mgh.harvard.edu/fswiki/CorticalParcellation_Yeo2011
#
# 2016-02-20 
# Banich Lab
# University of Colorado Boulder
#
inputdir=${1:-$PWD}
outputdir=${2:-$PWD/2mm}
logdir=${3:-$PWD/log}
prefix=${4:-FSL_}
mkdir -p $outputdir
mkdir -p $logdir
let netno=1
for f in $inputdir/*_7Network*LiberalMask.nii.gz; do
    echo ... converting $f
    inputimg=`basename $f`
    outputimg=${prefix}${inputimg}
    logname=log${netno}.txt
    dispname=display${netno}
    mri_vol2vol --mov $inputdir/$inputimg --targ $FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz --regheader --o $outputdir/$outputimg --no-save-reg --interp nearest --precision uchar  > $logdir/$logname 2>&1
    echo "freeview $inputdir/$inputimg $outputdir/$outputimg&"  > $logdir/$dispname
    echo "fslview $FSLDIR/data/standard/MNI152_T1_2mm_brain.nii.gz $outputdir/$outputimg -l Random-Rainbow&"  >> $logdir/$dispname
    chmod +x $logdir/$dispname
    let netno=$netno+1
done