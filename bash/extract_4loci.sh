#!/bin/bash
#extract four loci 

mkdir ./Genome_fastas 
while read FILE; do
    for ROW in $(cat ./blastOut/${FILE}_hits.txt | wc -l | seq); do
        ENTR=$(awk -v awkvar="$ROW" 'FNR == ROW {print $2}' ./blastOut/${FILE}_hits.txt)
        START=$(awk -v awkvar="$ROW" 'FNR == ROW {print $9}' ./blastOut/${FILE}_hits.txt)
        STOP=$(awk -v awkvar="$ROW" 'FNR == ROW {print $10}' ./blastOut/${FILE}_hits.txt)
        if [[ $STOP -gt $START ]]; then
            STR="+"
            RANGE=$(echo "$START""-""$STOP")
        else
            STR="-"
            RANGE=$(echo "$STOP""-""$START")
        fi 
        blastdbcmd -db ./assemblies/${FILE} -dbtype nucl -entry "$ENTR" -range "$RANGE" -strand "$STR" -out 
    done 
done < blast_names.txt