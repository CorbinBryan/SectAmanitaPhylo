#!/bin/bash
# A script to download files from genbank

file=$1

$(cat ~/SectAmanitaPhylo/RawData/GB_acc_no/${file}) | while read i; do
    esearch -db nucleotide -query "$i" | efetch -format fasta
done >> ~/SectAmanitaPhylo/DerivedData/${file}.fasta

