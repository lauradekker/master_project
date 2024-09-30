#!/bin/bash

# Script to run the jobs for script 13 on all chromosomes in parallel, 

#mkdir /lustre/scratch123/tol/projects/cichlid/ldekker/results/14_pggb_manual_communities_100k_segments

for i in `seq 1 22`; do

	bsub -G rdgroup -o ../output/myPangenome_o_%J -e ../errors/myPangenome_e_%J -R'select[mem>60000] rusage[mem=60000] span[ptile=16]' -n 16 -M 60000 14_pggb_manual_communities_100k_segments.sh ${i} ;

done

# took out -q long
