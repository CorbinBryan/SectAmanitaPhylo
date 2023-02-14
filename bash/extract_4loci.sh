#!/bin/bash
#extract four loci from given genomes

if [ ! -d ./Genome_fastas ]; then
mkdir ./Genome_fastas
fi

for FILE in $(cat blast_names.txt); do
    for i in $(seq $(cat ./blastOut/${FILE}_hits.txt | wc -l)); do
        ENTR=$(awk -v awkvar="$i" 'FNR == i {print $2}' ./blastOut/${FILE}_hits.txt)
        START=$(awk -v awkvar="$i" 'FNR == i {print $9}' ./blastOut/${FILE}_hits.txt)
        STOP=$(awk -v awkvar="$i" 'FNR == i {print $10}' ./blastOut/${FILE}_hits.txt)
        RANGE=$(awk -v awkvar="$i" 'FNR == i {print $9"-"$10}')
        echo $RANGE
        if [[ $STOP -gt $START ]]; then
            STR="plus"
        else
            STR="minus"
        fi 
        blastdbcmd -db ./assemblies/${FILE} -dbtype nucl -entry "$ENTR" -range "$RANGE" -strand "$STR" -out ./Genome_fastas/${FILE}_out.fa 
    done 
done