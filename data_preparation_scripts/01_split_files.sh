#!/bin/bash

# Commands to split the files by delimiter '>'
# AstCal
csplit -f astcal_chrom ../fAstCal14_final.fa '/^>/' '{*}'
        # '/^>/' refers to the pattern '>' that we are looking for only at the start of the line
        # -f determines the prefix for the different files
        # space after that determines the file we want to split

# NeoMul
csplit -f neomul_chrom ../fNeoMul12_final.fa '/^>/' '{*}'

# OreNil
csplit -f orenil_chrom ../fOreNil_final.fa '/^>/' '{*}'

# PunNye
csplit -f punnye_chrom ../fPunNye_final.fa '/^>/' '{*}'

rm astcal_chrom00
rm neomul_chrom00
rm orenil_chrom00
rm punnye_chrom00
