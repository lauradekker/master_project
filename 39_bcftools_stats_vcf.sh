#!/bin/bash

# Make stats files of filtered (>50bp) VCF files contained the structural variants between cichlids

i=$1

# Point to directory with data
#REFDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_community_dir/community${i}/orenil_chrom${i}
#RERULTS_DIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/36_bcftools_sv_filter
INPUT=/lustre/scratch123/tol/projects/cichlid/ldekker/results/34_vg_deconstruct_sv/community${i}/pggb_chr${i}_variants_lt50bp.vcf
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/39_bcftools_stats_vcf
#MINIGRAPHDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/19_minigraph_communities/recon/minigraph_community${i}.gfa
#CACTUSDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/24_minigraph_cactus_communities/recon_pangenomes/chromosome${i}/minigraph_cactus_community${i}.gfa
#PGGBDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/13_pggb_manual_communities_50k_segments/recon_pangenome/community${i}/community${i}*.final.gfa

# Create output directory
#mkdir /lustre/scratch123/tol/projects/cichlid/ldekker/results/35_vg_deconstruct_sv_minigraph
mkdir $OUTPUTDIR

# bcftools
bcftools stats ${INPUT} > ${OUTPUTDIR}/pggb_chr${i}_sv_stats
