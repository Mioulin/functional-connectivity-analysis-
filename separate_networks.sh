#!/bin/bash
# 
# Use fslmaths with -thr and -uthr options to extract
# each individual network value and save in net/value.
# Concatenate networks temporally.
#
# 2016-02-20 
# Banich Lab
# University of Colorado Boulder
#
mkdir -p net
for f in 2mm/*Networks_*.nii.gz; do
    b=`basename $f`
    let i=1
    max=`fslstats $f -R | awk '{printf("%d", $2)}'`
    while [ $i -le $max ]; do
        mkdir -p net/$i
        f2=net/$i/net${i}_${b}
        fslmaths $f -thr $i -uthr $i $f2 
        let i=$i+1
    done
done

fslmerge -t yeo2011_7_liberal_combined.nii.gz `ls net/*/*.nii.gz`
flirt -in yeo2011_7_liberal_combined.nii.gz -ref yeo2011_7_liberal_combined.nii.gz -out yeo2011_7_liberal_combined_4mm.nii.gz -applyisoxfm 4