#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem=16g
#SBATCH -n 12
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# Re-performing fastqc and multiqc on processed files
# Inputs are processed sequencing files located under data/working/host_removed/
# Outputs are fastqc reports to data/working/fastqc_final

module load fastqc

mkdir data/working/fastqc_final

sample=$1

fastqc -o data/working/fastqc_initial data/raw/"$sample"_R*.fastq.gz

fastqc -o data/working/fastqc_final data/working/host_removed/"$sample"_R*.fastq.gz


