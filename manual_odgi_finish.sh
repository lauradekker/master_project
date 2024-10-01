#!/bin/bash

# Old script to manually run odgi commands with
# was lost in directory results/09_pggb_manual_communities/chromosome2
# Now try for PBBG 50k recon

#i=$1 #Enter the number of the chromosome for which we want to finish the PGGB process

#WORKINGDIRECTORY=/lustre/scratch123/tol/projects/cichlid/ldekker/results/13_pggb_manual_communities_50k_segments/chromosome${i}

INPUTFILE=$1
	# ODGI smooth.fix.gfa file path from crashed PGGB runs
WORKDIR=${1%/*}
echo $WORKDIR

#odgi_script=/lustre/scratch123/tol/projects/cichlid/ldekker/software/odgi
#multiqc_script=/lustre/scratch123/tol/projects/cichlid/ldekker/software/miniconda/miniconda3/bin/multiqc

#odgi build -t 8 -P -g ${INPUTFILE} -o - -O | odgi unchop -P -t 8 -i - -o - | odgi sort -P -p Ygs --temp-dir ${WORKDIR} -t 8 -i - -o ${INPUTFILE}.smooth.final.og
odgi build -t 8 -P -g ${INPUTFILE} -o ${INPUTFILE}.smooth.final.og -O

#odgi view -i ${INPUTFILE}.smooth.final.og -g > ${INPUTFILE}.smooth.final.gfa

#odgi build -t 8 -P -g ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.seqwish.gfa -o ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.seqwish.og

#odgi stats -i ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.seqwish.og -m -sgdl > ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.seqwish.og.stats.yaml

#odgi stats -i ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.53439a3.smooth.final.og -m  -sgdl > ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.53439a3.smooth.final.og.stats.yaml

odgi viz -i ${INPUTFILE}.smooth.final.og -o ${INPUTFILE}.smooth.final.og.viz_multiqc.png -x 1500 -y 500 -a 10

odgi viz -i ${INPUTFILE}.smooth.final.og -o ${INPUTFILE}.smooth.final.og.viz_depth_multiqc.png -x 1500 -y 500 -a 10 -m

odgi viz -i ${INPUTFILE}.smooth.final.og -o ${INPUTFILE}.smooth.final.og.viz_inv_multiqc.png -x 1500 -y 500 -a 10 -z

odgi viz -i ${INPUTFILE}.smooth.final.og -o ${INPUTFILE}.smooth.final.og.viz_O_multiqc.png -x 1500 -y 500 -a 10 -O

odgi viz -i ${INPUTFILE}.smooth.final.og -o ${INPUTFILE}.smooth.final.og.viz_uncalled_multiqc.png -x 1500 -y 500 -a 10 -N

odgi viz -i ${INPUTFILE}.smooth.final.og -o ${INPUTFILE}.smooth.final.og.viz_pos_multiqc.png -u -d

#odgi layout -i ${INPUTFILE}.smooth.final.og -o ${INPUTFILE}.smooth.final.og.lay -T ${INPUTFILE}.smooth.final.og.lay.tsv -t 8 --temp-dir ./temp_pggb

#odgi draw -i ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.53439a3.smooth.final.og -c ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.53439a3.smooth.final.og.lay -p ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.53439a3.smooth.final.og.lay.draw.png -H 5000 -t 8 -P -s ${WORKINGDIRECTORY}/chromosome${i}.fa.dac1d73.11fba48.53439a3.smooth.final.og.lay.draw.svg

#odgi draw -i ${WORKINGDIRECTORY}/chromosome${i}.fa.c325321.11fba48.53439a3.smooth.final.og -c ${WORKINGDIRECTORY}/chromosome${i}.fa.c325321.11fba48.53439a3.smooth.final.og.lay -p ${WORKINGDIRECTORY}/chromosome${i}.fa.c325321.11fba48.53439a3.smooth.final.og.lay.draw_multiqc.png -H 1000 -C -w 20

#multiqc ${WORKINGDIRECTORY} -s -o ${WORKINGDIRECTORY} -c /lustre/scratch123/tol/projects/cichlid/ldekker/results/13_pggb_manual_communities_50k_segments/multiqc_config.yaml
