#!/bin/bash

# Script to run the jobs for script 24 on all chromosomes in parallel

#for i in `seq 2 22`; do

for i in 7 10 15; do

	#rm -rf /lustre/scratch123/tol/projects/cichlid/ldekker/results/24_minigraph_cactus_communities/recon_pangenomes/chromosome${i}/*

	bsub -G rdgroup -o ../output/miniCactus_o_%J -e ../errors/miniCactus_e_%J -R'select[mem>60000] rusage[mem=60000] span[ptile=16]' -n 16 -M 60000 24_minigraph_cactus_communities.sh ${i} ;

done

# took out -q long
