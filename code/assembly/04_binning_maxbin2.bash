#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 2g
#SBATCH -n 4
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# Scripts 03-05 each use a different program to perform binning. This one utilizes MaxBin2
# Each program is a separate script so that they can be submitted as separate jobs and run independently.
# The bins will then be consolidated in script 06 using DASTools


# Input: Assembly .fasta files are located under data/processed/trimmed_assemblies and 
#        processed reads .fastq.gz files are located under data/processed/reads
# Output: Bins will be deposited under data/processed/binning/maxbin2

# MaxBin2 is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script,
# uncomment the following line to create the maxbin2 environment in which maxbin2 is installed.

# Current version is 2.2.7

# conda create --name maxbin2 maxbin2
module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/maxbin2

mkdir -p data/processed/binning/maxbin2
mkdir -p data/processed/binning/maxbin2/$1

# Note: currently unsure if maxbin2 takes .gz files, if script fails due to this, uncomment the following lines:

# cd data/processed/reads
# gzip -dk *.fastq.gz
# cd ../../..

assembly=data/processed/evaluation/$1/$1_metaspades_trimmed.fasta
abundance=data/processed/binning/mapping/$1/$1_abundance.txt

run_MaxBin.pl -contig "$assembly" -abund "$abundance" -out data/processed/binning/maxbin2/$1/$1
