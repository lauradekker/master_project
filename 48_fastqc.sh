#!/bin/bash

# Do FastQC of sequencing reads

# Point to directory with data
#INPUT_READS1=/lustre/scratch123/tol/projects/cichlid/ldekker/data/sequencing_reads/short_reads_A1-108416_R1_001
INPUT_READS1=/lustre/scratch123/tol/projects/cichlid/OleAndKillifish/A1-108416_R1_001.fastq.gz
#INPUT_READS2=/lustre/scratch123/tol/projects/cichlid/ldekker/data/sequencing_reads/short_reads_A1-108416_R2_001
INPUT_READS2=/lustre/scratch123/tol/projects/cichlid/OleAndKillifish/A1-108416_R2_001.fastq.gz
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/48_fastqc

# Create output directory
mkdir $OUTPUTDIR
#mkdir ${OUTPUTDIR}/reads1
#mkdir ${OUTPUTDIR}/reads2

# Do fastqc over the pair of reads
~/programs/FastQC/fastqc -t 2 -o $OUTPUTDIR -f fastq $INPUT_READS2
	# -o = outpur directory
	# -f = specification of input file format
	# -t = amount of threads / amount of files that can be processed simultaneously

