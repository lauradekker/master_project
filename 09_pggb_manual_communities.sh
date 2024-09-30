#!/bin/bash

# Run PGGB in manually made community files

for i in `seq 2 22`; do

	# Define input and output directories
	INPUTDATA=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_community_fastas/community${i}.fa ;
	mkdir /lustre/scratch123/tol/projects/cichlid/ldekker/results/09_pggb_manual_communities/chromosome${i}
	OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/09_pggb_manual_communities/chromosome${i} ;

	# Index inputfile -> Error indicated necessary
	samtools faidx ${INPUTDATA} ;

	# Run PGGB with the updated full version
	# pggb_full -i ${INPUTDATA} -o ${OUTPUTDIR} -n 4 -t 8 -p 90 -s 10000 -Y '#'
	../software/pggb/pggb -i ${INPUTDATA} -o ${OUTPUTDIR} -n 4 -t 8 -p 90 -s 5000 -Y '#' ;
		# -i: path to input file
		# -o: path to output directory
		# -n: amount of haplotypes
		# -t: amount of threads
		# -p: minimum nucleotide identity
		# -s: minimum scaffolding length
		# -Y: delimiter in .fa file
done



