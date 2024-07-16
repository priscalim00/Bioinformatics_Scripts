#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 1-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes trim_galore, a wrapper around Cutadapt and FastQC, to remove any adapters and low quality reads. 
# trim_galore is able to auto-detect adapters, making it useful if samples were sequenced a long time ago, and we are 
# unsure of the actual adapter sequence. The default min PHRED score is 20, all bases below this threshold are discarded 

# Input: Deduplicated paired end reads found in data/working/deduped
# Output Trimmed paired end reads that will be depositied in data/working/trimmed

module load trim_galore
module load cutadapt
module load fastqc
module load pigz

mkdir -p data/working/trimmed

cd data/working/deduped/

sample=$1
R1="$sample"_deduped_R1.fastq.gz
R2="$sample"_deduped_R2.fastq.gz

echo Now trimming sample "$sample"

trim_galore -j 4 --paired "$R1" "$R2" -o ../trimmed


#renaming files to make them more informative
cd data/working/trimmed
mv -n "$sample"_deduped_R1_val_1.fq.gz "$sample"_trimmed_R1.fastq.gz
mv -n "$sample"_deduped_R2_val_2.fq.gz "$sample"_trimmed_R2.fastq.gz
