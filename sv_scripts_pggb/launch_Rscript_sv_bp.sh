#!/bin/bash

#for i in `seq 1 22`; 
#	do sed 's/ \+/\t/g' minigraph_cactus_community${i}_lt50bp_noheader.vcf > minigraph_cactus_community${i}_lt50bp_noheader_cleaned.vcf; 
#done

Rscript pggb_sv_data.R
