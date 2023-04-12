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
4. run `mb [NEXUS FILE]` on each 
5. Examine the tracers provided by the MrBayes program to assess convergence and mixing. 