#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 2g
#SBATCH -n 2
#SBATCH -t 6:00:00
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes dRep to dereplicate genomes obtained from the same PID

# Input:

# Output:

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

