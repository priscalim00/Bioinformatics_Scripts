# Bioinformatic scripts (last updated 10/03/2024)

These scripts are used to process raw DNA sequencing data to generate assemblies, annotate genes and call SNPs between samples. We work with both Illumina (short-read) and Nanopore (long-read) sequencing, but 
currently all the scripts have only been tested on Illumina data. Long-read & hybrid assembly scripts are planned for the near future

Use of `conda`: `Conda` is a powerful environment and software manager. Many of the packages used in this pipeline are downloaded via `conda`. Refer to the [Miniconda webpage](https://docs.anaconda.com/free/miniconda/) for details on installing and configuring `conda`.

Details on running scripts and various pipelines will included soon!

Navigate this repository:
```
overview
|- README              # the top level description of content (this doc)
|
|- illumina_shotgun    # most common type of sequencing performed for both metagenomic (stool) samples and isolates
| |- preprocessing/    # scripts used to QC raw reads
| |- composition/      # scripts used to classify short-read metagenomic samples
| |- assembly/         # scripts used for assembly and binning 
| | |- athena_10x/     # scripts used for assembly of 10x/linked reads
| |- evaluation/       # scripts used to evalute genome completeness/contamination and other stats (N50/L50)
| |- annotation/       # scripts used to annotate genomes with taxonomic and gene info
| |- variants/         # scripts used to compare assemblies and call variants
| | |- mummer/         # scripts for whole genome alignment and annotating outputs
| | |- instrain/       # scripts for preparing instrain input files and running instrain
| | |- phylo/          # scripts for generating phylogenetic trees from whole genes or specific genes
|
|- nanopore            # work in progress, currently only being performed on isolates but may expand to include metagenomic samples in the future
|
|- illumina_16         # 16S amplicon sequencing, very rarely done & usually from collaborators. work in progress but similar workflow can be found: https://github.com/priscalim00/18S-Metabarcoding-Bioinformatics-Pipeline
|
|- auxillary
| |- download_sra/     # scripts for downloading sequence data from NCBI SRA using sra-toolkit
| |- download_genome/  # scripts for downloading genomes from NCBI (Genbank/RefSeq) using datasets
```  
