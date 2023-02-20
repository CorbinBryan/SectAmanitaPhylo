#!/bin/bash

cat($1 $2) | mafft-linsi --maxiterate 1000 > ${3}_al.fasta