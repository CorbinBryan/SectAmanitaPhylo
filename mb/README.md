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
4. Run the following to complete a dry run for each locus:
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
---
**About MrBayes**  
MrBayes relies on the Metropolis-Hastings algorithm, which itself is a form of MCMC where novel states are derived taken from a probability distribution. Moreover, MrBayes uses a total of $n$ chains set by the user, where $n-1$ chains are heated. Chain swapping is also implemented and operates similarly to state propositions (i.e., an acceptance probability must be met). 

MCMC requires a lengthy burn in period and convergence and mixing must be manually assessed by the user. Moreover, the nature of the MCMC algorithm makes it highly computationally intensive. Note that MrBayes assumes the provided priors are informative and will require a large number of posterior samples in order to infer phylogenetic history with sufficient accuracy.

---
---