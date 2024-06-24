#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 12
#SBATCH -t 6:00:00
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script is used to 1) create bowtie2 indices for each assembly .fasta file,
#                        2) map reads from each sample to its respective assembly index

# Input: Filtered metaspades_trimmed.fasta files located in data/processed/evaluation
#	 Processed reads are located under data/processed/reads
# Output: Assembly indices will be deposited under data/processed/binning/indices
#	  Mapped reads (.bam files) will be depositied under data/processed/binning/mapping

module purge #removes any loaded modules
module load bowtie2/2.4.5
module load samtools/1.20

mkdir -p data/processed/binning

#First, create mapping index for each assembly
mkdir -p data/processed/binning/indices

file=data/processed/evaluation/$1/$1_metaspades_trimmed.fasta
bowtie2-build "$file" data/processed/binning/indices/$1

#Next, map processed reads to indices
mkdir -p data/processed/binning/mapping
mkdir -p data/processed/binning/mapping/$1

R1=data/processed/reads/$1_processed_R1.fastq.gz
R2=data/processed/reads/$1_processed_R2.fastq.gz

bowtie2 -p 8 -x data/processed/binning/indices/$1 -1 "$R1" -2 "$R2" \
-S data/processed/binning/mapping/$1/$1.sam 
samtools sort -n -m 5G -@ 2 -o data/processed/binning/mapping/$1/$1.bam data/processed/binning/mapping/$1/$1.sam
