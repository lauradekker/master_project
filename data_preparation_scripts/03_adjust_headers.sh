#!/bin/bash

# Adjust headers inside the files

# AstCal
for i in `seq 1 22`; do
	HEADER=AstCal#1#chr${i} 
	sed -i "1s/.*/>$HEADER/g" "astcal_chrom${i}" ;
done

# PunNye
for i in `seq 1 22`; do
        HEADER=PunNye#1#chr${i}
        sed -i "1s/.*/>$HEADER/g" "punnye_chrom${i}" ;
done

# NeoMul, only has deviant numbering in file 21 & 22
for i in `seq 21 22`; do
        HEADER=NeoMul#1#chr${i}
        sed -i "1s/.*/>$HEADER/g" "neomul_chrom${i}" ;
done

# OreNil
for i in `seq 1 22`; do
        HEADER=OreNil#1#chr${i}
        sed -i "1s/.*/>$HEADER/g" "orenil_chrom${i}" ;
done
