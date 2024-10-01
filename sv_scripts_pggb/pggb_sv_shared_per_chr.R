# File to compute and plot the count and length of shared and unique SVs for pggb

library(ggplot2)

# Initialize variables
species <- c("AstCal", "NeoMul", "PunNye")
#sv_presence <- species
vcf_file_number <- c(1,2, 4:22)
sv_shared_categories <- c("all", "ac & nm", "ac & pn", "nm & pn", "ac", "nm", "pn")
sv_shared_counts_df <- sv_shared_categories
sv_shared_seq_df <- sv_shared_categories
vcf_file_number <- c(1,2, 4:22)

# Functions

#Count SV per category of inputfile and return vector/df with seq length per category
count_seq_lengths <- function(shared_category_file){
  
  #Return 0 for everything if there is no content in file
  if(nrow(shared_category_file)==0){
    return(c(0,0,0,0,0,0,0))
  }
  
  #Initialize counters
  total_sv_length_bp <- 0
  complete_deletion_length_bp <- 0
  partial_deletion_length_bp <- 0
  complete_insertion_length_bp <- 0
  partial_insertion_length_bp <- 0
  exact_substitution_length_bp <- 0
  
  # Loop over file lines and add to proper counter
  for(i in 1:nrow(shared_category_file)){
    
    #print(paste0("current_row: ", i))
    
    # Determine the lengths of the ref and alt sequence
    length_ref <- nchar(shared_category_file$current_file_ref_seq_rep[i])
    #print(paste0("length_ref: ", length_ref))
    length_alt <- nchar(shared_category_file$current_file_variants[i])
    #print(paste0("length_alt: ", length_alt))
    
    
    if(length_ref > length_alt){
      
      # If the length of the deleted location is 1 it is a complete deletion
      if(length_alt == 1){
        #complete_deletion_count <- complete_deletion_count + 1
        complete_deletion_length_bp <- complete_deletion_length_bp + length_ref
        total_sv_length_bp <- total_sv_length_bp + length_ref
      } else if(length_alt > 1){
        #partial_deletion_count <- partial_deletion_count + 1
        length_diff <- length_ref - length_alt
        partial_deletion_length_bp <- partial_deletion_length_bp + length_diff
        total_sv_length_bp <- total_sv_length_bp + length_diff
      }
      
      # if ref is smaller than alt there is an insertion
    } else if(length_ref < length_alt){
      
      # if the length of ref is 1 then it is a complete insertion
      if(length_ref == 1){
        #complete_insertion_count <- complete_insertion_count + 1
        complete_insertion_length_bp <- complete_insertion_length_bp + length_alt
        total_sv_length_bp <- total_sv_length_bp + length_alt
      } else if(length_ref > 1) {
        #partial_insertion_count <- partial_insertion_count + 1
        length_diff <- length_alt - length_ref
        partial_insertion_length_bp <- partial_insertion_length_bp + length_diff
        total_sv_length_bp <- total_sv_length_bp + length_diff
      }
      
      # if the length is exactly the same we have a substitution
    } else if(length_ref == length_alt){
      #exact_substitution_count <- exact_substitution_count + 1
      exact_substitution_length_bp <- exact_substitution_length_bp + length_ref
      total_sv_length_bp <- total_sv_length_bp + length_ref
    }
  }
  
  #sum over all the individual categories, should be near number of total_sv_length_bp
  sum_cat_seq <- sum(complete_deletion_length_bp, partial_deletion_length_bp, complete_insertion_length_bp, partial_insertion_length_bp, exact_substitution_length_bp)
  sv_cat_seq_vec <- c(total_sv_length_bp, sum_cat_seq, complete_deletion_length_bp, partial_deletion_length_bp, complete_insertion_length_bp, partial_insertion_length_bp, exact_substitution_length_bp)
  
  return(sv_cat_seq_vec)
}

