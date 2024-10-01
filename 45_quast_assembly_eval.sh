#!/bin/bash

# Script for doing assembly evaluation with QUAST

# Paths to important directories
QUAST_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/software/quast
OG_ASSEMBLY_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/og_data
OUTPUT_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/45_quast_assembly_eval

# Make output directory
mkdir ${OUTPUT_DIR}

# Run quast on the assemblies with additional contigs present
python3 ${QUAST_DIR}/quast.py -l AstCal,NeoMul,OreNil,PunNye ${OG_ASSEMBLY_DIR}/fAstCal14_final.fa ${OG_ASSEMBLY_DIR}/fNeoMul12_final.fa ${OG_ASSEMBLY_DIR}/fOreNil_final.fa ${OG_ASSEMBLY_DIR}/fPunNye_final.fa -o ${OUTPUT_DIR}
	# -l = labels for output reports per assembly
	# -o = output directory


