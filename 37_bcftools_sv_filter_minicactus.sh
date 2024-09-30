#!/bin/bash

# Filter .vcf files for SVs (>50bp) using bcftools

i=$1

# Unzip mini-cactus output file
#gzip -d /lustre/scratch123/tol/projects/cichlid/ldekker/results/24_minigraph_cactus_communities/recon_pangenomes/chromosome${i}/minigraph_cactus_community${i}.vcf.gz

# Point to directory with data
#REFDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_community_dir/community${i}/orenil_chrom${i}
#RERULTS_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/36_bcftools_sv_filter
INPUT=/lustre/scratch123/tol/projects/cichlid/ldekker/results/24_minigraph_cactus_communities/recon_pangenomes/chromosome${i}/minigraph_cactus_community${i}.vcf
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/37_bcftools_sv_filter_minicactus
#MINIGRAPHDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/19_minigraph_communities/recon/minigraph_community${i}.gfa
#CACTUSDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/24_minigraph_cactus_communities/recon_pangenomes/chromosome${i}/minigraph_cactus_community${i}.gfa
#PGGBDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/13_pggb_manual_communities_50k_segments/recon_pangenome/community${i}/community${i}*.final.gfa

# Create output directory
#mkdir /lustre/scratch123/tol/projects/cichlid/ldekker/results/35_vg_deconstruct_sv_minigraph
#mkdir $OUTPUTDIR

# bcftools
bcftools view -i 'abs(ILEN)>=50' ${INPUT} > ${OUTPUTDIR}/minigraph_cactus_community${i}_lt50bp.vcf
	# -i: include, keep the variants that meet the requirements 'abs(ILEN)>=50', meaning they are larger than 50 bp
