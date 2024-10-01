#!/bin/bash

# Run PGGB in manually made community files
# Also increase segment/block size to see if repeats dont get matched in the graph. This script is for 100k segments

i=$1 # get the number of the chromosome from the command line



# Define input and output directories
INPUTDATA=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_community_fastas/community${i}.fa
mkdir /lustre/scratch123/tol/projects/cichlid/ldekker/results/14_pggb_manual_communities_100k_segments/chromosome${i}
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/14_pggb_manual_communities_100k_segments/chromosome${i} 

# Index inputfile -> Error indicated necessary
#~/programs/samtools-1.14/samtools faidx ${INPUTDATA} 
samtools faidx ${INPUTDATA}

# Run PGGB with the updated full version
# pggb_full -i ${INPUTDATA} -o ${OUTPUTDIR} -n 4 -t 8 -p 90 -s 10000 -Y '#'
../software/pggb/pggb -i ${INPUTDATA} -o ${OUTPUTDIR} -n 4 -t 16 -p 90 -s 100k -Y '#' 
	# -i: path to input file
	# -o: path to output directory
	# -n: amount of haplotypes
	# -t: amount of threads
	# -p: minimum nucleotide identity
	# -s: minimum scaffolding length
	# -Y: delimiter in .fa file




