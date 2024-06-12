#!/bin/bash

#This serves as the main analysis driver script for the project

#Pull raw sequencing files from /proj/andermannlab
bash data/raw/obtain_raw.bash

#Run fastqc and multiqc on raw sequencing files
sbatch code/preprocessing/00_fastqc.bash

#Run hts_SuperDeduper on raw sequencing files
sbatch code/prepocessing/01_deduplication.bash
