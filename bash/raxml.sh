#!/bin/bash

# NOTE this script is set up to be run on a machine with RAxML

# A script to run raxml on a given data set
# Corbin T. Bryan, March 23, 2023
MSA="$1"

# Note IQTree model selector suggests: K3Pu+F+R3 

# STEP 1: Check if data is appropriate for RAxML-NG
raxml-ng --msa "$MSA".fasta \
--model GTR+G \
--check

# STEP 2: 
raxml-ng --msa "$MSA".fasta \ 
--model GTR+G \ 
--prefix "$MSA" --threads 2 --seed 2 #\   #commented out because not really required
#--all \ 
#--bs-metric fbp,tbe