# loop over dev files
for(i in vcf_file_number){
  
  # Load file
  #i <- 1
  current_vcf_file <- read.delim(paste0("/lustre/scratch123/tol/projects/cichlid/ldekker/results/43_pggb_sv_analysis_R/vcf_files/pggb_chr", i, "_variants_lt50bp_noheader.vcf"),header = FALSE)
  col_names <- c('CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','AstCal','NeoMul','PunNye')
  colnames(current_vcf_file) <- col_names
  current_file_variants <- c()
  current_file_ref_seq_rep <- c()
  sv_presence <- species
  
  #Go over lines of file
  for(j in 1:nrow(current_vcf_file)){
    current_ref <- current_vcf_file$REF[j]
    current_variants <- matrix(unlist(strsplit(current_vcf_file$ALT[j], split=",")))
    #append the variants for new row
    current_file_variants <- append(current_file_variants, current_variants)
    #10=AC, 11=NM, 12=PN
    variant_presence <- current_vcf_file[j, 10:12]
    #print(paste0("current ref seq: ", current_ref))
    #print(paste0("current variant seq: ", length(current_variants)))
    #print(paste0("current variant presence: ", length(variant_presence)))
    
    # Go over current variants
    #   Test if SV?
    #   See which species it belongs
    for(k in 1:length(current_variants)){
      # append current variant to the vector
      #current_file_variants <- append(current_file_variants, current_variants[k])
      # Make a vector equally long with the reference sequence to later determine the length of seq in bp that is shared or unique
      current_file_ref_seq_rep <- append(current_file_ref_seq_rep, current_ref)
      # test which species have the current SV present
      presence_vector <- variant_presence == k
      sv_presence <- rbind(sv_presence, presence_vector)
    }
  }
  
  # Construct logical df with ref and alt sequences added to later calculate sequence length
  sv_presence <- as.data.frame(sv_presence[2:nrow(sv_presence),])
  sv_presence$AstCal <- as.logical(sv_presence$AstCal)
  sv_presence$NeoMul <- as.logical(sv_presence$NeoMul)
  sv_presence$PunNye <- as.logical(sv_presence$PunNye)
  sv_presence <- cbind(sv_presence, current_file_ref_seq_rep, current_file_variants)
  
  #filter files based on which way SVs are shared between species
  sv_shared_all <- sv_presence[which(sv_presence$AstCal==TRUE & sv_presence$NeoMul==TRUE & sv_presence$PunNye==TRUE),]
  sv_shared_ac_nm <- sv_presence[which(sv_presence$AstCal==TRUE & sv_presence$NeoMul==TRUE & sv_presence$PunNye==FALSE),]
  sv_shared_ac_pn <- sv_presence[which(sv_presence$AstCal==TRUE & sv_presence$NeoMul==FALSE & sv_presence$PunNye==TRUE),]
  sv_shared_nm_pn <- sv_presence[which(sv_presence$AstCal==FALSE & sv_presence$NeoMul==TRUE & sv_presence$PunNye==TRUE),]
  sv_unique_ac <- sv_presence[which(sv_presence$AstCal==TRUE & sv_presence$NeoMul==FALSE & sv_presence$PunNye==FALSE),]
  sv_unique_nm <- sv_presence[which(sv_presence$AstCal==FALSE & sv_presence$NeoMul==TRUE & sv_presence$PunNye==FALSE),]
  sv_unique_pn <- sv_presence[which(sv_presence$AstCal==FALSE & sv_presence$NeoMul==FALSE & sv_presence$PunNye==TRUE),]
  
  # Count the number of rows for the filtered files to determine the count of SVs shared
  sv_shared_all_count <- nrow(sv_shared_all)
  sv_shared_ac_nm_count <- nrow(sv_shared_ac_nm)
  sv_shared_ac_pn_count <- nrow(sv_shared_ac_pn)
  sv_shared_nm_pn_count <- nrow(sv_shared_nm_pn)
  sv_unique_ac_count <- nrow(sv_unique_ac)
  sv_unique_nm_count <- nrow(sv_unique_nm)
  sv_unique_pn_count <- nrow(sv_unique_pn)
  
  # Sum the amount of SV sequence shared per category
  sv_shared_all_seq <- count_seq_lengths(sv_shared_all)[2] #index 2 is sum of seq in all categories, matched total seq counted in index 1 (see function for rest of vec content)
  sv_shared_ac_nm_seq <- count_seq_lengths(sv_shared_ac_nm)[2]
  sv_shared_ac_pn_seq <- count_seq_lengths(sv_shared_ac_pn)[2]
  sv_shared_nm_pn_seq <- count_seq_lengths(sv_shared_nm_pn)[2]
  sv_unique_ac_seq <- count_seq_lengths(sv_unique_ac)[2]
  sv_unique_nm_seq <- count_seq_lengths(sv_unique_nm)[2]
  sv_unique_pn_seq <- count_seq_lengths(sv_unique_pn)[2]
  
  #Add row to df shared counts
  sv_shared_counts_row <- c(sv_shared_all_count, sv_shared_ac_nm_count, sv_shared_ac_pn_count, sv_shared_nm_pn_count, sv_unique_ac_count, sv_unique_nm_count, sv_unique_pn_count)
  sv_shared_counts_df <- rbind(sv_shared_counts_df, sv_shared_counts_row)
  
  #Add row to df shared seq
  sv_shared_seq_row <- c(sv_shared_all_seq, sv_shared_ac_nm_seq, sv_shared_ac_pn_seq, sv_shared_nm_pn_seq, sv_unique_ac_seq, sv_unique_nm_seq, sv_unique_pn_seq)
  sv_shared_seq_df <- rbind(sv_shared_seq_df, sv_shared_seq_row)
}


