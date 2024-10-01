# Script to make complex upset plot with

# Load libraries
library(ggplot2)
library(ComplexUpset)

# try with 1 file

species <- c("AstCal", "NeoMul", "PunNye")
sv_presence <- species
vcf_file_number <- c(1,2, 4:22)

# loop over dev files
for(i in vcf_file_number){
  
  # Load file
  #i <- 1
  current_vcf_file <- read.delim(paste0("/lustre/scratch123/tol/projects/cichlid/ldekker/results/37_bcftools_sv_filter_minicactus/minigraph_cactus_community", i, "_lt50bp_noheader.vcf"),header = FALSE)
  col_names <- c('CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','AstCal','NeoMul','PunNye')
  colnames(current_vcf_file) <- col_names
  
  #Go over lines of file
  for(j in 1:nrow(current_vcf_file)){
    current_ref <- current_vcf_file$REF[j]
    current_variants <- matrix(unlist(strsplit(current_vcf_file$ALT[j], split=",")))
    #10=AC, 11=NM, 12=PN
    variant_presence <- current_vcf_file[j, 10:12]
    #print(paste0("current ref seq: ", current_ref))
    #print(paste0("current variant seq: ", length(current_variants)))
    #print(paste0("current variant presence: ", length(variant_presence)))
    
    # Go over current variants
    #   Test if SV?
    #   See which species it belongs
    for(k in 1:length(current_variants)){
      # test which species have the current SV present
      presence_vector <- variant_presence == k
      sv_presence <- rbind(sv_presence, presence_vector)
    }
  }
}

sv_presence <- as.data.frame(sv_presence[2:nrow(sv_presence),])
sv_presence$AstCal <- as.logical(sv_presence$AstCal)
sv_presence$NeoMul <- as.logical(sv_presence$NeoMul)
sv_presence$PunNye <- as.logical(sv_presence$PunNye)
# Filter out all falses? not sure why theyre there, but seem to be a very small fraction 
sv_presence <- sv_presence[-which(sv_presence$AstCal==FALSE & sv_presence$NeoMul==FALSE & sv_presence$PunNye==FALSE),]

write.table(sv_presence, "complex_upset_shared_svs.txt", sep=" ")

png("complex_upset_shared_svs.png", width=800, height=600)
upset(sv_presence, species)
dev.off()
