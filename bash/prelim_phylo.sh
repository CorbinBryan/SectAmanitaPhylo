#!/bin/bash

# A script to generate preliminary alignments and phylogenies from a prepped fasta file. 

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--input)
      arg_i="$2"
      shift
      shift
      ;;
    -o|--output)
      arg_o="$2"
      shift
      shift
      ;;
   -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" 

NOVNOM=$(echo "$arg_i" |  sed 's/prep_//g' | sed 's/.fasta//g')

mafft --auto --adjustdirectionaccurately ./RawData/prepped_fa/${arg_i} > ./DerivedData/prelim_al/mafft_${NOVNOM}.fa 

trimal -in ./DerivedData/prelim_al/mafft_${NOVNOM}.fa -out ./DerivedData/prelim_al/trimmed_${NOVNOM}.fa 

iqtree2 -s ./DerivedData/prelim_al/trim_${NOVNOM}.fa 

mkdir ./DerivedData/prelim_tre/${arg_o}
mv ./DerivedData/prelim_al/trim_${NOVNOM}.fa.* ./DerivedData/prelim_tre/${arg_o}
