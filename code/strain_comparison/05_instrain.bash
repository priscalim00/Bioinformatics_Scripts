#!/bin/bash


pid=$1

for file in data/draft_genomes/"$pid"/dereplicated/mapping/*.sam
do
	inStrain profile

done

inStrain compare 
