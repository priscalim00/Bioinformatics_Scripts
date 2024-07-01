#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes CheckM to evaluated bins from DAS_Tool for completeness and contamination using marker genes.

# Input: Consolidated bins under data/processed/binning/das_tool/"$sample"

# Output: Bin statistics will be depostied under data/processed/binning/checkm/"$sample" 

# Installation of CheckM can be done via conda. The CheckM reference database must also be downloaded and unzipped in 
# your directory of choice - instructions for this are included in data/reference/obtain_reference.bash

# To install CheckM for the first time, uncomment the following lines:
## conda create -n checkm python=3.9
## conda activate checkm
## conda install -c bioconda numpy matplotlib pysam
## conda install -c bioconda hmmer prodigal pplacer
## pip3 install checkm-genome
## export CHECKM_DATA_PATH=/data/reference/CheckM/

module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/checkm

mkdir -p data/processed/binning/checkm

sample=$1
dastooldir=data/processed/binning/das_tool
checkmdir=data/processed/binning/checkm

checkm lineage_wf -t 16 -x fa "$dastooldir"/"$sample"/"$sample"_DASTool_bins "$checkmdir"/"$sample"

checkm qa "$checkmdir"/"$sample"/lineage.ms "$checkmdir"/"$sample"/ >  "$sample"_checkm_results.txt
