#!/bin/bash
# A script to download files from genbank given accession nos. 

if [ ! -d ./RawData/GB_fa ]; then 
    mkdir ./RawData/GB_fa
fi

for i in $(ls ./RawData/GB_acc_no | cat); do
    if [ ! -f ./RawData/GB_fa/${i} ]; then 
        touch ./RawData/GB_fa/${i}.fasta
    else 
        rm ./RawData/GB_fa/${i}.fasta
    fi 

    while read acc; do
    FIRST=$(echo "$acc" | awk '{print $1}')
    if [ "$FIRST" ! == "#" ]; then
        efetch -db nucleotide -id "$acc" -format fasta >> ./RawData/GB_fa/${i}.fasta
    fi
    done < ./RawData/GB_acc_no/${i}
done