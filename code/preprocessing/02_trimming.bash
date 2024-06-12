# This script utilizes trim_galore, a wrapper around Cutadapt and FastQC, to remove any adapters and low quality reads. 
# trim_galore is able to auto-detect adapters, making it useful if samples were sequenced a long time ago, and we are 
# unsure of the actual adapter sequence. 

# Input: Deduplicated paired end reads found in data/working/deduped
# Output Trimmed paired end reads that will be depositied in data/working/trimmed


