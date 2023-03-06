# A script to make distance and maximum parsimony trees in R 
# Corbin Bryan, Feb. 28, 2023
# Input files shoudl be aligned .fastas 

##### Load pkgs and aligned .fa's #####
library(ape)
library(adegenet)
library(phangorn)
library(dplyr)
BTUB <- fasta2DNAbin(
  "/Users/corbinbryan/Documents/SectAmanitaPhylo/DerivedData/alignments/Test_BTUB_al_mafft.fasta"
  )
LSU <- fasta2DNAbin(
  "/Users/corbinbryan/Documents/SectAmanitaPhylo/DerivedData/alignments/Test_LSU_al_mafft.fasta"
)
ITS <- fasta2DNAbin(
  "/Users/corbinbryan/Documents/SectAmanitaPhylo/DerivedData/alignments/Test_ITS_al_mafft.fasta"
)
EF1 <- fasta2DNAbin(
  "/Users/corbinbryan/Documents/SectAmanitaPhylo/DerivedData/alignments/Test_EF1-A_al_mafft.fasta"
)
##### Computing distance Matrix ######

D_BTUB <- dist.dna(
  BTUB,
  model = "TN93"
  ) 
D_LSU <- dist.dna(
  LSU,
  model = "TN93"
) 
D_ITS <- dist.dna(
  ITS,
  model = "TN93"
) 
D_EF1 <- dist.dna(
  EF1,
  model = "TN93"
) 

##### Finding NJ Tree #### 

# Define list of dist matrices
dist_mats <- list(D_BTUB, D_LSU, D_ITS, D_EF1)
names(dist_mats) <- c("BTUB", "LSU", "ITS", "EF1")

# Set up list to store loop outputs
NJ_trees <- list()

# Loop--iterate over each distance matrix. 
for (i in 1:4) {
  NJ_trees[[i]] <- nj(dist_mats[[i]]) %>% ladderize()
} 
          # seqs too divergent for ITS, TEF1A
##### Plot NJ Tree #####
plot(NJ_trees[[1]], cex=.6)
title("Beta Tubulin Distance Tree")

plot(NJ_trees[[2]], cex=.6)
title("LSU Distance Tree")

##### Setting up files for Maximum Parsimony ##### 
ITS_2 <- as.phyDat(ITS)
LSU_2 <- as.phyDat(LSU)
BTUB_2 <- as.phyDat(BTUB)
EF1_2 <- as.phyDat(EF1)
##### Finiding initial trees, compute score of each #####
ITS.ini <- nj(dist.dna(ITS,model="raw")) ### NOTE seq's too divergent for NJ 
parsimony(ITS.ini, ITS_2)

LSU.ini <- nj(dist.dna(LSU,model="raw"))
parsimony(LSU.ini, LSU_2)

BTUB.ini <- nj(dist.dna(BTUB,model="raw"))
parsimony(BTUB.ini, BTUB_2)

EF1.ini <- nj(dist.dna(EF1,model="raw"))
parsimony(EF1.ini, EF1_2)

##### Find Max Pars. Tree #####
# ITS.pars <- optim.parsimony(ITS.ini, ITS_2)

LSU.pars <- optim.parsimony(LSU.ini, LSU_2)
#>Final p-score 949 after  7 nni operations 

#BTUB.pars <- optim.parsimony(BTUB.ini, BTUB_2)

#EF1.pars <- optim.parsimony(EF1.ini, EF1_2)

##### Plotting successful trees #### 
#plot(EF1.pars, cex=.6)
#title("Maximum Parsimony Tree for TEF1-Alpha")

plot(LSU.pars, cex=.6)
title("Maximum Parsimony Tree for LSU rDNA")
