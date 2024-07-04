#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 2g
#SBATCH -n 8
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# Prior to running InStrain, the deplicated genome .fasta files must be prepped.
# This involves multiple steps:
# 1) Pulling all genomes of interest and concatenating them into a single .fasta file
# 2) Generating a scaffold to bin file (dRep)
# 3) Mapping raw reads for each sample to the concatenated genome file (Bowtie2)
# 4) Profiling genes (Prodigal)
# 5) Annotating genes (using database of choice -> TBD)

# This script addresses steps 1 & 2 

# First, check the GTDB-tk output to ID genomes classified as E.coli. Currently, I am doing this manually, but the aim is to 
# automate this process in the future.  

# If only one genome from that PID is classified as E.coli, skip this script and move on to script 03_mapping.bash

# parse_stb.py script comes from dRep, so let's load our conda environment
module load anaconda/2021.11

conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/drep

# Concatenate genomes to one .fasta file. You'll need to manually update the filepaths for each PID
cat data/draft_genomes/BMT110/dereplicated/dereplicated_genomes/BMT110D-9_concoct.9.fa \
data/draft_genomes/BMT110/dereplicated/dereplicated_genomes/BMT110D4_concoct.19.fa > data/draft_genomes/BMT110/dereplicated/dereplicated_genomes/all_ecoli.fa

# Generate scaffolds to bin file
parse_stb.py --reverse -f data/draft_genomes/BMT110/dereplicated/dereplicated_genomes/BMT110D-9_concoct.9.fa \
data/draft_genomes/BMT110/dereplicated/dereplicated_genomes/BMT110D4_concoct.19.fa -o data/draft_genomes/BMT110/dereplicated/all_ecoli.stb
