#!/bin/bash

# Script to extract info from bcf summary tools about indels from the minigraph-cactus variant calling method

rm sv_per_chr.txt

#i=1

for i in `seq 1 22`; do 
	NR_SVS_LINE=`grep 'number of records:' ../results/40_bcftools_stats_vcf_minicactus/minicactus_chr${i}_sv_stats.txt`
	echo ${i} ${NR_SVS_LINE##*:} >> sv_per_chr.txt; 
done