# Write shared counts df to text file
sv_shared_counts_df <- sv_shared_counts_df[2:nrow(sv_shared_counts_df),]
colnames(sv_shared_counts_df) <- sv_shared_categories
rownames(sv_shared_counts_df) <- vcf_file_number
write.table(sv_shared_counts_df, "sv_shared_count_per_chromosome.txt", sep=" ")

# Write shared seq df to text file
sv_shared_seq_df <- sv_shared_seq_df[2:nrow(sv_shared_seq_df),]
colnames(sv_shared_seq_df) <- sv_shared_categories
rownames(sv_shared_seq_df) <- vcf_file_number
write.table(sv_shared_seq_df, "sv_shared_seq_per_chromosome.txt", sep=" ")


# Make ggplot style dfs and plot
categories_ggplot <- colnames(sv_shared_counts_df)[1:length(colnames(sv_shared_counts_df))]

chrom_label_reps <- length(categories_ggplot)
chr <- c()
for(i in vcf_file_number){
  chr_rep <- rep(paste0("chr", i), chrom_label_reps)
  chr <- append(chr, chr_rep)
}

shared_category <- rep(categories_ggplot, length(vcf_file_number))

# ggplot counts
sv_shared_counts_ggplot <- c()
for(i in 1:nrow(sv_shared_counts_df)){
  chr_counts <- as.numeric(sv_shared_counts_df[i, 1:ncol(sv_shared_counts_df)])
  sv_shared_counts_ggplot <- append(sv_shared_counts_ggplot, chr_counts)
}

sv_shared_count_df_ggplot <- data.frame(chr, shared_category, sv_shared_counts_ggplot)
write.table(sv_shared_count_df_ggplot, "sv_shared_count_per_chromosome_ggplot.txt", sep=" ")
sv_shared_count_df_ggplot$chr <- factor(sv_shared_count_df_ggplot$chr, levels=unique(sv_shared_count_df_ggplot$chr))
sv_shared_count_df_ggplot$shared_category <- factor(sv_shared_count_df_ggplot$shared_category, levels=unique(sv_shared_count_df_ggplot$shared_category))

png("sv_shared_count_per_chromosome_ggplot.png", width = 1000)
ggplot(sv_shared_count_df_ggplot, aes(fill=shared_category, y=sv_shared_counts_ggplot, x=chr)) +
  geom_bar(position="stack", stat="identity") +
  xlab("Chromosome") +
  ylab("Frequency") +
  labs(fill = "Groups") +
  ylim(NA, 71172) # obtained from script to determine max values
dev.off()

# ggplot seq
sv_shared_seq_ggplot <- c()
for(i in 1:nrow(sv_shared_seq_df)){
  chr_counts <- as.numeric(sv_shared_seq_df[i, 1:ncol(sv_shared_seq_df)])
  sv_shared_seq_ggplot <- append(sv_shared_seq_ggplot, chr_counts)
}

sv_shared_seq_df_ggplot <- data.frame(chr, shared_category, sv_shared_seq_ggplot)
write.table(sv_shared_seq_df_ggplot, "sv_shared_seq_per_chromosome_ggplot.txt", sep=" ")
sv_shared_seq_df_ggplot$chr <- factor(sv_shared_seq_df_ggplot$chr, levels=unique(sv_shared_seq_df_ggplot$chr))
sv_shared_seq_df_ggplot$shared_category <- factor(sv_shared_seq_df_ggplot$shared_category, levels=unique(sv_shared_seq_df_ggplot$shared_category))

png("sv_shared_seq_per_chromosome_ggplot.png", width = 1000)
ggplot(sv_shared_seq_df_ggplot, aes(fill=shared_category, y=sv_shared_seq_ggplot, x=chr)) +
  geom_bar(position="stack", stat="identity") +
  xlab("Chromosome") +
  ylab("Length in bp") +
  labs(fill = "Groups") +
  ylim(NA, 41691073)
dev.off()
