# File to compute and plot the total count of SV categories

library(ggplot2)

# initialize variables
species <- c("AstCal", "NeoMul", "PunNye")

vcf_file_number <- c(1,2, 4:22)

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

# loop over dev files
for(i in vcf_file_number){
  
  # Load file
  #i <- 1
  current_vcf_file <- read.delim(paste0("/lustre/scratch123/tol/projects/cichlid/ldekker/results/43_pggb_sv_analysis_R/vcf_files/pggb_chr", i, "_variants_lt50bp_noheader.vcf"),header = FALSE)
  col_names <- c('CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','AstCal','NeoMul','PunNye')
  colnames(current_vcf_file) <- col_names
  
  #Go over lines of file
  for(j in 1:nrow(current_vcf_file)){
    current_ref <- current_vcf_file$REF[j]
    length_current_ref <- nchar(current_ref)
    current_variants <- matrix(unlist(strsplit(current_vcf_file$ALT[j], split=",")))
    #10=AC, 11=NM, 12=PN
    variant_presence <- current_vcf_file[j, 10:12]
    #print(paste0("current ref seq: ", current_ref))
    #print(paste0("current variant seq: ", length(current_variants)))
    #print(paste0("current variant presence: ", length(variant_presence)))
    # Determine the amount of SVs present at this location
    amount_variants <- length(current_variants)
    #total_sv_count <- total_sv_count + amount_variants
    
    for(k in 1:length(amount_variants)){
      # test which species have the current SV present
      #presence_vector <- variant_presence == k
      #sv_presence <- rbind(sv_presence, presence_vector)
      
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
        total_sv_length_bp <- total_sv_length_bp + length_diff
      }
    }
  }
}

#print(paste0("complete deletions: ", complete_deletion_count))
#print(paste0("complete deletions length: ", complete_deletion_length_bp))
#print(paste0("complete insertions: ", complete_insertion_count))
#print(paste0("complete insertion length: ", complete_insertion_length_bp))

#print(paste0("partial deletions: ", partial_deletion_count))
#print(paste0("partial deletions length: ", partial_deletion_length_bp))
#print(paste0("partial insertions: ", partial_insertion_count))
#print(paste0("partial insertion length: ", partial_insertion_length_bp))

#print(paste0("exact substitutions: ", exact_substitution_count))
#print(paste0("exact substitutions length: ", exact_substitution_length_bp))

#print(paste0("total SVs: ", total_sv_count))
#print(paste0("total SVs length: ", total_sv_length_bp))

#print(paste0("summed count subcategories: ", complete_deletion_count + complete_insertion_count + partial_deletion_count + partial_insertion_count + exact_substitution_count))
#print(paste0("summed length subcategories: ", complete_deletion_length_bp + complete_insertion_length_bp + partial_deletion_length_bp + partial_insertion_length_bp + exact_substitution_length_bp))

# Write sv counts and lengths to table
table_count_colnames <- c("total SVs", "complete deletions", "partial deletions", "complete insertions", "partial insertions", "exact substitutions")
counts <- c(total_sv_count, complete_deletion_count, partial_deletion_count, complete_insertion_count, partial_insertion_count, exact_substitution_count)
lengths_bp <- c(total_sv_length_bp, complete_deletion_length_bp, partial_deletion_length_bp, complete_insertion_length_bp, partial_insertion_length_bp, exact_substitution_length_bp)
sv_info_table <- rbind(table_count_colnames, counts, lengths_bp)
sv_info_table <- sv_info_table[2:nrow(sv_info_table),]
colnames(sv_info_table) <- table_count_colnames
write.table(sv_info_table, "total_sv_counts_lengths.txt", sep=" ")


# Make info in ggplot format and plot to png

#Counts
type_sv <- c("Insertion", "Insertion", "Deletion", "Deletion", "Substitution")
subtype_sv <- c("Complete", "Partial", "Complete", "Partial", "Substitution")
ggplot_counts <- c(complete_insertion_count, partial_insertion_count, complete_deletion_count, partial_deletion_count, exact_substitution_count)
count_df <- data.frame(type_sv, subtype_sv, ggplot_counts)
write.table(count_df, "total_sv_counts_ggplot.txt", sep=" ")

png("total_sv_counts_ggplot.png")
ggplot(count_df, aes(fill=subtype_sv, y=ggplot_counts, x=type_sv)) +
  geom_bar(position="stack", stat="identity") +
  xlab("SV type") +
  ylab("Frequency") +
  labs(fill = "SV subtype")
dev.off()

# length in bp
ggplot_length_bp <- c(complete_insertion_length_bp, partial_insertion_length_bp, complete_deletion_length_bp, partial_deletion_length_bp, exact_substitution_length_bp)
length_bp_df <- data.frame(type_sv, subtype_sv, ggplot_length_bp)
write.table(length_bp_df, "total_sv_length_bp_ggplot.txt", sep=" ")

png("total_sv_length_bp_ggplot.png")
ggplot(length_bp_df, aes(fill=subtype_sv, y=ggplot_length_bp, x=type_sv)) +
  geom_bar(position="stack", stat="identity") +
  xlab("SV type") +
  ylab("Length in bp") +
  labs(fill = "SV subtype")
dev.off()

