#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 100g
#SBATCH --cpus-per-task 4
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes GTDB-tk to assign taxonomy to the consolidated bins from each sample (i.e. DAS_Tool output) 
# or the dereplicated genomes from each PID (i.e. dREP output)

# GTDB-tk functions by characterizing marker genes within an assembly using Prodigal, aligning these markers in a 
# multiple sequence alignment (MSA), then placing the assemblies into a reference tree to obtain their most likely classification 
# Thus, running GTDB-tk  will output a mRNA sequence file (.fna) and a protein sequence file (.faa) 
# These files can be later inputted into inStrain profile to obtain gene-level characterizations
 

# Input: Consolidated bins located in data/processed/binning/das_tool/"$sample"/"$sample"_DASTool_bins or
#	 Dereplicated bins located in data/draft_genomes/"$sample"/dereplicated/dereplicated_genomes

# Output: summary.tsv file containing classifications along with other output files will be deposited under
#	  data/processed/annotation/"$sample" or data/draft_genomes/"$sample"/dereplicated/annotation

# GTDB-tk is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script, 
# uncomment the following line to create the gtdbtk environment in which GTDB-tk 2.4.0 is installed
# conda create -n gtdbtk-2.4.0 -c conda-forge -c bioconda gtdbtk=2.4.0

# Current version is 2.4.0

# Additionally, you will need to download the GTDB-tk reference data. The following lines will download the reference data into
# data/reference. It can also be found in data/reference/obtain_reference.bash.
# cd data/reference
# wget https://data.ace.uq.edu.au/public/gtdb/data/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz
# tar xvzf gtdbtk_data.tar.gz 

module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/gtdbtk-2.4.0

gtdbtkdir=/work/users/p/r/prisca/antibiotics_tolerance/data/reference/GTDBtk
conda env config vars set GTDBTK_DATA_PATH=""$gtdbtkdir"/release220"

sample=$1

echo running GTDB-tk classify workflow for sample "$sample"

# For consolidated bins, use following lines:
#outdir=data/processed/annotation/"$sample"
#assemblydir=data/processed/binning/das_tool/"$sample"/"$sample"_DASTool_bins


# For dereplicated bins, use following lines:
outdir=data/draft_genomes/"$sample"/dereplicated/annotation
assemblydir=data/draft_genomes/"$sample"/dereplicated/dereplicated_genomes

mkdir -p $outdir


gtdbtk classify_wf --genome_dir "$assemblydir"/ --out_dir "$outdir" --extension fa --cpus 4 --mash_db "$gtdbtkdir"/mash
