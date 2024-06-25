#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 32g
#SBATCH -n 8
#SBATCH -t 1-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script is used to 1) filter contigs to a min length of 1kb, and
# 2) evaluate assembly statistics from the assemblies created by 00_assembly.bash & 001_assembly_megahit.bash

# Input: scaffolds.fasta files found under data/processed/assembly/"$sample"
#	 final.contigs.fa files found under data/processed/assembly_megahit/"$sample"
# Output: Assembly statistics will be deposited to data/processed/evaluation

module purge #removes any loaded modules
module load bbmap/39.06 

sample=$1

mkdir -p data/processed/evaluation/"$sample"

#copy metaspades assembly and rename it
cp data/processed/assembly/"$sample"/scaffolds.fasta data/processed/evaluation/"$sample"/"$sample"_metaspades.fasta

#copy megahit assembly and rename it
cp data/processed/assembly_megahit/"$sample"/final.contigs.fa data/processed/evaluation/"$sample"/"$sample"_megahit.fasta

#filter contigs to min length of 1000 bp
reformat.sh in=data/processed/evaluation/"$sample"/"$sample"_metaspades.fasta \
out=data/processed/evaluation/"$sample"/"$sample"_metaspades_trimmed.fasta minlength=1000

reformat.sh in=data/processed/evaluation/"$sample"/"$sample"_megahit.fasta \
out=data/processed/evaluation/"$sample"/"$sample"_megahit_trimmed.fasta minlength=1000

#run statswrapper on .fasta files
statswrapper.sh data/processed/evaluation/"$sample"/*.fasta >> data/processed/evaluation/full_assembly.stats

