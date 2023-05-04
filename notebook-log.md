**Project Description**: This project uses publically available GenBank accession to construct a Maximum Likelihood and Bayesian gene and species trees of 21 taxa in sect. *Amanita*. Four loci (TEF1-$\alpha$, $\beta$-Tubulin, ITS1, and LSU) were used. As many individuals (i.e., accessions) as could be gathered for each locus for each taxon were gathered from GenBank manually. 


## Prepping and aligning sequencers
The files ending in `_GenBank.txt` are text files containing the GenBank accession numbers for publically available sequences, labeled according to which taxon they belong (see: `./RawData/GB_acc_no` for the initial GenBank accessions)
WORKING ORDER OF OPERATIONS
1. run `genbank_dl.sh` (outputs files into `./RawData/GB_fa`)
2. run `prep_fa.sh` (outputs files into `./RawData/prepped_fa`)
3. run  `prelim_phylo.sh`, manually inspect phylo _and_ the alignment, list sequences which do _not_ clearly form a clade with members of it's species. Do this for each locus. Note that EF1 required no removals. Remove them from the original fasta (in `.RawData/GB_fa`) file manually. The `prelim_phylo.sh` script will put all preliminary trees in `./DerivedData/prelim_tre`. 
>**_Note:_** This script calls both MAFFT, TrimAl, and IQTree2 in this order to produce a single gene tree for each locus in a single step. 
4. Realign the original sequences in `./RawData/GB_fa` using `./bash/alignment.sh`, which calls MAFFT's L-INS-i algorithm, which it's most accurate algorithm. Note that `--adjustdirection` is invoked. This is done by default by MUSCLE, which is also called by this script. This script stores the alignments in `./DerivedData/alignments`
5. Manually examine the alignments. When I did this, the MUSCLE alignment appeared poorer than the MAFFT alignment. As such, mafft alignments were used for all downstream analyses. Then run `trimal -in [alignment] -out [trimmed alignmet]` on each alignment and store the results in `./DerivedData/fully_processed_al`. 

>The final accession numbers for GenBank sequences used in this analysis (i.e., after preliminary analysis) can be found in `./sp_acc_nos_final` in this repository.

---
**About MUSCLE:**
MUSCLE uses k-mer based distance metricrs to construct an UPGMA tree to determine the order of alignments. Pairwise sequences are then aligned, then profiles are aligned. The distance tree is then refined with an updated distance metric, and the alignment is refined for any taxa whose placement in the tree changes. This process is then performed until no better alignment is produced. 

Even MUSCLE's progressive approach suffers from the "greedines" of the Needleman-Wunsch algorithm. Thus, errors made early in the alignment will reamin until the alignment process is finished. 

---


---
**About MAFFT:**
MAFFT constructs it's distance tree based on 6-mers shared between sequences. This guide tree determines the order of progressive alignment. It then under goes an iterative process wherein the guide tree is refined, and the alignment refined accordingly thereafter. 

MAFFT generally does quite well for most types of sequence data. However, it assumes that the provided reads are of high quality. Moreover, like many other alignment softwares, errors made 
early in the alignment process will remain in and impact the final alignment it produces. 

---


---
**About trimAl:**
trimAl evaluates both the gap percentage and residue identity to remove poorly aligned or low quality regions of an alignment. I have allowed it's default algorithm to select the threshold for removal. It will either select one of two algorithms: a strict algorithm (where gaps and similarity metrics are used to determine the appropriate threshold values) and a gappy-out algorithm, which uses gap-statistics to clean the alignment. 

Alignment trimmers have a drawback in that every nucleotide removed from an alignment removes data. These softwares don't truly "know" whether or not a particular base is informative, and may remove relevant sequence data in the trimming process. 

---
## MrBayes
1. copy each of the fully processed `.fasta` files into `./DerivedData/for_mb`, rename as `*_mb.fa`. Because MrBayes allows for only one taxa to serve as the outgroup, remove all but one of the sequences for _A. pantherina_ in each of the `*_mb.fa`. Manually each outgroup on the appropriate line of the MrBayes block to be appended to each of the Nexus files used for MrBayes. 
2. Prepare a MrBayes block `.nex` file for the `.fa` files containing gene sequences, save as `*_mb.nex` in `./mb`. Note that these are different that the prepped `*_mb.fa` files mentioned above and stored in a different directory.
3. Run the following script to convert each `.fa` file into `.nex` format: 
```{sh}
for FILE in $(ls ./DerivedData/for_mb/*.fa); do
    NOVNOM=$(echo "$FILE" | awk 'BEGIN { FS = "/" } ; {print $4}' | sed 's/_mb.fa//g')  # Get locus name w/o extentions
    seqret -sequence "$FILE" -outseq ./mb/${NOVNOM}_seq.nex -osformat nexus             # convert to nexus 
    cat ./mb/${NOVNOM}_seq.nex ./mb/${NOVNOM}_mb.nex > ./mb/${NOVNOM}_ready.nex         # append mb block to end of seq nexus file
done
```  
> **_NOTE:_** Manually examine each `*_ready.nex` file to ensure EMBOSS' `seqret` did it's job. Then run `sed 's/antherina//g' [NEXUS FILE]` on each nexus file. EMBOSS' seqret will truncate `.fa` headers. 
1. Run the following to complete a dry run for each locus:
```{sh}
# define array
LOCI=("ITS" "BTUB" "LSU" "EF1")

# loop over array, replace each char in nex with gap and run mb 
for locus in ${LOCI[@]}; do
    sed 's/[ATCG]/-/g' ./mb/${locus}_ready.mb > ./mb/${locus}_dry.mb
    cd ./mb 
    mb ${locus}_dry.mb
done
```
5. run `mb [NEXUS FILE]` on each 
6. Examine the tracers provided by the MrBayes program to assess convergence and mixing. 
---
**About MrBayes**  
MrBayes relies on the Metropolis-Hastings algorithm, which itself is a form of MCMC where novel states are derived taken from a probability distribution. Moreover, MrBayes uses a total of $n$ chains set by the user, where $n-1$ chains are heated. Chain swapping is also implemented and operates similarly to state propositions (i.e., an acceptance probability must be met). 

