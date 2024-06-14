# Antibiotics Tolerance project
## Led by Dr Tessa Andermann (UNC Chapel Hill), analysis conducted by Prisca Lim

This project aims to characterize antibiotics tolerance development in patients undergoing bone marrow transplant (BMT). 
For each patient, stool samples were collected in a longitudinal manner spanning pre-transplant to 180 days post-transplant
Samples underwent shotgun sequencing on the Illumina Novaseq platform (150bp, paired end) using half reactions of the standard
Illumina DNA Prep kit. 

Use of `conda`: `Conda` is a powerful environment and software manager. Many of the packages used in this pipeline are downloaded via `conda`. Refer to the [Miniconda webpage](https://docs.anaconda.com/free/miniconda/) for details on installing and configuring `conda`

Navigate this repository:
```
project
|- README           # the top level description of content (this doc)
|
|- data            
| |- references/    # reference files such as reference genomes or taxonomic databases
| |- raw/           # raw data files or instructions on how to obtain them
| |- working/       # preprocessing of raw sequencing files
| |- processed/     # processed sequencing files used for MAG assembly & binning         
|
|- code/            
| |- preprocessing/ # scripts used to preprocess reads prior to MAG assembly
| |- assembly/      # scripts used for assembly, binning and dereplication
| |- annotation/    # scripts used for taxonomic and gene annotation
| |- snpcalling/    # scripts used for calling and tracking SNPs between samples
|
|- results          # all output from workflows and analyses
| |- tables/        # text version of tables to be rendered with kable in R
| |- figures/       # graphs, likely designated for manuscript figures
|
|- submission/
| |- manuscript.Rmd # executable Rmarkdown for this study, containing code that generates relevant figures
| |- study.md       # Markdown (GitHub) version of the *.Rmd file
| |- study.pdf      # PDF version of *.Rmd file
| |- citations.bib  # BibTeX formatted references
|
|- exploratory/     # exploratory data analysis for study
| |- notebook/      # preliminary analyses
|
+- Makefile         # executable Makefile for this study, if applicable
```  
