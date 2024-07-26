#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH --cpus-per-task 8
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script will use Bakta default settings to annotate draft genomes obtained from dRep. 
# These gene annotations can then be fed into InStrain if desired

# Input: Dereplicated bins located in data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes
# Output: Bakta output files will be deposited under "$bakta_dir" 

# Bakta is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script, 
# uncomment the following line to create the bakta environment in which bakta is installed
# conda create -n bakta -c conda-forge -c bioconda bakta

# Current version is 1.9.3

module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/bakta

pid=$1

genome_dir=data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes
bakta_dir=data/draft_genomes/"$pid"/bakta

for file in $genome_dir/*.fa
do
	filename=$(basename $file | sed 's/.fa//')
	bakta --db "$conda_envs"/bakta/db --output "$bakta_dir"/"$filename" --prefix "$filename" --threads 8 "$file"
done
