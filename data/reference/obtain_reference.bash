#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 1-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script is used to obtain reference data needed for the analysis.
mkdir -p data/reference

# Obtaining the latest human reference genome from the NCBI FTP site:
mkdir -p data/reference/human
wget -P data/reference/human https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz

## buidling bowtie2 index database
bowtie2-build data/reference/human/GCF_000001405.40_GRCh38.p14_genomic.fna.gz data/reference/human/human_database

# Obtaining the GTDB-tk reference data needed for taxonomic classification:
## note: the entire reference dataset is 110G and will take awhile to download.
mkdir -p data/reference/GTDBtk
wget -P data/reference/GTDBtk https://data.ace.uq.edu.au/public/gtdb/data/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz
tar xvzf data/reference/gtdbtk_data.tar.gz -C data/reference/GTDBtk/

# CheckM database required to evaluate genome completeness for dRep
mkdir -p data/reference/CheckM
wget -P data/reference/CheckM https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz
tar xvzf data/reference/CheckM/checkm_data_2015_01_16.tar.gz -C data/reference/CheckM/
 
