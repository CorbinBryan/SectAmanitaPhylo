#!/bin/bash

# A script to run raxml-ng and iqtree2 on a given data set
# Corbin T. Bryan, March 23, 2023

MSA=$(echo "$1" | sed 's/_ready.fa//g')

# Note 1: IQTree model selector suggests: K3Pu+F+R3; nevertheless, I've chosen the general time reversible model for the RAxML run
#   with different rates (i.e., +G = Gama Distribution for independent rate estimates throughout diff. lineages), mostly for to 
#   compare the outputs from the two models. Moreover, I've chosen the --bs-metric flag, which will be left at it's default value, 
#   which is fbp, Felsenstein bootstrap. 

# I've had good luck with default IQtree params on past runs with similar data. For the time being, I'll stick with these, unless 
#   the output is nonsensical. 

# Note that both assume your input is a high quality alignment. RAxML-NG is more accurate than IQTree2, though IQTree2 does 
#   include added functionality (i.e., model finder) relative to RAxML-NG (and IQTree's original release). However, neither 
#   are guaranteed to give the ctual tree, and may both get stuck in local optima. IQTree2 tries to get around this by using 
#   multiple starting trees (which RAxML also uses) and random NNI perturbations. 

# Search algorithms differ in both. As mentioned, IQTree primarily uses NNI, whereas RAxML-NG primarily uses SPR moves to search 
#   tree space. Some believe that NNI moves are less likely to find the actual ML tree. In their original release, the authors note 
#   that this doesn't seem to hinder IQTree. Nevertheless, it should be taken into account here. At any rate, RAxML-NG appears to be 
#   more accurate than IQTree2. 

# STEP 1: Check if data is appropriate for RAxML-NG
raxml-ng --msa ./DerivedData/fully_processed_al/${MSA}_ready.fa \
--model GTR+G \
--check 

# STEP 2: Infer ML Phylo Using RAxML-NG 
raxml-ng --all --msa ./DerivedData/fully_processed_al/${MSA}_ready.fa \ 
--model GTR+G \ 
--prefix "$MSA" \
--threads 2 \
--seed 2 \
--bs-metric fbp

# STEP 3: Wrangle all outputs into single directory
mkdir RAxML_out_"$MSA"
for i in $(find . -type f ! -name "*.fasta"); do 
    mv ${i} ./RAxML_out_"$MSA"
done

tar -zcvf RAxML_out_${MSA}.tar.gz RAxML_out_"$MSA"

# Now, run IQtree2
# STEP 4: Infer ML Phylo using IQTree2 
iqtree -s ./DerivedData/fully_processed_al/${MSA}_ready.fa

# STEP 5: Wrangle IQtree outputs, transfer to your staging directory
mkdir iqtree_out_"$MSA"
for i in $(find . -type f ! -name "*.fasta"); do 
    mv "$i" ./iqtree_out_"$MSA"
done

tar -zcvf iqtree_out_"$MSA".tar.gz iqtree_out_"$MSA"

# STEP 6: remove all files from working directory 
rm -r iqtree_out_"$MSA"
rm -r RAxML_out_"$MSA"

rm "$MSA".fasta 