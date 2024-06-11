# Antibiotics Tolerance project
## Led by Dr Tessa Andermann (UNC Chapel Hill), analysis conducted by Prisca Lim

This project aims to characterize antibiotics tolerance development in patients undergoing bone marrow transplant (BMT). 
For each patient, stool samples were collected in a longitudinal manner spanning pre-transplant to 180 days post-transplant
Samples underwent shotgun sequencing on the Illumina Novaseq platform (150bp, paired end) using half reactions of the standard
Illumina DNA Prep kit. 

Navigate this repository:
```
project
|- README           # the top level description of content (this doc)
|
|- data             # raw and primary data, are not changed once created
| |- references/    # reference files such as reference genomes or taxonomic databases
| |- raw/           # raw data files or instructions on how to obtain them
| |- processed/     # cleaned data, used to generate figures
| |- working/       # copies of raw data files being worked on or intermediate files required for downstream analysis            
|
|- code/            # scripts with detailed comments for analyses and figure generation
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
