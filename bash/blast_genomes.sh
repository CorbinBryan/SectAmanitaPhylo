#!/bin/bash
# a script to blast seq from four loci against 25 genomes
# note: most unzip your assembly and have in subdirectory 
# Chris, if you're reading this then change 4Loci_for_blast.fa to [MATINGTYPES].fa

FILE=$1 

if [ ! -d ./blastOut ]; then
    mkdir ./blastOut; 
elif [ ! -d miniconda3 ]; then
    cp /staging/bryan7/blast.tar.gz .
    chmod 644 blast.tar.gz
    tar -zxvf blast.tar.gz
elif [ ! -d ./assemblies]; then
    tar -zxvf assemblies.tar.gz
else 
    makeblastdb -in ${FILE} -dbtype nucl
    blastn -db ./${FILE} -query 4Loci_for_blast.fa -outfmt 6 -max_target_seqs 2 -num_threads 4 -out ./blastOut/${FILE}_hits.txt
fi

if [ $(ls ./blastOut | wc -l) == 25 ]; then
    tar -czvf blastOut.tar.gz ./blastOut
    mv blastOut.tar.gz /staging/bryan7/
fi