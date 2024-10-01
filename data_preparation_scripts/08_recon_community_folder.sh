#!/bin/bash

# Script to move the chromosome files into the community directories

mkdir reconstructed_community_dir

for i in `seq 1 22`; do
	mkdir reconstructed_community_dir/community${i}
	mv *chrom${i} reconstructed_community_dir/community${i};
done
