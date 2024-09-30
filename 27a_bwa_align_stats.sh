#!/bin/bash

# Get statistics of alignment from short reads to PunNye assembly with bwa

# Point to directory with data
DATADIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/27_bwa_align_short_reads.sh/
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/27_bwa_align_short_reads.sh
#REFERENCE=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_fastas/fPunNye.fa

# Get alignment statistics
samtools flagstat ${DATADIR}/bwa_align_short_reads1.sam > ${OUTPUTDIR}/bwa_align_flagstats_reads1.txt

# Get more detailed stats?
samtools stats ${DATADIR}/bwa_align_short_reads1.sam > ${OUTPUTDIR}/bwa_align_stats_reads1.txt

# Get alignment statistics
samtools flagstat ${DATADIR}/bwa_align_short_reads2.sam > ${OUTPUTDIR}/bwa_align_flagstats_reads2.txt

# Get more detailed stats?
samtools stats ${DATADIR}/bwa_align_short_reads2.sam > ${OUTPUTDIR}/bwa_align_stats_reads2.txt
