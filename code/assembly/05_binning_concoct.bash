#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 4g
#SBATCH -n 2
#SBATCH -t 1-
#SBATCH --mail-type=fail
#SBATCH --mail-user=prisca@live.unc.edu

# Scripts 03-05 each use a different program to perform binning. This one utilizes CONCOCT
# Each program is a separate script so that they can be submitted as separate jobs and run independently.
# The bins will then be consolidated in script 06 using DASTools


# Input: Assembly .fasta files located under data/processed/trimmed_assemblies and
#        alignment .bam files located under data/processed/binning
# Output: Bins will be deposited under data/processed/binning/concoct

# CONCOCT is not pre-loaded on Longleaf and needs to be installed via conda
# Ensure that miniconda is downloaded and properly configurated, see link in README.md
# Installation only needs to be done once, so if this is your first time running this script, 
# uncomment the following line to create the CONCOCT environment in which CONCOCT is installed. 
# Current version is 1.1.0

# conda create -n concoct python=3 concoct
eval "$(conda shell.bash hook)"
conda activate concoct

mkdir -p data/processed/binning/concoct
mkdir -p data/processed/binning/concoct/$1

assembly=data/processed/evaluation/$1/$1_metaspades_trimmed.fasta
mapping=data/processed/binning/mapping/$1/$1.bam 
outdir=data/processed/binning/concoct/$1

#cut contigs into smaller parts
cut_up_fasta.py "$assembly" -c 10000 -o 0 --merge_last -b "$outdir"/$1_contigs_10K.bed > "$outdir"/$1_contigs_10K.fa

#generate coverage depth table
concoct_coverage_table.py "$outdir"/$1_contigs_10K.bed "$mapping" > "$outdir"/$1_coverage_table.tsv

#concoct binning
concoct -t 2 --composition_file "$outdir"/$1_contigs_10K.fa --coverage_file "$outdir"/$1_coverage_table.tsv -b "$outdir"/

#merge subcontig clustering into original contig clustering
merge_cutup_clustering.py "$outdir"/clustering_gt1000.csv > "$outdir"/clustering_merged.csv

#extract bins as fasta files
mkdir "$outdir"/bins
extract_fasta_bins.py "$assembly" "$outdir"/clustering_merged.csv --output_path "$outdir"/bins


