#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 16g
#SBATCH -n 8
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes InStrain to profile and compare strain-level microdiversity between samples

# Inputs: 1) Alignment (.sam) file which InStrain will automatically sort and convert to .bam
#	  2) Representative genomes (.fasta) file
#	  3) Scaffold-to-bin (.stb) file if multiple genomes are concatenated to one .fasta file
#	  4) Gene (.fna) file from Prodigal (optional)

# Output: 1) InStrain profiles for each sample will be deposited in data/draft_genomes/"$pid"/dereplicated/instrain

# InStrain is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script,
# uncomment the following line to create the instrain environment in which InStrain is installed.
# Current version is 1.9.0 

module purge
module load anaconda/2021.11
# conda create -n instrain  -c conda-forge -c bioconda -c defaults instrain

conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/instrain

module load samtools/1.20

# Edit PID accordingly
pid=BMT102

mapping=data/draft_genomes/"$pid"/dereplicated/mapping

# Edit following variables to respective filepaths
ecoli=BMT102D-9_concoct.76
genomefile=data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes/"$ecoli".fa
genefile=data/draft_genomes/"$pid"/dereplicated/geneprofiling/"$ecoli".genes.fna
# Uncomment and input .stb filepath if required
#stbfile=

instrain=data/draft_genomes/"$pid"/dereplicated/instrain

mkdir -p "$instrain"

for file in "$mapping"/"$pid"*.sam
do
	sample=$(basename $file | sed 's/_.*//')
	echo running inStrain profile on $sample

	inStrain profile "$file" "$genomefile" -g "$genefile" -o "$instrain"/"$sample"_profile -p 8 
	#if stb file is required, add it using the -s flag 

done

#inStrain compare 
