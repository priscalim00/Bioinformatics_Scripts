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

module load htstream

import glob
import os

mkdir data/working/deduplicated

for r1 in glob("data/raw/*_R1_*.fastq.gz"):
    r2 = r1.replace("R1", "R2")
    s = r1.split('/')[-1].replace("_L001_R1_001.fastq.gz", '')
    cmd = "hts_SuperDeduper -L data/working/deduplicated/" + s + "_stats.log -1 " + r1 + " -2 " + r2 + " | "







