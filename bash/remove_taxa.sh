#!/bin/bash


seqkit grep -f ./${1}_taxa_removed.txt -v ./RawData/prepped_fa/prep_${1}.fasta -o 3_${1}_tmp.fa 

#seqkit rmdup -n ${3}_tmp.fa > 2_${3}_tmp.fa

#seqkit rmdup -s 2_${3}_tmp.fa > 3_${3}_tmp.fa 

mafft --auto --adjustdirectionaccurately 3_${1}_tmp.fa > 4_${1}_tmp.fa

trimal -in 4_${1}_tmp.fa -out ./DerivedData/fully_processed_al/${1}_ready.fa 

rm ./*_tmp.fa 

