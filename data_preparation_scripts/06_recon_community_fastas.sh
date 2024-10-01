#!/bin/bash

# Script to reconstruct the community fasta files

mkdir reconstructed_community_fastas

for i in `seq 1 22`; do
	cat *chrom${i} > reconstructed_community_fastas/community${i}.fa;
done
