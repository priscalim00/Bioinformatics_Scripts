#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 250g
#SBATCH -n 32
#SBATCH -t 2-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script acts to assemble each sample into MAGs individually.

# Input: Host-removed reads found in data/working/host_removed/ -> copied to data/processed/reads
# Output: A number of output files will be deposited into data/processed/assembly/"$sample"
#         The main file of interest is scaffolds.fasta which contains the assembled MAGs

module purge #removes any loaded modules
module load spades/4.0.0

sample=$1

mkdir -p data/processed/reads 
cp -uv data/working/host_removed/"$sample"_host_removed_R1.fastq.gz data/processed/reads/"$sample"_processed_R1.fastq.gz
cp -uv data/working/host_removed/"$sample"_host_removed_R2.fastq.gz data/processed/reads/"$sample"_processed_R2.fastq.gz
 

cd data/processed/reads

R1="$sample"_processed_R1.fastq.gz
R2="$sample"_processed_R2.fastq.gz

echo running spades for sample "$sample"

spades.py --meta  -t 32 -k auto -1 "$R1" -2 "$R2" -o ../assembly/"$sample" 
