#!/bin/bash
# A script to download files from genbank

file=$1

while read i; do
    efetch -db nuccore -id $i -format fasta 
done < "$file" 

