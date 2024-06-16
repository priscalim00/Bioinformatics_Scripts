#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 128g
#SBATCH -n 32
#SBATCH -t 2-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script acts to assemble each sample into MAGs individually.

# Input: Host-removed reads found in data/working/host_removed/ -> copied to data/processed/reads
# Output: A number of output files will be deposited into data/processed/assembly/"$sample"
#         The main file of interest is scaffolds.fasta which contains the assembled MAGs

module purge #removes any loaded modules
module load spades/4.0.0

mkdir data/processed/reads 
cp data/working/host_removed/*.fastq.gz data/processed/reads 

#renaming files
for file in data/processed/reads/*_host_removed_*.fastq.gz
do
        file=$(ls $file)
        new_file=${file///host_removed/processed}
        mv -n "$file" "$new_file" &
done
wait

mkdir data/processed/assembly

cd data/processed/reads

for file in *R1.fastq.gz 
do 
	R1=$(ls $file)
	R2=${R1//R1.fast1.gz/R2.fastq.gz} 
	sample=$(ls $file | sed 's/_.*//')

	spades.py --meta -k auto -1 "$R1" -2 "$R2" -o ../assembly/"$sample" &
done
wait

