#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 1-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script is used to obtain reference data needed for the analysis.
cd data/reference/

# Obtaining the latest human reference genome from the NCBI FTP site:
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz

## buidling bowtie2 index database
bowtie2-build data/reference/GCF_000001405.40_GRCh38.p14_genomic.fna.gz data/reference/human_database

# Obtaining the GTDB-tk reference data needed for taxonomic classification:
## note: the entire reference dataset is 110G and will take awhile to download.
wget https://data.ace.uq.edu.au/public/gtdb/data/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz
tar xvzf gtdbtk_data.tar.gz

