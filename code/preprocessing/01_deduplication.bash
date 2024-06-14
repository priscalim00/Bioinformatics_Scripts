#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 1-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# Deduplication of reads is performed to remove reads that are exact matches. These duplicated reads are likely due to PCR artifacts 
# hence are removed to reduce the required  downstream computing power and avoid artificially inflated coverage in those regions

# Input: Raw paired end fastq.gz files located in data/raw
# Output: Deduplicated paired end fastq.gz and a _stats.log file for each sample containing information on no. of reads removed.
# Output files are deposited in data/working/deduped/

module load htstream

mkdir -p data/working/deduped

cd data/raw/

for file in *R1_001.fastq.gz
do
        sample=$(ls $file | sed 's/_.*//')
        R1=$(ls $file)
        R2=${R1//R1_001.fastq.gz/R2_001.fastq.gz}
#       echo $sample $R1 $R2

        hts_SuperDeduper -1 "$R1" -2 "$R2" -f ../working/deduped/"$sample"_deduped -L ../working/deduped/"$sample"_stats.log &

done
wait