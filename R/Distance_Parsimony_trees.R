# A script to make distance and maximum parsimony trees in R 
# Corbin Bryan, Feb. 28, 2023
# Input files shoudl be aligned .fastas 

##### Load Pkgs, .fa files #####
library(ape)
library(adegenet)
library(phangorn)
library(dplyr)
ITS_mafft <- fasta2DNAbin(
  "/Users/corbinbryan/Documents/SectAmanitaPhylo/DerivedData/alignments/LSU_al_mafft_test.fasta"
  )
##### Constructing the distance tree ######
# Compute distance
D <- dist.dna(
  ITS_mafft,
  model = "K80"
  ) 
# Find Neighbor Joining Tree
NJ_tree <- nj(D)

