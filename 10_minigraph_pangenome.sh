#!/bin/bash

# Adjusted the script to run with OreNil as the reference assembly

# Point to directory with data
DATADIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_fastas
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/10_minigraph_pangenome

# Make output directory
#mkdir ${OUTPUTDIR}

# Minigraph
../software/minigraph/minigraph -cxggs -t16 ${DATADIR}/fOreNil.fa ${DATADIR}/fAstCal.fa ${DATADIR}/fNeoMul.fa ${DATADIR}/fPunNye.fa > ${OUTPUTDIR}/minigraph_pangenome_ONref.gfa
	# -cxggs : make graphs from multiple input fastas
	# -t : number of threads/cpus
