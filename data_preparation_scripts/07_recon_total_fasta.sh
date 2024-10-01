#!/bin/bash

# Script to reconstruct the total fasta file with the chromsomes in correct order

mkdir reconstructed_total_fasta

cat reconstructed_fastas/f* > reconstructed_total_fasta/fTotalCichlids.fa
