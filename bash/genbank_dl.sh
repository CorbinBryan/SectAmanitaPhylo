#!/bin/bash
# A script to download files from genbank given accession nos. 

for FILE in $(ls ./GB_acc_no/*_GenBank); do
    epost -db nuccore -input "$FILE" | efetch -format fasta > "$FILE".fa
done