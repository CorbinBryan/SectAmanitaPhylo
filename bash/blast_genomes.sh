#!/bin/bash
# a script to blast seq from four loci against 25 genomes
# note: most unzip your assembly and have in subdirectory 
# either remove the loop or specify 100 cores, 4/genome
mkdir ./blastOut

for FILE in ./assemblies; do 
    makeblastdb -in ${FILE} -dbtype nucl
    blastn -db ./${FILE} -query Amu_4_loci.fa -outfmt 6 -max_target_seqs 2 -num_threads 4 -out ./blastOut/${FILE}_hits.txt
done 

gzip ./blastOut