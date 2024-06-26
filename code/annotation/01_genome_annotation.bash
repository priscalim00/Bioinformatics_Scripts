#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH --cpus-per-task 4
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script will use ShortBRED program with the CARD reference database to profile protein families within our draft assemblies and 
# identify AMR genes.

# Input: 
# Output: 


module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/

sample=$1

