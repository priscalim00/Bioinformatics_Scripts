#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 8
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes dRep to dereplicate genomes obtained from the same PID

# Input: All the consolidated bins from DAS_Tool for the PID of interest

# Output: Dereplicated genomes for the PID of interest will be deposited in data/draft_genomes/"$pid"

# dRep is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script,
# uncomment the following line to create the drep environment in which dRep is installed.
# Current version is 2.0.0

module load anaconda/2021.11
# conda create -n drep drep

conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/drep

pid=$1 #sample name contains PID and timepoint, e.g. BMT101D1: PID = BMT101 & timepoint = D1

echo Running dRep script for PID:"$pid"

mkdir -p data/draft_genomes/"$pid"/dereplicated

bindir=data/draft_genomes/"$pid"/all_bins
outdir=data/draft_genomes/"$pid"/dereplicated
checkmdir=data/draft_genomes/"$pid"/checkm

# Since we ran CheckM separately, we need to provide dRep with external genome information via a .csv file
# I've taken the CheckM results file and edited it manually in Excel. 
# This file is found in "$checkmdir"/"$pid"_checkm_drep.csv

dRep dereplicate "$outdir" -g "$bindir"/*.fa --debug --processors 8 --genomeInfo "$checkmdir"/"$pid"_checkm_drep.csv   




