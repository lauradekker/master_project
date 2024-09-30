#!/bin/bash

# Script to run the jobs for script 20 on all communities in parallel


for i in `seq 2 22`; do

	bsub -G rdgroup -o ../output/gfatoolsSVMinigraph_o_%J -e ../errors/gfatoolsSVMinigraph_e_%J -R'select[mem>1000] rusage[mem=1000] span[ptile=4]' -n 4 -M 1000 20_gfatools_sv_minigraph.sh ${i} ;

done


