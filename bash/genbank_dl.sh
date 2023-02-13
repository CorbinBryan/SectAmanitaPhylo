#!/bin/bash
# A script to download files from genbank

file=$1
name=$2 

$(cat ~/SectAmanitaPhylo/RawData/GB_acc_no/${file}) | while read i; do
    esearch -db nucleotide -query "$i" | efetch -format fasta
done >> ~/SectAmanitaPhylo/DerivedData/${name}.fasta

