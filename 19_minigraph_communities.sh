#!/bin/bash

# Minigraph on chromosome communities
# switched astcal for orenil as backbone
# Used the properly reverse complemented assemblies

i=$1

# Point to directory with data
DATADIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_community_dir/community${1}
RESULTSDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/19_minigraph_communities/recon
#OUTPUTDIR=${RESULTSDIR}/chromosome1_orenil_ref
#mkdir ${RESULTSDIR}
#mkdir ${OUTPUTDIR}

# Minigraph
../software/minigraph/minigraph -cxggs -t8 ${DATADIR}/orenil_chrom${1} ${DATADIR}/astcal_chrom${1} ${DATADIR}/neomul_chrom${1} \
${DATADIR}/punnye_chrom${1} > ${RESULTSDIR}/minigraph_community${1}.gfa
	# -cxggs : make graphs from multiple input fastas
	# -t : number of threads/cpus


