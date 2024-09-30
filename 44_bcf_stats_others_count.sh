#!/bin/bash

# Script to extract info from bcf summary tools about count of 'others' from the minigraph-cactus variant calling method

rm others_per_chr.txt

#i=1

for i in `seq 1 22`; do 
	NR_OTHERS_LINE=`grep 'number of others:' ../results/40_bcftools_stats_vcf_minicactus/minicactus_chr${i}_sv_stats.txt`
	echo ${i} ${NR_OTHERS_LINE##*:} >> ../results/40_bcftools_stats_vcf_minicactus/others_per_chr.txt; 
done


