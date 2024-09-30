#!/bin/bash

# Align short reads to the graph with minigraph, edited to map the two files separately

# Point to directory with data
DATADIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/sequencing_reads
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/26_minigraph_short_reads/reads_1
GRAPH_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/10_minigraph_pangenome/minigraph_pangenome_ONref.gfa

# Make output directory
#mkdir ${OUTPUTDIR}

# Minigraph
../software/minigraph/minigraph -cx sr -t16 $GRAPH_DIR ${DATADIR}/short_reads_A1-108416_R1_001 > ${OUTPUTDIR}/minigraph_shortread_mapping_1.gaf
	# -cx:	sequence-to-graph mapping
	# -t: 	number of threads/cpus
	# sr: 	short read alignment (long reads is default)

# Read file 2
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/26_minigraph_short_reads/reads_2

# Make output directory
#mkdir ${OUTPUTDIR}

# Minigraph
../software/minigraph/minigraph -cx sr -t16 $GRAPH_DIR ${DATADIR}/short_reads_A1-108416_R2_001 > ${OUTPUTDIR}/minigraph_shortread_mapping_2.gaf
        # -cx:  sequence-to-graph mapping
        # -t:   number of threads/cpus
        # sr:   short read alignment (long reads is default)
