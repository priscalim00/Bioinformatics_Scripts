#!/bin/bash

#This serves as the main analysis driver script for the project, needs to be edited HEAVILY pls don't use rn

#Pull raw sequencing files from /proj/andermannlab
bash data/raw/obtain_raw.bash

#Obtain human reference genome
sbatch data/reference/obtain_reference.bash

#Generate sample list
mkdir -p data/summary
cd data/raw/
ls *R1_001.fastq.gz | sed 's/_.*//' > data/summary/all_samples.txt

#Preprocessing:
##Step 00: Run fastqc and multiqc on raw sequencing files
sbatch code/preprocessing/00_fastqc.bash

##Step 01: Run hts_SuperDeduper on raw sequencing files
sbatch code/preprocessing/01_deduplication.bash

##Step 02: Trimming low quality reads and adapter sequences from deduplicated files
sbatch code/preprocessing/02_trimming.bash

##Step 03: Removing host reads from trimmed files
sbatch code/preprocessing/03_hostremoval.bash

##Step 04: Generate fastqc and multiqc reports for processed reads
sbatch code/preprocessing/04_finalqc.bash

#Annotating processed reads with Kraken2 & Bracken
##Step 01: Run Kraken2, Bracken & KrakenTools
for sample in $(cat all_samples.txt); do sbatch code/annotation/00_krakenbracken.bash

##Step 02: Combine Bracken outputs into one file
sbatch code/annotation/001_combinebracken.bash

#Assembly:
##Step 00: Running metaspades
for sample in $(cat all_samples.txt); do sbatch code/assembly/00_assembly.bash $sample; done

##Step 01: Evaluating assembly stats
sbatch code/assembly/01_evaluation.bash

##Step 02: Creating indices and mapping reads
for sample in $(cat all_samples.txt); do sbatch code/assembly/02_mapping.bash $sample; done

