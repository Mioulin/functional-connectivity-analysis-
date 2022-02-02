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

# Between-network-segregation

A resting-state functional connectivity (RSFC) matrix was obtained representing connectivity between each of the 7 RSN of interest. The time-series from the first step of the dual regression for each pair of RSNs, were entered into a GLM, which resulted in PE values representing the strength of functional connectivity between pairs of RSNs. The GLM was done twice with each RSN as a dependant variable in one model and as an independent variable in the second model, which were then averaged, to generate two 7 x 7 matrices for DMT and placebo. The difference between DMT and placebo was established by t-tests on each of the quadrants of the matrices (FDR corrected for multiple comparisons)

# Pairwise functional connectivity (fMRI)

The degree to which connectivity between pairs of areas in the brain were altered during DMT administration was tested via a data-driven approach. First, the dimensionality of fMRI data was reduced by obtaining the average activity of voxels for each of the 100 areas associated to the Schaeffer atlas.31 Then, Pearson correlational analyses was performed between each pair of the 100 areas for both DMT and placebo administration, which resulted in a connectivity matrix for each condition consisting in 100*100 connections (or ‘edges’). Finally, paired t-tests were performed for each of the edges, which resulted in the difference between DMT and placebo (FDR corrected for multiple comparisons)

# Global Functional Connectivity (fMRI)
Global functional connectivity was obtained by taking the average of the normalized Fisher Z score of each Pearson correlation coefficient values from each area of the brain to all other areas of the brain. In order to reduce the number of statistical tests, we consider the 100 regions of interest of the Schaeffer cortical atlas, resulting in 100 areas31 and added 12 subcortical areas from the AAL atlas.  Global connectivity at the network level was obtained by averaging the GFC values for all Schaeffer parcellations corresponding to each of the seven networks by Yeo et al.
