#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 100g
#SBATCH --cpus-per-task 4
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script uses Kraken2 and Bracken to annotate processed reads with taxonomic classifications and 
# estimated relative abundances based on the NCBI Refseq database
