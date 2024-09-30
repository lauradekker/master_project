#!/bin/bash

# Script to manually finish odgi for pbbg 50k recon communities


for i in 2; do
	./manual_odgi_finish.sh /lustre/scratch123/tol/projects/cichlid/ldekker/results/13_pggb_manual_communities_50k_segments/recon_pangenome/community${i}/community${i}.fa.*.smooth.fix.gfa;
done
