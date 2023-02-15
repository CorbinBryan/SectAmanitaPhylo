#!/bin/bash
# a script to blast seq from four loci against 25 genomes
# Chris, if you're reading this then change 4Loci_for_blast.fa to [MATINGTYPES].fa

for FILE in $(ls ./assemblies | cat); do
    makeblastdb -in ./assemblies/"$FILE" -dbtype nucl
    blastn -db ./assemblies/"$FILE" -query 4Loci_for_blast.fa -outfmt 6 -max_target_seqs 2 -num_threads 4 -out ./blastOut/"$FILE"_hits.txt
done