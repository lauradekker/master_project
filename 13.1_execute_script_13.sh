#!/bin/bash

# Script to run the jobs for script 13 on all chromosomes in parallel, 

#mkdir /lustre/scratch123/tol/projects/cichlid/ldekker/results/13_pggb_manual_communities_50k_segments

for i in `seq 2 22`; do

	bsub -G rdgroup -q long -o ../output/myPangenome_o_%J -e ../errors/myPangenome_e_%J -R'select[mem>60000] rusage[mem=60000] span[ptile=16]' -n 16 -M 60000 13_pggb_manual_communities_50k_segments.sh ${i} ;

done
