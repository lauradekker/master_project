#!/bin/bash

# Script to run the jobs for script 37 on all communities in parallel

#rm check_paths_vgdecon.txt

for i in `seq 1 22`; do

	bsub -G rdgroup -o ../output/bcftoolsSv_o_%J -e ../errors/bcftoolsSv_e_%J -R'select[mem>10000] rusage[mem=10000] span[ptile=4]' -n 4 -M 10000 37_bcftools_sv_filter_minicactus.sh ${i} ;

done


