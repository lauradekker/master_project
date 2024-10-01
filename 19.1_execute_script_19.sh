#!/bin/bash

# Script to run the jobs for script 19 on all chromosomes in parallel


for i in 9 21; do

	bsub -G rdgroup -q long -o ../output/myMinigraph_o_%J -e ../errors/myMinigraph_e_%J -R'select[mem>40000] rusage[mem=40000] span[ptile=8]' -n 8 -M 40000 19_minigraph_communities.sh ${i} ;

done

# took out -q long
