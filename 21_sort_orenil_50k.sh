#!/bin/bash

# Script to sort the images of the 50k segment PGGB pangenome graphs according to OreNil

#for x in `seq 1 22`; do odgi paths -i /lustre/scratch123/tol/projects/cichlid/ldekker/results/13_pggb_manual_communities_50k_segments/chromosome${x}/chromosome${x}.fa.dac1d73.11fba48.53439a3.smooth.final.og -L | head -n 3 | tail -n 1 >> OreNilPath; done

for x in `seq 1 22`; do

# Define input file
OG_INPUT=../results/13_pggb_manual_communities_50k_segments/chromosome${x}/chromosome${x}.fa.dac1d73.11fba48.53439a3.smooth.final.og ;

#echo ${OG_INPUT} >> test_file_names.txt
#done

# Determine the current OreNil label, is always on the 3rd line of output file; needs to be in file to be recognised
odgi paths -i ${OG_INPUT} -L | head -n 3 | tail -n 1 > OreNilPath ;
odgi groom -i ${OG_INPUT} -R OreNilPath -o ${OG_INPUT}.groom_orenil1.og ;
odgi viz -i ${OG_INPUT}.groom_orenil1.og -o ${OG_INPUT}.groom_orenil1.og.z.png -z ;
odgi sort -i ${OG_INPUT}.groom_orenil1.og -H OreNilPath -o ${OG_INPUT}.Y_orenil1.og -t 8 -P -Y ;
odgi viz -i ${OG_INPUT}.Y_orenil1.og -o ${OG_INPUT}.Y_orenil1.og.du.png ;
done





