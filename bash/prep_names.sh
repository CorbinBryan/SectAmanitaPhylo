#!/bin/bash

# A script to prepare taxa names for downstream analysis using awk commands 

# .tsv with two columns: original name and new name. 
awk 'BEGIN {
    OFS="_"
}
/^>/ {
if($3=="sp.") 
    print $1,$2,$3,$4"\t"$0
else if($3=="muscaria" && ($4=="var." || $4=="subsp."))
    print $0"\t"$1,$2,$3,$4,$5"\t"$0
else
    print $0"\t" $1,$2,$3"\t"$0
}' ${1} > temp_file.txt 

sed 's/>//g' temp_file.txt > temp_2.txt

seqkit replace --quiet -p "(.+)" -r '{kv}'  -k temp_2.txt ${1} > p_${1}

rm temp_file.txt temp2_file.txt