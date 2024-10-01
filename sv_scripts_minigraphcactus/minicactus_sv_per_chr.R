# File for reporting SV per category per chromosome for miniactus pangenome graph called SVs

library(ggplot2)

# Initialize variables
sv_categories <- c("total svs", "complete insertion", "partial insertion", "complete deletion", "partial deletion", "substitution")
sv_count_df <- sv_categories
sv_length_df <- sv_categories

vcf_file_number <- c(1,2, 4:22)

# loop over dev files
for(i in vcf_file_number){
  # Load file
  #i <- 1
  current_vcf_file <- read.delim(paste0("/lustre/scratch123/tol/projects/cichlid/ldekker/results/37_bcftools_sv_filter_minicactus/minigraph_cactus_community", i, "_lt50bp_noheader.vcf"),header = FALSE)
  col_names <- c('CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','AstCal','NeoMul','PunNye')
  colnames(current_vcf_file) <- col_names
  
  # initialize counters for the current chr file
  total_sv_count <- 0
  total_sv_length_bp <- 0
  
  complete_deletion_count <- 0
  complete_deletion_length_bp <- 0
  
  partial_deletion_count <- 0
  partial_deletion_length_bp <- 0
  
  complete_insertion_count <- 0
  complete_insertion_length_bp <- 0
  
  partial_insertion_count <- 0
  partial_insertion_length_bp <- 0
  
  exact_substitution_count <- 0
  exact_substitution_length_bp <- 0
  
  #Go over lines of file
  for(j in 1:nrow(current_vcf_file)){
    
    # Get the current REF sequence and length
    current_ref <- current_vcf_file$REF[j]
    length_current_ref <- nchar(current_ref)
    # Get the variants at current location
    current_variants <- matrix(unlist(strsplit(current_vcf_file$ALT[j], split=",")))
    #10=AC, 11=NM, 12=PN
    variant_presence <- current_vcf_file[j, 10:12]
    
    # Determine the amount of SVs present at this location
    amount_variants <- length(current_variants)
    
    # Go over the currently reported variants
    for(k in 1:length(amount_variants)){
      total_sv_count <- total_sv_count + 1
      
      current_variant <- current_variants[k]
      length_current_variant <- nchar(current_variant)
      
      # Test what kind of variant we are dealing with
      # ref > alt = deletion
      if(length_current_ref > length_current_variant){
        
        # If the length of the deleted location is 1 it is a complete deletion
        if(length_current_variant == 1){
          complete_deletion_count <- complete_deletion_count + 1
          complete_deletion_length_bp <- complete_deletion_length_bp + length_current_ref
          total_sv_length_bp <- total_sv_length_bp + length_current_ref
        } else if(length_current_variant > 1){
          partial_deletion_count <- partial_deletion_count + 1
          length_diff <- length_current_ref - length_current_variant
          partial_deletion_length_bp <- partial_deletion_length_bp + length_diff
          total_sv_length_bp <- total_sv_length_bp + length_diff
        }
        
        # if ref is smaller than alt there is an insertion
      } else if(length_current_ref < length_current_variant){
        
        # if the length of ref is 1 then it is a complete insertion
        if(length_current_ref == 1){
          complete_insertion_count <- complete_insertion_count + 1
          complete_insertion_length_bp <- complete_insertion_length_bp + length_current_variant
          total_sv_length_bp <- total_sv_length_bp + length_current_variant
        } else if(length_current_ref > 1) {
          partial_insertion_count <- partial_insertion_count + 1
          length_diff <- length_current_variant - length_current_ref
          partial_insertion_length_bp <- partial_insertion_length_bp + length_diff
          total_sv_length_bp <- total_sv_length_bp + length_diff
        }
        
        # if the length is exactly the same we have a substitution
      } else if(length_current_ref == length_current_variant){
        exact_substitution_count <- exact_substitution_count + 1
        exact_substitution_length_bp <- exact_substitution_length_bp + length_current_ref
        total_sv_length_bp <- total_sv_length_bp + length_current_ref
      }
    }
  }
  
  # Make new row vectors
  new_count_row <- c(total_sv_count, complete_insertion_count, partial_insertion_count, complete_deletion_count, partial_deletion_count, exact_substitution_count)
  new_length_row <- c(total_sv_length_bp, complete_insertion_length_bp, partial_insertion_length_bp, complete_deletion_length_bp, partial_deletion_length_bp, exact_substitution_length_bp)
  
  #Append new rows to counter dfs
  sv_count_df <- rbind(sv_count_df, new_count_row)
  sv_length_df <- rbind(sv_length_df, new_length_row)
}

# Write count & lengt dfs to txt file
sv_count_df <- sv_count_df[2:nrow(sv_count_df),]
colnames(sv_count_df) <- sv_categories
rownames(sv_count_df) <- vcf_file_number
write.table(sv_count_df, "sv_count_per_chromosome.txt", sep=" ")

sv_length_df <- sv_length_df[2:nrow(sv_length_df),]
colnames(sv_length_df) <- sv_categories
rownames(sv_length_df) <- vcf_file_number
write.table(sv_length_df, "sv_length_per_chromosome.txt", sep=" ")

# Make ggplot format and plot to png
categories_ggplot <- colnames(sv_count_df)[2:length(colnames(sv_count_df))]

chrom_label_reps <- length(categories_ggplot)
chr <- c()
for(i in vcf_file_number){
  chr_rep <- rep(paste0("chr", i), chrom_label_reps)
  chr <- append(chr, chr_rep)
}

sv_category <- rep(categories_ggplot, length(vcf_file_number))

# ggplot counts
sv_counts <- c()
for(i in 1:nrow(sv_count_df)){
  chr_counts <- as.numeric(sv_count_df[i, 2:ncol(sv_count_df)])
  sv_counts <- append(sv_counts, chr_counts)
}

sv_count_df_ggplot <- data.frame(chr, sv_category, sv_counts)
write.table(sv_count_df_ggplot, "sv_count_per_chromosome_ggplot.txt", sep=" ")
sv_count_df_ggplot$chr <- factor(sv_count_df_ggplot$chr, levels=unique(sv_count_df_ggplot$chr))

png("sv_count_per_chromosome_ggplot.png", width = 1000)
ggplot(sv_count_df_ggplot, aes(fill=sv_category, y=sv_counts, x=chr)) +
  geom_bar(position="stack", stat="identity") +
  xlab("Chromosome") +
  ylab("Frequency") +
  labs(fill = "SV type")
dev.off()

# ggplot length
sv_lengths <- c()
for(i in 1:nrow(sv_length_df)){
  chr_lengths <- as.numeric(sv_length_df[i, 2:ncol(sv_length_df)])
  sv_lengths <- append(sv_lengths, chr_lengths)
}

sv_length_df_ggplot <- data.frame(chr, sv_category, sv_lengths)
write.table(sv_length_df_ggplot, "sv_length_per_chromosome_ggplot.txt", sep=" ")
sv_length_df_ggplot$chr <- factor(sv_length_df_ggplot$chr, levels=unique(sv_length_df_ggplot$chr))

png("sv_length_per_chromosome_ggplot.png", width = 1000)
ggplot(sv_length_df_ggplot, aes(fill=sv_category, y=sv_lengths, x=chr)) +
  geom_bar(position="stack", stat="identity") +
  xlab("Chromosome") +
  ylab("Length in bp") +
  labs(fill = "SV type")
dev.off()

