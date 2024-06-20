#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 256g
#SBATCH -n 16
#SBATCH -t 2-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script acts to assemble each sample into MAGs individually using megahit.

conda activate megahit 

mkdir -p data/processed/assembly_megahit

cd data/processed/reads

for file in *R1.fastq.gz 
do 
	R1=$(ls $file)
	R2=${R1//R1.fastq.gz/R2.fastq.gz} 
	sample=$(ls $file | sed 's/_.*//')

	megahit -1 "$R1" -2 "$R2" -o ../assembly_megahit/"$sample" &
done
wait

