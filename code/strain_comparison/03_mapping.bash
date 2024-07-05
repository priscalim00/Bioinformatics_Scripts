#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 16g
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

# This script addresses step 3  

# Input: Draft E. coli genome used to create mapping index and processed reads under data/processed/reads/
# Output: Alignment (.sam) file for each sample under the same PID

module purge #removes any loaded modules
module load bowtie2/2.4.5

# Edit PID accordingly
pid=BMT127
reads=data/processed/reads
genomes=data/draft_genomes/"$pid"/dereplicated/dereplicated_genomes
# Edit ecoli to match filename corresponding to ecoli genome(s)
ecoli=BMT127D1_concoct.41.fa

mkdir -p data/draft_genomes/"$pid"/dereplicated/mapping
outdir=data/draft_genomes/"$pid"/dereplicated/mapping

bowtie2-build "$genomes"/"$ecoli" "$outdir"/ecoli_index

for file in "$reads"/"$pid"*_R1*; 
do 

  sample=$(basename $file | sed 's/_.*//')
  R1=$(ls $file)
  R2=${R1//R1.fastq.gz/R2.fastq.gz}
  
  bowtie2 -p 8 -x "$outdir"/ecoli_index -1 "$R1" -2 "$R2" -S "$outdir"/"$sample"_aligned.sam
  
done

