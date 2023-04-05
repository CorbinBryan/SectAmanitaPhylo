# #!/bin/bash
# # filters fasta heads from NCBI blast. for use later in tree building (i.e., coloring taxa based on species ID), also prepping 
# # for ML 


awk '/>/ BEGIN{OFS = "_"}{
if($3=="sp.") 
    {
    name=$1,$2,$3,$4
    }
else if($3=="muscaria" && ($4=="var." || $4=="subsp.")) 
    {
    name=$1,$2,$3,$4,$5
    }
else
    {
    name=$1,$2,$3
    }
}{
    sub(/>/, name)
}' ${1} > name_prep_${1}