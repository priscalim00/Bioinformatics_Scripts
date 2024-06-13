#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 1-
#SBATCH --mail-type=all
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

conda activate concoct

mkdir -p data/processed/binning/concoct

cd data/processed/trimmed_assemblies
for file in *_scaffolds_trimmed.fasta
do
	sample=$(ls $file | sed 's/_.*//')

	mkdir ../binning/concoct/"$sample"
	cd ../binning/concoct/"$sample"

	#cut contigs into smaller parts
	cut_up_fasta.py ../../../trimmed_assemblies/"$file" -c 10000 -o 0 --merge_last -b "$sample"_contigs_10K.bed > "$sample"_contigs_10K.fa

	#generate coverage depth table
	concoct_coverage_table.py "$sample"_contigs_10K.bed ../../"$sample".bam > "$sample"_coverage_table.tsv

	#concoct binning
	concoct --composition_file "$sample"_contigs_10K.fa --coverage_file "$sample"_coverage_table.tsv -b concoct_output/

	#merge subcontig clustering into original contig clustering
	merge_cutup_clustering.py concoct_output/clustering_gt1000.csv > concoct_output/clustering_merged.csv

	#extract bins as fasta files
	mkdir concoct_output/"$sample"_bins
	extract_fasta_bins.py ../../../trimmed_assemblies/"$file concoct_output/clustering_merged.csv --output_path concoct_output/"$sample"_bins
done

