#!/bin/bash

# Script for doing assembly evaluation with QUAST on assemblies without scaffolds

# Paths to important directories
QUAST_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/software/quast
OG_ASSEMBLY_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_fastas
OUTPUT_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/46_quast_assembly_eval_noscaffold

# Make output directory
mkdir ${OUTPUT_DIR}

# Run quast on the assemblies with additional contigs present
python3 ${QUAST_DIR}/quast.py -l AstCal,NeoMul,OreNil,PunNye ${OG_ASSEMBLY_DIR}/fAstCal.fa ${OG_ASSEMBLY_DIR}/fNeoMul.fa ${OG_ASSEMBLY_DIR}/fOreNil.fa ${OG_ASSEMBLY_DIR}/fPunNye.fa -o ${OUTPUT_DIR}
	# -l = labels for output reports per assembly
	# -o = output directory


