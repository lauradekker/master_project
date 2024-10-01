#!/bin/bash

# Script to run the jobs for script 12 on all chromosomes in parallel

for i in `seq 1 22`; do

	bsub -G rdgroup -q long -o ../output/myPangenome_o_%J -e ../errors/myPangenome_e_%J -R'select[mem>60000] rusage[mem=60000] span[ptile=16]' -n 16 -M 60000 12_pggb_manual_communities_bigger_segments.sh ${i} ;

done
