#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 150g
#SBATCH -n 32
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# This script uses Kraken2 and Bracken to annotate processed reads with taxonomic classifications and 
# estimated relative abundances based on the NCBI Refseq database

# Kraken2 and Bracken are available as a pre-loaded module on Longleaf (module load kraken/2.1.2), 
# however the post-processing scripts from KrakenTools are not. As such, I've chosen to create a conda environment 
# and install Kraken2, Bracken & KrakenTools all under the same environment.

# If you wish to do the same, use the following commands:
# conda create -n kraken2bracken kraken2 bracken krakentools

# For now, we are using the Kraken2 database already created in /proj/andermannlab/projects/KRAKEN2-TESSA/KRAKEN2-TESSA-DB/
# But this database may be updated in the future!

module load anaconda/2021.11
conda_envs=/users/p/r/prisca/miniconda3/envs
conda activate "$conda_envs"/kraken2bracken

sample=$1

kraken_dir=data/processed/kraken_bracken/kraken2
bracken_dir=data/processed/kraken_bracken/bracken
reads_dir=data/processed/reads
mkdir -p "$kraken_dir"
mkdir -p "$bracken_dir"

# Classifying with Kraken2
kraken2 \
	--paired \
	--gzip-compressed \
	--threads 32 \
	--db /proj/andermannlab/projects/KRAKEN2-TESSA/KRAKEN2-TESSA-DB/ \
	--output "$kraken_dir"/"$sample"_output \
	--report "$kraken_dir"/"$sample"_report \
	"$reads_dir"/"$sample"_processed_R1.fastq.gz \
	"$reads_dir"/"$sample"_processed_R2.fastq.gz

# Estimating abundances to different taxonomic levels using Bracken
python3 "$conda_envs"/kraken2bracken/bin/src/est_abundance.py \
	-i "$kraken_dir"/"$sample"_report \
	-k /proj/andermannlab/projects/KRAKEN2-TESSA/KRAKEN2-TESSA-DB/database150mers.kmer_distrib \
	--level S \
	-o "$bracken_dir"/"$sample"_bracken_species 

python3 "$conda_envs"/kraken2bracken/bin/src/est_abundance.py \
	-i "$kraken_dir"/"$sample"_report \
	-k /proj/andermannlab/projects/KRAKEN2-TESSA/KRAKEN2-TESSA-DB/database150mers.kmer_distrib \
	--level G \
	-o "$bracken_dir"/"$sample"_bracken_genus

python3 "$conda_envs"/kraken2bracken/bin/src/est_abundance.py \
	-i "$kraken_dir"/"$sample"_report \
	-k /proj/andermannlab/projects/KRAKEN2-TESSA/KRAKEN2-TESSA-DB/database150mers.kmer_distrib \
	--level O \
	-o "$bracken_dir"/"$sample"_bracken_order

# Calculating Shannon Diversity Index using KrakenTools
echo "$sample" >> data/processed/kraken_bracken/alpha_div.txt 
python "$conda_envs"/kraken2bracken/bin/alpha_diversity.py \
	-f "$bracken_dir"/"$sample"_bracken_species >> data/processed/kraken_bracken/alpha_div.txt


