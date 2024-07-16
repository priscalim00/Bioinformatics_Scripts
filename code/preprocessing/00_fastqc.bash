#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem=16g
#SBATCH -n 12
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script generates individual fastqc reports for each sample as well as a combined multiqc report for all samples
# Inputs are raw sequencing files located under data/raw/
# Outputs are fastqc reports to data/processed/fastqc/

module load fastqc

sample=$1

mkdir -p data/working/fastqc_initial

fastqc -o data/working/fastqc_initial data/raw/"$sample"_*_R*_001.fastq.gz


