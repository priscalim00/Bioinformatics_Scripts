#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 2-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script acts to assemble each sample into MAGs individually using megahit.


R1=$1_processed_R1.fastq.gz
R2=$1_processed_R2.fastq.gz
sample=$1

mkdir -p  data/processed/assembly_megahit
megahit -1 data/processed/reads/"$R1" -2 data/processed/reads/"$R2" -o data/processed/assembly_megahit/"$sample"

