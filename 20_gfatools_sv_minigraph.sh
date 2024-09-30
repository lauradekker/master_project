#!/bin/bash

# gfatools on chr1 graph to call structural variants

i=$1 # loop determines which community we handle right now

# Point to directory with data
INPUT_DATA=/lustre/scratch123/tol/projects/cichlid/ldekker/results/19_minigraph_communities/recon/minigraph_community${i}.gfa
RESULTSDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/20_gfatools_sv
OUTPUTDIR=${RESULTSDIR}/chromosome${i}

# Make new directories
#mkdir ${RESULTSDIR}
mkdir ${OUTPUTDIR}

# gfatools bubble
../software/gfatools/gfatools bubble ${INPUT_DATA} > ${OUTPUTDIR}/chr1_sv.bed
