# #!/bin/bash
# # filters fasta heads from NCBI blast. for use later in tree building (i.e., coloring taxa based on species ID)

awk '/>/ {
if($3=="sp.") 
    {
    print $1"\t"$2,$3,$4
    }
else if($3=="muscaria" && ($4=="var." || $4=="subsp.")) 
    {
    print $1"\t"$2,$3,$4,$5
    }
else
    {
    print $1"\t"$2,$3
    }
}' ${1}