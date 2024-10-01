#!/bin/bash

# Align short reads to PunNye assembly using bwa

# Point to directory with data
DATADIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/sequencing_reads
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/27_bwa_align_short_reads.sh
REFERENCE=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_fastas/fPunNye.fa

# Make output directory
#mkdir ${OUTPUTDIR}

# bwa indexing
#~/programs/bwa-0.7.17/bwa index $REFERENCE

# bwa alignment read 1
~/programs/bwa-0.7.17/bwa mem $REFERENCE ${DATADIR}/short_reads_A1-108416_R1_001 > ${OUTPUTDIR}/bwa_align_short_reads1.sam
	# mem:	for Illumina paired-end & single-end reads of >70bp

# bwa alignment read 2
~/programs/bwa-0.7.17/bwa mem $REFERENCE ${DATADIR}/short_reads_A1-108416_R2_001 > ${OUTPUTDIR}/bwa_align_short_reads2.sam
