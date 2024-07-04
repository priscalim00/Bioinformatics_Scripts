#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 2g
#SBATCH -n 8
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# Prior to running InStrain, the deplicated genome .fasta files must be prepped.
# This involves multiple steps:
# 1) Pulling all genomes of interest and concatenating them into a single .fasta file
# 2) Generating a scaffold to bin file (dRep)
# 3) Mapping raw reads for each sample to the concatenated genome file (Bowtie2)
# 4) Profiling genes (Prodigal)
# 5) Annotating genes (using database of choice -> TBD)

# This script addresses steps 4 & 5

module purge
module load prodigal/2.6.3

pid=BMT102
genomedir=data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes
genesdir=data/draft_genomes/"$pid"/dereplicated/geneprofiling

mkdir -p "$genesdir"

prodigal -i "$genomedir"/BMT102D-9_concoct.76.fa -d "$genesdir"/BMT102D-9_concoct.76.genes.fna -a "$genesdir"/BMT102D-9_concoct.76.genes.faa

# Gene annotation to be added