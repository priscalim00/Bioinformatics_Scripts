#!/bin/bash

#This serves as the main analysis driver script for the project

#Pull raw sequencing files from /proj/andermannlab
bash data/raw/obtain_raw.bash

#Obtain human reference genome
sbatch data/reference/obtain_reference.bash

#Preprocessing step 00: Run fastqc and multiqc on raw sequencing files
sbatch code/preprocessing/00_fastqc.bash

#Preprocessing step 01: Run hts_SuperDeduper on raw sequencing files
sbatch code/preprocessing/01_deduplication.bash

#Preprocessing step 02: Trimming low quality reads and adapter sequences from deduplicated files
sbatch code/preprocessing/02_trimming.bash
