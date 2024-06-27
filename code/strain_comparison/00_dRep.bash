#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 128g
#SBATCH -n 8
#SBATCH -t 6:00:00
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes dRep to dereplicate genomes obtained from the same PID

# Input: All the consolidated bins from DAS_Tool for the PID of interest

# Output: Dereplicated genomes for the PID of interest will be deposited in data/draft_genomes/"$pid"

# dRep is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script,
# uncomment the following line to create the drep environment in which dRep is installed.
# Current version is 2.0.0

module load anaconda/2021.11
# conda create -n drep drep

conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/drep

# CheckM is installed as part of the dRep package. However, you still need to manually install the CheckM reference database
# Details on how to do so can be found in data/reference/obtain_reference.bash
checkmdir=/data/reference/CheckM
checkm data setRoot $checkmdir 

mkdir -p data/draft_genomes

pid=$1 #sample name contains PID and timepoint, e.g. BMT101D1: PID = BMT101 & timepoint = D1

echo Running dRep script for PID:"$pid"

mkdir -p data/draft_genomes/"$pid"
mkdir -p data/draft_genomes/"$pid"/all_bins
mkdir -p data/draft_genomes/"$pid"/dereplicated

dastooldir=data/processed/binning/das_tool
bindir=data/draft_genomes/"$pid"/all_bins
outdir=data/draft_genomes/"$pid"/dereplicated


# First, we need to move all the bins from this PID into one directory. We will also rename the files to 
# include sample names to prevent files overwriting each other
for file in "$dastooldir"/"$pid"*
do
  
  sample=$(basename $file)
  
  for bin in "$dastooldir"/"$sample"/"$sample"_DASTool_bins/*.fa  
  do
  
    cp "$bin" "${bindir}/${sample}_$(basename $bin)"
    
  done
  
done
wait
 
# Now, we can easily run dRep
dRep dereplicate "$outdir" -g "$bindir"/*.fa --debug --length 10000 




