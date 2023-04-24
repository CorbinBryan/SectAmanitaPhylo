## Species Trees with ASTRAL 
1. I've prepared a script named `astral_prep.sh` that will repare .fa files to be made into trees for ASTRAL. It should edits the sequence headers in each `.fa` file in `./DerivedData/fully_processed_al`. Given the relatively low number of taxa, I went ahead and edited many of these by hand. This script is really only optimized for the ITS data, which contain many more accession and would take longer to edit by hand. Nevertheless, I ran the script on all four loci. 
```{sh}
LOCI=("ITS" "LSU" "EF1" "BTUB")

for locus in ${LOCI[@]}; do 
    ./bash/astral_prep.sh "$locus"
done
```
2. Then, `.ml.sh` was run again on each of the four alignments, and the RAxML-NG outputs were discarded. The four gene-trees were concatenated and saved as `gene_trees.tre`. 
3. ASTRAL was run as such:
```{sh}
astral -i gene_trees.tre -o species.tre
```