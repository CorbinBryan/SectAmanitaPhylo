#!/bin/bash

# a script to remove poorly aligned sequences from a given alignment, $1
# takes one argument: the absolute path to the alignment fasta. 

# taxa to be removed must be put into a seperate file, taxa_removed.txt

# $1 is argument for locus 

while read ID; do
    seqkit grep -rvip "^${ID}" ${1}
done < ${1}_taxa_removed.txt