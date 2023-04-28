#!/bin/bash 

grep "$1" update_${2}_ready.fa | cut -f1 -d "_" | sed 's/>//g'  
