# Within-network-integrity

To analyze integrity of the resting-state networks (RSN), the following steps were performed:

1. Parcellation of 7 RSN Yeo atlas (the nonlinear MNI152 space package was downloaded from https://surfer.nmr.mgh.harvard.edu/fswiki/CorticalParcellation_Yeo2011)
2. Transform the Yeo networks from freesurfer space to 2mm FSL space (see script https://github.com/Mioulin/Within-network-integrity/blob/main/fsl_to_fsl_2mm.sh)
3. Make each network a seperate image, combine networks into 4d file, convert to 4mm space (see script https://github.com/Mioulin/Within-network-integrity/blob/main/separate_networks.sh)
4. Group ICA with FSL’s Melodic Tool (with 20 predefined components)
5. Compare Melodic ICA Components to Reference Networks. I uses an FSL utility fslcc to spatially correlate all of my components to some set of reference networks. An appropriate r-value threshold to determine if a component is significantly correlated with a reference networks. 
fslcc --noabs -p 3 -t .204 reference_networks/yeo2011_7_liberal_combined_4mm.nii.gz melodic_output.gica/groupmelodic.ica/melodic_IC.nii.gz
The output showed  significantly similar networks and stored  in networks.csv file
6. The next step was Dual Regression analysis. To investigate spatial and intensity differences in those resting-state networks as a function of group difference (dmt vs. placebo). Glm was configured to perform Single-Group Paired Difference (Paired T-Test) (see design.fsf)
7. To Identify networls of interests I got rid of results for networks that did not significantly correlate with reference networks (fslcc)
8. To determine if there is a grroup difference in the networks of interests a made a stat map (fslstats (p < 0.05 threshold))
9. Dual regression first used the components as regressors applied to the 4D BOLD datasets of each subject, which resulted in a matrix of time-series for each IC.
10. These time-series were then regressed into the same 4D scans to get a set of spatial maps specific to each subject. 
11. For each subject, the mean PE across voxels was calculated for each of the DMT/placebo scans for each condition, within each of the 7 RSNs of interest, with the resulting PE representing the integrity at each RSN. 
12. Paired t-tests were used to calculate the difference in integrity between conditions for each RSN (FDR corrected for multiple comparisons)
