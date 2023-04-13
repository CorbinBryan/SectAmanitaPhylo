#!/bin/bash

# A script to prepare taxa names for downstream analysis using awk commands 

# .tsv with two columns: original name and new name. 

# Format of input is $./bash/prep_names.sh <old name> <new name>
awk 'BEGIN {
    OFS="_"
}
/^>/ {
if($3=="sp.") 
    print $1,$2,$3,$4"\t"$0
else if($3=="muscaria" && ($4=="var." || $4=="subsp."))
    print $1,$2,$3,$4,$5"\t"$0
else
    print $1,$2,$3"\t"$0
}' ./RawData/GB_fa/${1}_GenBank.fasta > temp_file.txt 

sed 's/>//g' temp_file.txt > temp_2.txt

seqkit replace --quiet -p "(.+)" -r '{kv}'  -k temp_2.txt ./RawData/GB_fa/${1}_GenBank.fasta > ./RawData/prepped_fa/prep_${1}.fasta

rm temp_file.txt temp_2.txt 