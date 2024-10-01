#!/bin/bash

# Rename the split files accroding the actual chromosome number its content represents

# Rename with _r to prevent overwriting files

mv orenil_chrom03 orenil_chrom04_r
mv orenil_chrom04 orenil_chrom05_r
mv orenil_chrom05 orenil_chrom06_r
mv orenil_chrom06 orenil_chrom07_r
mv orenil_chrom07 orenil_chrom08_r
mv orenil_chrom08 orenil_chrom09_r
mv orenil_chrom09 orenil_chrom10_r
mv orenil_chrom10 orenil_chrom11_r
mv orenil_chrom11 orenil_chrom12_r
mv orenil_chrom12 orenil_chrom13_r
mv orenil_chrom13 orenil_chrom14_r
mv orenil_chrom14 orenil_chrom15_r
mv orenil_chrom15 orenil_chrom16_r
mv orenil_chrom16 orenil_chrom17_r
mv orenil_chrom17 orenil_chrom18_r
mv orenil_chrom18 orenil_chrom19_r
mv orenil_chrom19 orenil_chrom20_r
mv orenil_chrom20 orenil_chrom21_r
mv orenil_chrom21 orenil_chrom22_r
mv orenil_chrom22 orenil_chrom03_r

# Remove _r tag
for i in `seq 1 2`; do mv orenil_chrom0${i} orenil_chrom${i}; done
for i in `seq 3 9`; do mv orenil_chrom0${i}_r orenil_chrom${i}; done
for i in `seq 10 22`; do mv orenil_chrom${i}_r orenil_chrom${i}; done

# Rename PN with _r to prevent overwriting

mv punnye_chrom01 punnye_chrom03_r
mv punnye_chrom02 punnye_chrom07_r
mv punnye_chrom03 punnye_chrom21_r
mv punnye_chrom04 punnye_chrom16_r
mv punnye_chrom05 punnye_chrom01_r
mv punnye_chrom06 punnye_chrom11_r
mv punnye_chrom07 punnye_chrom15_r
mv punnye_chrom08 punnye_chrom19_r
mv punnye_chrom09 punnye_chrom18_r
mv punnye_chrom10 punnye_chrom22_r
mv punnye_chrom11 punnye_chrom10_r
mv punnye_chrom12 punnye_chrom17_r
mv punnye_chrom13 punnye_chrom05_r
mv punnye_chrom14 punnye_chrom09_r
mv punnye_chrom15 punnye_chrom08_r
mv punnye_chrom16 punnye_chrom14_r
mv punnye_chrom17 punnye_chrom20_r
mv punnye_chrom18 punnye_chrom06_r
mv punnye_chrom19 punnye_chrom02_r
mv punnye_chrom20 punnye_chrom04_r
mv punnye_chrom21 punnye_chrom13_r
mv punnye_chrom22 punnye_chrom12_r

# Remove _r tag
for i in `seq 1 9`; do mv punnye_chrom0${i}_r punnye_chrom${i}; done
for i in `seq 10 22`; do mv punnye_chrom${i}_r punnye_chrom${i}; done

# Remove 0 from other files

for i in `seq 1 9`; do mv neomul_chrom0${i} neomul_chrom${i}; done
for i in `seq 1 9`; do mv astcal_chrom0${i} astcal_chrom${i}; done


