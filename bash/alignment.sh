#!/bin/bash
# script to align fasta files containing sequences for a given locus, which is the only argument 
# input can be one of the following strings, given my naming conventions: ITS, LSU, BTUB or EF1-A 
if [ ! -d ./concat_fas ]; then 
    mkdir ./concat_fas
else
    rm -r ./concat_fas
    mkdir ./concat_fas
fi 

if [ ! -d ./alignments ]; then 
    mkdir ./alignments
else 
    rm -r ./alignments
    mkdir ./alignments
fi

cat ./SectAmanitaData/GBFastas/${1}_GenBank.fa\
 ./SectAmanitaData/Genome_fastas/${1}_gen.fa > ./concat_fas/${1}_cat.fasta
# mafft perameters: linsi specifies the FFT-Ni algorithm, which performs the FFT and
#       reconducts the alignment until no higher score is reached. 
# maxiterate set to max to ensure quality alignment. 
# offset parameter remains unchanged at 0; no need to raise penalty of gap extensions for these loci. 
# no reason to raise gap opening penalty
# default scoring matrix should be fine (first iteration is like clustalW, requires scoring matrix)
# NOTE: less than 200 seqs, seqs less than 20,000 => settings are appropriate. 
# Limitations: so called "greedy algorithm" problem is still in play in MAFFT; however, MAFFT 
#       utilizes many of CLUSTALW's adjustments to improve the initial quality of the alignment and 
#       prevent initial errors from being fixed early in the alignment process. 


mafft-linsi --adjustdirectionaccurately --maxiterate 1000 ./concat_fas/${1}_cat.fasta > ./alignments/${1}_al_mafft.fasta

# default parameters should suffice; no reason to attempt ensemble alignments. If alignment appears off, I will
#   conder re-running muscle with ensemble settings and examining the dispersion between them; could prevent bad alignments, 
#   and muscle has settings for this. 
# Limitations: muscle's dynamic and iterative approaches, which guide tree partitioning to improve final alignments, 
#       does still suffer from the greedy algorithm. 
# Additionally: Muscle is markedly slower than MAFFT, even when --maxiterate 1000 and LINSI are specified
muscle -align ./concat_fas/${1}_cat.fasta -output ./alignments/${1}_al_musc.fasta