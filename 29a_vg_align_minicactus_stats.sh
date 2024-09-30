#!/bin/bash

# Get statistics of alignment from short reads to Minigraph-Cactus pangenome with vg giraffe

# Point to directory with data
DATADIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/29_vg_align_short_reads
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/29_vg_align_short_reads
#REFERENCE=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_fastas/fPunNye.fa

# Get alignment statistics
samtools flagstat ${DATADIR}/vg_align_short_reads.sam > ${OUTPUTDIR}/vg_align_short_reads_flagstats.txt

# Get more detailed stats?
samtools stats ${DATADIR}/vg_align_short_reads.sam > ${OUTPUTDIR}/vg_align_short_reads_stats.txt
