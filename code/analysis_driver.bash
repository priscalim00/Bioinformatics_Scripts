#!/bin/bash

#This serves as the main analysis driver script for the project, needs to be edited HEAVILY pls don't use rn

#Pull raw sequencing files from /proj/andermannlab
bash data/raw/obtain_raw.bash

#Obtain human reference genome
sbatch data/reference/obtain_reference.bash

#Generate sample list
mkdir -p data/summary
cd data/raw/
ls *R1_001.fastq.gz | sed 's/_.*//' > ../summary/all_samples.txt
cd ../../

#Separating new samples from processed samples
mv data/summary/all_samples.txt > data/summary/processed_samples.txt
grep -v -x -f data/summary/processed_samples.txt data/summary/all_samples.txt > data/summary/new_samples.txt


#Preprocessing:
##Run preprocessing driver
for sample in $(cat data/summary/new_samples.txt); do bash code/preprocessing/preprocessing_driver.bash "$sample"; done

##Generate multiQC reports
sbatch code/preprocessing/001_multiqc.bash
sbatch code/preprocessing/041_multiqc.bash

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

