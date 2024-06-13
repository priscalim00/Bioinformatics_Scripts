The raw datafiles used in this analysis are stored in the Andermann Lab's Longleaf cluster. 
They can be obtained using the following code:

```bash
cp /proj/andermannlab/working_files/BMT_Novaseq/*.fastq.gz .

```
Once files are processed, they are moved into a folder indicating the Month-Year that the analysis was performed.
As such, *.fastq.gz files in data/raw are unprocessed and can be called by downstream scripts
