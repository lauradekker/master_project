#!/bin/bash

# Script to run minigraph-Cactus in order to construct a pangenome
# Need to activate environment before executing command:
# source /lustre/scratch123/tol/projects/cichlid/ldekker/software/cactus-bin-v2.6.7/venv-cactus-v2.6.7/bin/activate
# This one made to run the reconstructed assemblies

OUTPUT_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/22_minigraph_cactus_pangenome/recon_pangenome/copy
mkdir $OUTPUT_DIR

cactus-pangenome ./temp_cactus ./cichlids.txt --outDir ${OUTPUT_DIR} --outName minigraph_cactus_pangenome \
 --reference OreNil --giraffe --gbz --gfa --vcf --odgi
	# ./temo_cactus:	temporary dir for cactus, make sure it does NOT exist before running command
	# ./cichlids.txt:	file with the names of and paths to the cichlid assembly files
	# --outDir:		Directory in which to deposit the output
	# --outName:		Name of the output files
	# --reference:		Which assembly to use as a reference to build graph from
	# --gbz:		Output GBZ format, needed for alignments with vg giraffe
	# --gfa: 		Standard pangenome output format
	# --vcf:		Output Variant Call Format, perhaps good for finding SVs
	# --odgi:		Output ODGI format, used for ODGI pangenome graph visualization
	# --giraffe:		Needed to produce index files needed for vg graph alignment

