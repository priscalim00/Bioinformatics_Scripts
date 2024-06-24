#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 8g
#SBATCH -n 4
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# Scripts 03-05 each use a different program to perform binning. This one utilizes MetaBAT2
# Each program is a separate script so that they can be submitted as separate jobs and run independently.
# The bins will then be consolidated in script 06 using DASTools


# Input: Alignment .bam files located under data/processed/binning and assembly .fasta files located under data/processed/trimmed_assemblies
# Output: Bins will be deposited under data/processed/binning/metabat2

# Metabat2 is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script, 
# uncomment the following line to create the metabat2 environment in which metabat2 is installed
# Current version is  2.12.1

# conda create --name metabat2 -c bioconda/label/cf201901 metabat2
eval "$(conda shell.bash hook)"
conda activate metabat2

mkdir -p data/processed/binning/metabat2
mkdir -p data/processed/binning/metabat2/$1

cd data/processed/binning/metabat2/$1

assembly=../../../evaluation/$1/$1_metaspades_trimmed.fasta
mapping=../../mapping/$1/$1.bam

runMetaBat.sh "$assembly" "$mapping" 



