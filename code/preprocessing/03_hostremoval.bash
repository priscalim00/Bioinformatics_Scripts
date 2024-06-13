#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH --mem 64g
#SBATCH -n 16
#SBATCH -t 1-
#SBATCH --mail-type=all
#SBATCH --mail-user=prisca@live.unc.edu

# This script utilizes bowtie2 and samtools to map reads to a host reference genome, retaining only unmapped reads

# Input: Trimmed paired end reads that are found in data/working/trimmed
# Output: Alignment files and paired end reads with host removed deposited in data/working/host_removed


module load bowtie2/2.4.5
module load samtools/1.20 

mkdir -p data/working/host_removed

cd data/working/trimmed/

for file in *trimmed_R1.fastq.gz
do 
	R1=$(ls $file)
	R2=${R1//R1.fastq.gz/R2.fastq.gz}
	sample=$(ls $file | sed 's/_.*//')

	#aligning reads to human database, -p defines number of cores to use
	bowtie2 -p 8 -x ../../reference/human_database -1 "$R1" -2 "$R2" -S ../host_removed/"$sample"_all.sam 
	#converting .sam file to .bam format
	samtools view -bS ../host_removed/"$sample"_all.sam > ../host_removed/"$sample"_all.bam 
	#filtering for only unmapped reads
	samtools view -b -f 12 -F 256 ../host_removed/"$sample"_all.bam > ../host_removed/"$sample"_unmapped.bam
	#sorting .bam file so that paired reads are matched, -@ specifies number of threads
	samtools sort -n -m 5G -@ 2 ../host_removed/"$sample"_unmapped.bam -o ../host_removed/"$sample"_unmapped_sorted.bam 
	#writing reads to respective .fastq.gz files and discarding supplementary and secondary reads.
	samtools fastq -@ 8 ../host_removed/"$sample"_unmapped_sorted.bam \
	-1 ../host_removed/"$sample"_host_removed_R1.fastq.gz -2 ../host_removed/"$sample"_host_removed_R2.fastq.gz \
	-0 /dev/null -s /dev/null -n 
done

