**Project Description**: This project will combine seq data from 25 *Amanita* genomes and publically available sequence data to aid in the construction of a multi-locus phylogeny of sect. *Amanita* of that that genus. 

The files ending in `_GenBank.txt` are text files containing the GenBank accession numbers for publically available sequences, labeled according to which taxon they belong. 
WORKING ORDER OF OPERATIONS
1. run `genbank_dl.sh`
2. run `prep_fa.sh`
3. run  `prelim_phylo.sh`, manually inspect phylo, list divergent sequences in `*_taxa_removed.txt`. EF1 required no removals 
4. run `remove_taxa.sh` for all loci but EF1-A. 