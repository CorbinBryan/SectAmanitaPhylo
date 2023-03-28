#!/bin/bash

# A script to run raxml on a given data set
# Corbin T. Bryan, March 23, 2023

MSA="$1"

# Note IQTree model selector suggests: K3Pu+F+R3; nevertheless, I've chosen the general time reversible model for the RAxML run
#   with different rates (i.e., +G = Gama Distribution for independent rate estimates throughout diff. lineages)

# STEP 1: Check if data is appropriate for RAxML-NG
raxml-ng --msa "$MSA".fasta \
--model GTR+G \
--check 

# STEP 2: Infer ML Phylo Using RAxML-NG 
raxml-ng --all --msa "$MSA".fasta \ 
--model GTR+G \ 
--prefix "$MSA" --threads 2 --seed 2

# STEP 3: Wrangle all outputs into single directory
mkdir RAxML_out_"$MSA"
for i in $(find . -type f ! -name "*.fasta"); do 
    mv ${i} ./RAxML_out_"$MSA"
done

tar -zcvf RAxML_out.tar.gz RAxML_out

mv RAxML_out.tar.gz /staging/bryan7 

# STEP 4: Infer ML Phylo using IQTree2 
iqtree -s "$MSA".fasta 

# STEP 5: Wrangle IQtree outputs, transfer to your staging directory
mkdir iqtree_out_"$MSA"
for i in $(find . -type f ! -name "*.fasta"); do 
    mv "$i" ./iqtree_out_"$MSA"
done

tar -zcvf iqtree_out_"$MSA".tar.gz iqtree_out_"$MSA"
mv iqtree_out_"$MSA".tar.gz /staging/bryan7 

# STEP 6: remove all files from working directory 
rm -r iqtree_out_"$MSA"
rm -r RAxML_out_"$MSA"

rm "$MSA".fasta 