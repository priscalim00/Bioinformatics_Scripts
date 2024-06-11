#!/bin/bash

# Deduplication of reads is performed to remove reads that are exact matches. These duplicated reads are likely due to PCR artifacts 
# hence are removed to reduce the required  downstream computing power and avoid artificially inflated coverage in those regions

# Deduplication is done using htstream which can be installed using Bioconda: `conda create --name htstream htstream`. 
# Ensure this installation is complete before running this step

conda activate htstream

from glob import glob
import os
      
for r1 in glob("data/raw/*_R1_*.fastq.gz"):
    r2 = r1.replace("R1", "R2")
    s = r1.split('/')[-1].replace("_L001_R1_001.fastq.gz", '')
    cmd = "hts_SuperDeduper -L data/working/deduplicated/" + s + "_stats.log -1 " + r1 + " -2 " + r2 + " | "



