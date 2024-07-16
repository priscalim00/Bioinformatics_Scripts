#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem=1g
#SBATCH -t 2:00:00
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

module load multiqc

multiqc data/working/fastqc_final -o data/working/fastqc_final
