#!/bin/bash

# Call SVs using vg call

i=$1

# Point to directory with data
REFDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/data/reversed_orenil_ref/reconstructed_community_dir/community${i}/orenil_chrom${i}
OUTPUTDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/34_vg_deconstruct_sv/community${i}
MINIGRAPHDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/19_minigraph_communities/recon/minigraph_community${i}.gfa
CACTUSDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/24_minigraph_cactus_communities/recon_pangenomes/chromosome${i}/minigraph_cactus_community${i}.gfa
PGGBDIR=/lustre/scratch123/tol/projects/cichlid/ldekker/results/13_pggb_manual_communities_50k_segments/recon_pangenome/community${i}/community${i}*.final.gfa

# Create output directory
#mkdir $OUTPUTDIR

# Call SVs into VCFs using vg deconstruct on PGGB

#convert gfa to vg format
#vg convert -g $PGGBDIR > $OUTPUTDIR/pggb_chr${i}_graph.vg
#index vg graph
#vg index -x $OUTPUTDIR/pggb_chr${i}_graph.xg $OUTPUTDIR/pggb_chr${i}_graph.vg
#make snarls file
#vg snarls -t 8 $OUTPUTDIR/pggb_graph.vg > $OUTPUTDIR/pggb_graph.snarls
#call variants from path within graph
#vg call $OUTPUTDIR/pggb_chr1_graph.xg -r "OreNil#1#chr1#0" > $OUTPUTDIR/pggb_chr1_variants.vcf
#call variants with vg deconstruct

# Check paths: vg paths -L -x pggb_graph.xg
#echo "OreNil#1#chr"${i}"#0" >> check_paths_vgdecon.txt
vg deconstruct $OUTPUTDIR/pggb_chr3_graph.xg -e -p "OreNil#1#chr3#0" -t 8 --verbose > $OUTPUTDIR/pggb_chr3_variants.vcf

