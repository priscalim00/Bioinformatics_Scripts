#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script functions to copy all bins from the same PID into the same directory and run CheckM on them to generate
# completeness and contamination scores needed for dRep. 

# Note: dRep is technically able to run CheckM but I've been having issues with that, so I decided to just run CheckM separately.
# The code in this script is the same as that in code/assembly/08_checkm.bash, but has been modified to include all bins under
# the same PID instead of just bins from one sample. 

# Installation of CheckM can be done via conda. The CheckM reference database must also be downloaded and unzipped in 
# your directory of choice - instructions for this are included in data/reference/obtain_reference.bash

# To install CheckM for the first time, uncomment the following lines:
## conda create -n checkm python=3.9
## conda activate checkm
## conda install -c bioconda numpy matplotlib pysam
## conda install -c bioconda hmmer prodigal pplacer
## pip3 install checkm-genome

module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/checkm
export CHECKM_DATA_PATH=/work/users/p/r/prisca/antibiotics_tolerance/data/reference/CheckM/

mkdir -p data/draft_genomes

pid=$1 #sample name contains PID and timepoint, e.g. BMT101D1: PID = BMT101 & timepoint = D1

echo Running CheckM script for PID:"$pid"

mkdir -p data/draft_genomes/"$pid"
mkdir -p data/draft_genomes/"$pid"/all_bins
mkdir -p data/draft_genomes/"$pid"/checkm

dastooldir=data/processed/binning/das_tool
bindir=data/draft_genomes/"$pid"/all_bins
outdir=data/draft_genomes/"$pid"/checkm

# First, we need to move all the bins from this PID into one directory. We will also rename the files to 
# include sample names to prevent files overwriting each other
for file in "$dastooldir"/"$pid"*
do
  
  sample=$(basename $file)
  
  for bin in "$dastooldir"/"$sample"/"$sample"_DASTool_bins/*.fa  
  do
  
    cp -u  "$bin" "${bindir}/${sample}_$(basename $bin)"
    
  done
  
done
wait
 
# Now, we can run checkm
checkm lineage_wf -t 16 -x fa "$bindir" "$outdir"
checkm qa "$outdir"/lineage.ms "$outdir"/ >  "$outdir"/"$pid"_checkm_results.csv

# I don't yet know how to format the checkm results for dRep using command line, so I just downloaded the output .txt file
# and manually edited it using Excel to include genome filename, completeness and contamination. 


