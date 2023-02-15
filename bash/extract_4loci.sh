#!/bin/bash
#extract four loci from given genomes


if [ ! -f blast_names.txt ]; then 
    ls ./assemblies/*.fasta > blast_names.txt
fi

while read FILE; do
    while read LINE; do
        ENTR=$(echo "$LINE" | awk '{print $2}')
        START=$(echo "$LINE" | awk '{print $9}')
        STOP=$(echo "$LINE" | awk '{print $10}')
        RANGE=$(echo "$LINE" | awk '{print $9"-"$10}')
        QUER=$(echo "$LINE" | awk '{print $1}')
        if [[ $STOP -gt $START ]]; then
            STR="plus"
            RANGE=$(echo "$LINE" | awk '{print $9"-"$10}')
        else
            STR="minus"
            RANGE=$(echo "$LINE" | awk '{print $10"-"$9}')
        fi
        if [[ $QUER = ITS_EU071918 ]]; then
            blastdbcmd -db ./assemblies/"$FILE" -dbtype nucl -entry "$ENTR" -range "$RANGE" -strand "$STR" >> ITS_gen.fa 
        elif [[ $QUER = LSU_EU071971 ]]; then
            blastdbcmd -db ./assemblies/"$FILE" -dbtype nucl -entry "$ENTR" -range "$RANGE" -strand "$STR" >> LSU_gen.fa 
        elif [[ $QUER = EF1_EU071866.1 ]]; then
            blastdbcmd -db ./assemblies/"$FILE" -dbtype nucl -entry "$ENTR" -range "$RANGE" -strand "$STR" >> EF1_gen.fa 
        elif [[ $QUER = BTUB_EU071837 ]]; then
            blastdbcmd -db ./assemblies/"$FILE" -dbtype nucl -entry "$ENTR" -range "$RANGE" -strand "$STR" >> BTUB_gen.fa 
        fi 
    done < ./blastOut/${FILE}_hits.txt
done < blast_names.txt