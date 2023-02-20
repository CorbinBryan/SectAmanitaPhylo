#!/bin/bash
# script to align loci; first two inputs should be absolute file paths to fasta files, third should be
#   the locus of interest
cat "$1" "$2" > ${3}_cat.fasta
# mafft perameters: linsi specifies the FFT-Ni algorithm, which performs the FFT and
#   reconducts the alignment until no higher score is reached. 
# maxiterate set to max to ensure quality alignment. 
# offset parameter remains unchanged at 0; no need to raise penalty of gap extensions for these loci. 
# no reason to raise gap opening penalty
# default scoring matrix should be fine (first iteration is like clustalW, requires scoring matrix)
# NOTE: less than 200 seqs, seqs less than 20,000 => settings are appropriate. 
mafft-linsi --maxiterate 1000 ${3}_cat.fasta > ${3}_al_mafft.fasta

# default parameters should suffice; no reason to attempt ensemble alignments. If alignment appears off, I will
#   conder re-running muscle with ensemble settings and examining the dispersion between them; could prevent bad alignments, 
#   and muscle has settings for this. 
muscle -align ${3}_cat.fasta -output ${3}_al_musc.fasta