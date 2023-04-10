**Project Description**: This project will combine seq data from 25 *Amanita* genomes and publically available sequence data to aid in the construction of a multi-locus phylogeny of sect. *Amanita* of that that genus. 

The files ending in `_GenBank.txt` are text files containing the GenBank accession numbers for publically available sequences, labeled according to which taxon they belong. 
WORKING ORDER OF OPERATIONS
1. run `genbank_dl.sh`
2. run `prep_fa.sh`
3. run  `prelim_phylo.sh`, manually inspect phylo, list sequences which do _not_ clearly form a clade with other members of its species in `*_taxa_removed.txt`. Do for each locus. Note that EF1 required no removals. 
4. run `remove_taxa.sh` for all loci but EF1-A. 
5. manually edit `BTUB_ready.fa` to reflect accurate names.
6. copy each of the fully processed `.fasta` files into `./DerivedData/for_mb`, rename as `*_mb.fa`. Because MrBayes allows for only one taxa to serve as the outgroup, remove all but one of the sequences for _A. pantherina_ in each of the `*_mb.fa`. Manually each outgroup on the appropriate line of the MrBayes block to be appended to each of the Nexus files used for MrBayes. 
7. Run the following script to convert each file into `.nex` format: 
```{sh}
for FILE in $(ls ./DerivedData/for_mb/*.fa); do
    NOVNOM=$(echo "$FILE" | awk 'BEGIN { FS = "/" } ; {print $4}' | sed 's/_mb.fa//g')
    seqret -sequence "$FILE" -outseq ./mb/${NOVNOM}_seq.nex -osformat nexus
    cat ./mb/${NOVNOM}_seq.nex ./mb/${NOVNOM}_mb.nex > ./mb/${NOVNOM}_ready.nex
done
```  
Manually examine each `*_ready.nex` file to ensure EMBOSS' `seqret` did it's job. 
8. MrBayes doesn't like to run on Mac, at present. As such, use `scp` to traansfer each file to the cluster for actually running MrBayes. This requires a conversion script to and from mac, for some reason. 
```{sh}
 #!/bin/sh
 tr "\015" "\012" < $1 > $2
```