#!/bin/bash

# Align short reads to to miniCactus graph using vg-giraffe

# Point to directory with data
DATADIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/sequencing_reads
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/29_vg_align_short_reads
GRAPHDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/22_minigraph_cactus_pangenome/recon_pangenome

# Make output directory
#mkdir ${OUTPUTDIR}

# Copy graph
#cp ${GRAPHDIR}/minigraph_cactus_pangenome.gfa.gz ${OUTPUTDIR}

# Unzip graph
#gzip -d ${OUTPUTDIR}/minigraph_cactus_pangenome.gfa.gz

#cd ${OUTPUTDIR}

# Create GBZ graph and indeces
#vg autoindex --workflow giraffe -g ${OUTPUTDIR}/minigraph_cactus_pangenome.gfa

# bowtie alignment
vg giraffe -Z ${OUTPUTDIR}/index.giraffe.gbz -f ${DATADIR}/short_reads_A1-108416_R1_001 \
 -f ${DATADIR}/short_reads_A1-108416_R2_001 -o SAM > ${OUTPUTDIR}/vg_align_short_reads.sam

