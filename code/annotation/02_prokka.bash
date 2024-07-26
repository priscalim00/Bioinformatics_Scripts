#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH --cpus-per-task 4
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script will use Prokka default settings to annotate draft genomes obtained from dRep. 
# These gene annotations can then be fed into InStrain if desired

# Input: Dereplicated bins located in data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes
# Output: Prokka returns a bunch of different output files under "$prokka_dir" 

# Prokka is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script, 
# uncomment the following line to create the prokka environment in which prokka is installed
# conda create -n prokka -c conda-forge -c bioconda -c defaults prokka

# Current version is 1.14.6

# Note: Prokka has a "metagenome" setting for highly fragmented genomes. However, this setting seems to confuse Prodigal,
# the gene prediction software Prokka relies on. Prodigal ends up using different genetic codes to predict genes and may put 
# a stop codon in between a gene sequence. Prokka will return this warning: Terminator codon inside CDS! when that happens.
# The creator of Prokka recommended omitting the --metagenome flag when working with high quality genomes even if they were assembled
# from metagenomic samples.
# Since our dereplicated genomes have gone through strict completeness/contamination filtering and are generally pretty high quality,
# I've elected to omit the --metagenome flag for this analysis.

module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/prokka

pid=$1

genome_dir=data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes
prokka_dir=data/draft_genomes/"$pid"/prokka

for file in $genome_dir/*.fa
do
	filename=$(basename $file | sed 's/.fa//')
	prokka --outdir "$prokka_dir"/"$filename" --prefix "$filename" "$file"
done
