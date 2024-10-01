#!/bin/bash

# Script to reverse some select chromosomes to improve inversed sequence rates

# List of chromosomes to invert
REV_LIST="orenil_chrom2 punnye_chrom3 orenil_chrom4 orenil_chrom6 punnye_chrom7 punnye_chrom8 astcal_chrom9 neomul_chrom9 punnye_chrom10 neomul_chrom12 orenil_chrom13 astcal_chrom14 punnye_chrom14 punnye_chrom15 orenil_chrom16 orenil_chrom17 orenil_chrom18 astcal_chrom19 neomul_chrom19 astcal_chrom20 neomul_chrom20 punnye_chrom21 astcal_chrom22 neomul_chrom22"

for i in $REV_LIST; do 
	mv ${i} ${i}_wo
	seqkit seq -r -p ${i}_wo > ${i} ; 
done
# -r: reverse sequence
# -p: complement sequence
# _wo stands for the file in the opposite complement and orientation from which we want it

rm astcal*_wo
rm orenil*_wo
rm punnye*_wo
rm neomul*_wo
