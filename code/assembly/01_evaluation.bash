#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 32g
#SBATCH -n 8
#SBATCH -t 1-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script is used to 1) filter contigs to a min length of 1kb, and
# 2) evaluate assembly statistics from the assemblies created by 00_assembly.bash

# Input: scaffolds.fasta files found under data/processed/assembly/"$sample"
# Output: Filtered contigs will be deposited to data/processed/trimmed_assemblies/ 
#	  Assembly statistics will be deposited to data/processed/evaluation/

module purge #removes any loaded modules
module load bbmap/39.06 

mkdir data/processed/trimmed_assemblies
mkdir data/processed/evaluation

#First, filter contigs to a minimum length of 1000bp as anything shorter than this is not useful
cd data/processed/assembly/

for sample in *
do
	reformat.sh in="$sample"/scaffolds.fasta \
	out=../trimmed_assemblies/"$sample"_scaffolds_trimmed.fasta \
	minlength=1000 &
done
wait

#Next, we will generate summary statistics
cd ../trimmed_assemblies

for file in *.fasta
do
	sample=$(ls $file | sed 's/_.*//')

	stats.sh in="$file" > ../evaluation/"$sample".stats &
done
wait
