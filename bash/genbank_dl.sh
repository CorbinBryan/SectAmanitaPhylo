#!/bin/bash
# A script to download files from genbank given accession nos. 

for FILE in $(ls ~/SectAmanitaPhylo/RawData/GB_acc_no); do 
#    touch ${FILE}.fa
    epost -db nuccore -input ~/SectAmanitaPhlyo/RawData/GB_acc_no/${FILE} -format acc | efetch -format fasta > ${FILE}.fa
    if 
done 
