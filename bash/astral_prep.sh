#!/bin/bash

locus="$1"

grep '>' ./DerivedData/fully_processed_al/${locus}_ready.fa | cut -f 2- -d "_" > tmp1.txt

grep '>' ./DerivedData/fully_processed_al/${locus}_ready.fa | sed 's/>//g' > tmp2.txt  

awk 'BEGIN {FS="_"} FNR==NR { a[FNR""] = $0"\t"; next } { print a[FNR""], $0 }' tmp2.txt tmp1.txt > tmp3.txt

seqkit replace --quiet -p "(.+)" -r '{kv}'  -k tmp3.txt ./DerivedData/fully_processed_al/${locus}_ready.fa > ./DerivedData/for_astral_fa/for_a_${locus}.fasta

rm tmp1.txt tmp2.txt tmp3.txt

