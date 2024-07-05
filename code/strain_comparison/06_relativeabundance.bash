#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 2g
#SBATCH -n 1
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script calculates relative abundance of a representative genome within a sample using the following equation:
# filtered_read_pair_count / (total reads) * 100%

# filtered_read_pair_count is obtained from the inStrain profile genome wide output
 
