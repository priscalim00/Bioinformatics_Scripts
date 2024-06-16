#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 128g
#SBATCH -n 32
#SBATCH -t 2-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script is used to 1) create bowtie2 indices for each assembly .fasta file,
#                        2) map reads from each sample to its respective assembly index

# Input: Filtered scaffolds_trimmed.fasta files located in data/processed/trimmed_assemblies
#	 Processed reads are located under data/processed/reads
# Output: Assembly indices will be deposited under data/processed/indices
#	  Mapped reads (.bam files) will be depositied under data/processed/binning

module purge #removes any loaded modules
module load bowtie2/2.4.5
module load samtools/1.20

mkdir -p data/processed/indices
mkdir -p data/processed/binning

#First, create mapping index for each assembly
cd data/processed/trimmed_assemblies/

for file in *.fasta
do
	sample=$(ls $file | sed 's/_.*//')

	bowtie2-build "$file" ../indices/"$sample" &
done
wait

#Next, map processed reads to indices
cd ../reads/

for file in *R1.fastq.gz
do
	R1=$(ls $file)
	R2=${R1//R1.fastq.gz/R2.fastq.gz}
	sample=$(ls $file | sed 's/_.*//')

 	bowtie2 -p 8 -x ../indices/"$sample" -1 "$R1" -2 "$R2" -S ../binning/"$sample".sam &&
	samtools sort -n -m 5G -@ 2 ../binning/"$sample".sam -o ../binning/"$sample".bam &
done
wait
