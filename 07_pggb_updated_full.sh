#!/bin/bash

# Run Full version of updated PGGB without communities to see
# what the difference is.
# This version is made on the reconstructed assemblies

# Define input and output directories
INPUTDATA=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_total_fasta/fTotalCichlids.fa
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/07_pggb_updated_full/recon

# make output dir
#mkdir $OUTPUTDIR

# Index inputfile -> Error indicated necessary
#samtools faidx ${INPUTDATA}

# Run PGGB with the full version
# pggb_full -i ${INPUTDATA} -o ${OUTPUTDIR} -n 4 -t 8 -p 90 -s 10000 -Y '#'
../software/pggb/pggb -i ${INPUTDATA} -o ${OUTPUTDIR} -n 4 -t 8 -p 90 -s 50000 -Y '#'


# New Version PGGB
