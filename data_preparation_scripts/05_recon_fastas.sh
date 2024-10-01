#!/bin/bash

# Script to reconstruct the fasta files per species using the split, renamed and reverse complemented chromosome files

mkdir reconstructed_fastas

# AstCal
cat astcal_chrom* > reconstructed_fastas/fAstCal.fa

# PunNye
cat punnye_chrom* > reconstructed_fastas/fPunNye.fa

# NeoMul
cat neomul_chrom* > reconstructed_fastas/fNeoMul.fa

# OreNil
cat orenil_chrom* > reconstructed_fastas/fOreNil.fa

