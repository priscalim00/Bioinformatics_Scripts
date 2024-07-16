#!/bin/bash

sample=$1

#Run fastQC on all samples
sbatch code/preprocessing/00_fastqc.bash $sample

#Run QC/trimming steps with dependencies built in
jid1=$(sbatch --parsable code/preprocessing/01_deduplication.bash $sample)
echo $jid1

jid2=$(sbatch --parsable --dependency=afterok:$jid1 code/preprocessing/02_trimming.bash $sample)
echo $jid2

jid3=$(sbatch --parsable --dependency=afterok:$jid2 code/preprocessing/03_hostremoval.bash $sample)
echo $jid3

sbatch --dependency=afterok:$jid3 code/preprocessing/04_finalqc.bash $sample
