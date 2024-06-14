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

for file in *_deduped_R1.fastq.gz
do
	R1=$(ls $file)
	R2=${R1//R1.fastq.gz/R2.fastq.gz}

	trim_galore -j 4 --paired "$R1" "$R2" -o ../trimmed &
done
wait

#renaming files to make them more informative

for file in data/working/trimmed/*R1_val_1.fq.gz
do
        file=$(ls $file)
        new_file=${file//deduped_R1_val_1.fq.gz./trimmed_R1.fastq.gz}
        mv -n "$file" "$new_file"
done


for file in data/working/trimmed/*R2_val_2.fq.gz
do
        file=$(ls $file)
        new_file=${file//deduped_R1_val_2.fq.gz./trimmed_R2.fastq.gz}
        mv -n "$file" "$new_file"
done