MCMC requires a lengthy burn in period and convergence and mixing must be manually assessed by the user. Moreover, the nature of the MCMC algorithm makes it highly computationally intensive. Note that MrBayes assumes the provided priors are informative and will require a large number of posterior samples in order to infer phylogenetic history with sufficient accuracy.

---

## IQTree2 & RAxML-NG 
1. For my own convenience, I have a single script that calls both RAxML and IQtree2. This is a one step process I've automated with my `ml.sh` script. To save time, I like to loop over each of my alignments with the following: 
```{sh}
for FILE in $(ls ./DerivedData/fully_processed_al); do 
    ./bash/ML.sh "$FILE"
done
```
---
**About IQTree2:**
IQTree2's hill climbing algorithm only uses fast NNI moves to search tree space. It also implements radonom NNI moves to avoid becoming arrested in local maximums while traversing tree space. Notably, this program also uses multiple starting trees. It makes 100 MP, optimizes them with lazy subtree rearrangements, and selects only the top twenty for use of starting. 

The software is not without limitations. Like all hill-climbing approaches, it may become arrested in a local maximum. If a plateau is reached, it will only perform 100 more iterations of it's radom NNI perturbation algorithm. This is a relatively small number of iterations, and more may be required to find the optimum. An additional drawback is that the program only uses NNI moves, which are less conservative and may impact the algorithm's ability to escape local maxima. 

---


---
**About RAxML-NG:**
RAxML-NG's algorithm implements only SPR moves to traverse tree space. I belive that RAxML-NG's current implementation uses multiple MP startint trees, performs lazy subtree rearrangments, and then selects the best starting trees, in a manner very similar to IQTree2. Although previous versions often skipped promoising moves, this has been rectified in RAxML-NG. 

Despite being the most accurate software using maximum likelihood to infer gene trees, there is still no guarantee that the tree output by RAxML-NG will be correct. Like many packages, it stops after a certain number of iterations if a tree does not change. This may be problematic for plateaus that occupy a substantial portion of tree space. Moreover, RAxML-NG has the same problem all software do: if you put garbage in, you get garbage out. That is, the software assumes the provided alignment is accurate. 

Both RAxML-NG and IQTree2 are not robust to gene flow, which may bias their results. Furthermore, if a partitioned analaysis is performed, neither is particular robust to incomplete lineage sorting. 

---
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

---
**About ASTRAL:** 
ASTRAL uses a multispecies coalescent approach to modeling the probability of species given a set of gene trees. It assumes that the individuals sampled are members of populations. Briefly, this model allows for the inference of coalescent times (in coalescent units), the probability of individual gene trees, and the maximally likely species tree given a set of gene trees. 

Sequence data contains more information than the trees inferred from it. ASTRAL accepts concatenated gene trees as input. It requires a relatively large number of gene trees to sufficiently infer a species tree. 

---

## Other Software Used:
---
**BEAST2** was used to infer gene trees using the HKY+G4 model on each gene tree. Default priors were used, along with a strict clock. I settled with these because they are relatively reasonable, and produced a tree with relatively high posterior support. This is also true of my analysis of species trees with starBEAST3, a package available for BEAST2 through BEAUti. I loaded my fully processed fastas into BEAUti and exported `.xml` files for use with BEAST2. 

MCMC was allowed to run for 15 million iterations in the starBEAST3 analysis and 10 million iterations in the BEAST2 analysis. The default population model was used for my analysis with starBEAST3, a long with a strict clock. The Yule model was chosen because the Birth-Death model (which requires an additional tree prior hyperparameter for species death) was not only longer but also resulted in a poorer tree. Perhaps the extra parameter necessitated a longer burn in period? Nevertheless, the trees weren't particularly good, nor was mixing (see `TreeMakgn.Rmd` for mixing and tree visualization using tracerer and ggtree respectively). Trees produced with the Yule prior could've had better mixing, but it wasn't too bad. 

The analysis was performed twice, once sampling only from the prior distribution and once from the posterior (there is a box for this under the "Run" tab). The posterior and priors were plotted in R. The priors seemed to contribute well to the posterior.

This analysis reveals the only major limitation of BEAST2: the use of MCMC itself. Although very powerful, it is also computationally expensive due to the number of iterations that are required for the MCMC chain to traverse the posterior distribution. It requires a long burn in period for the algorithm to even begin to approach optimal values. Also, if the priors are relatively uninformative or do not contribute much to the posterior, the result will be heavily biased towards the maximumally likely tree under ML inference. 

---

## Visualizing trees: 
* see `TreeMakign.Rmd` under `./R`. 

## Distance Trees: 
* see `./R/Distance_Parsimony_trees.R`