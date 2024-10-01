#!/bin/bash

# Script to run the jobs for script 40 on all communities in parallel

for i in `seq 2 22`; do

	bsub -G rdgroup -o ../output/bcftoolsSvStats_o_%J -e ../errors/bcftoolsSvStats_e_%J -R'select[mem>5000] rusage[mem=5000] span[ptile=2]' -n 2 -M 5000 40_bcftools_stats_vcf_minicactus.sh ${i} ;

done


