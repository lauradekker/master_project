#!/bin/bash

# Script to run minigraph-Cactus in order to construct a pangenome
# Need to activate environment before executing command:
# source /lustre/scratch123/tol/projects/cichlid/ldekker/software/cactus-bin-v2.6.7/venv-cactus-v2.6.7/bin/activate
# Script for minigraph-cactus on community chromosomes

# Number of the chromosome community we are working on right now
i=$1

OUTPUT_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/24_minigraph_cactus_communities/recon_pangenomes/chromosome${i}
#mkdir /lustre/scratch123/tol/projects/cichlid/ldekker/results/24_minigraph_cactus_communities/recon_pangenomes
#mkdir $OUTPUT_DIR

# Get current community directory content in a file
#ls /lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_community_dir/community${i} > dir_content${i}.txt

# Create file with paths to necessary community files
#while read LINE; do
#	COMMUNITY_PATH=${LINE%%_*}'\t'/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_community_dir/community${i}/${LINE}
#	echo -e ${COMMUNITY_PATH} >> cichlid_paths${i}.txt
#done < dir_content${i}.txt




# Activate environment
#source /lustre/scratch123/tol/projects/cichlid/ldekker/software/cactus-bin-v2.6.7/venv-cactus-v2.6.7/bin/activate

# Run minigraph-cactus
cactus-pangenome ./temp_cactus${i} ./cichlid_paths${i}.txt --outDir ${OUTPUT_DIR} --outName minigraph_cactus_community${i} \
 --reference orenil --gfa --vcf --odgi
	# ./temp_cactus	= temp directory for minigraph cactus software
	# ./cichlid_paths.txt	= file with the sample names, and paths to their data
	# --outDir	= Directory where to put the output of minigraph cactus
	# --outName 	= Name for the output files
	# --reference 	= the name of the sample to use as the reference for the graph
	# --gfa --vcf --odgi 	= specification of output formats

# Clear the file with paths
#rm cichlid_paths${i}.txt
#rm dir_content${i}.txt


