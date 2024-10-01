# Script for testing out info filtering about SV size in basepair from the PGGB called SVs. Adjusted script from the one in results folder 37

#vcf_file_names <- c("minigraph_cactus_community1_lt50bp_noheader_small.vcf", "minigraph_cactus_community2_lt50bp_noheader_small.vcf", "minigraph_cactus_community4_lt50bp_noheader_small.vcf")
vcf_file_number <- c(1,2,4:22)

species <- c("AstCal", "NeoMul", "PunNye")
sv_bp_df <- species

# Initialize vector to keep track of SV categories with
sv_categories_per_chr_colnames <- c("sequence_lost", "complete_deletions", "partial_deletions", "sequence_gained", "complete_insertions", "partial_insertions", "exact_substitutions")
sv_categories_per_chr <- sv_categories_per_chr_colnames
sv_bp_seq_df <- species

#First loop to go over all the indicated files
for(filename in vcf_file_number){
  #current_file_name <- 
  vcf_file <- read.delim(paste0("pggb_chr", filename, "_variants_lt50bp_noheader.vcf"), header=FALSE) #vcf_file_names[filename]
  # Adjust the column names
  col_names <- c('CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','AstCal','NeoMul','PunNye')
  colnames(vcf_file) <- col_names
  
  #Initialize counter for SV categories on the chromsome across all species
  chr_sv_counter_all_species <- c(rep(0, 7))
  
  # Initialize dataframes to keep track of SV categories per category per chromosome per specie
  sv_categories_per_chr_per_specie <- sv_categories_per_chr_colnames
  
  # Initialize variabel to append SV categories per species to
  chr_sv_counter_per_species <- sv_categories_per_chr_colnames
  current_chr_bp_count <- c()
  
  #Second loop go over the different species and filter them into files
  for(specie in 1:length(species)){
    #Determine which column to use to filter the species
    current_specie_idx <- 9 + specie # 1 = AstCal; 2 = NeoMul; 3 = PunNye; sum with 9 is the correct column in the current_specie_file
    # '0' and '.' indicate that the SV is not found on this assembly, therefore we take anything but this
    current_specie_file <- vcf_file[which(vcf_file[, current_specie_idx] != '0' & vcf_file[, current_specie_idx] != '.'),]
    
    # Capture the idxs of which SVs in $ALT belong to our species
    sv_alt_idxs <- current_specie_file[,current_specie_idx]
    #print(c(sv_alt_idxs))
    
    #Initialize vector to keep track of the SVs
    filtered_sv_vector <- c()
    #chr_sv_counter_per_species <- sv_categories_per_chr_colnames
    
    # Third loop over all SVs in $ALT to filter which SVs beling to our current species
    for(sv_location in 1:nrow(current_specie_file)){
      
      #split SVs of current row into a matrix to access it with index
      alt_svs <- matrix(unlist(strsplit(current_specie_file$ALT[sv_location], split=",")))
      #select the SV based on index extracted from our species column
      selected_specie_sv <- alt_svs[as.numeric(sv_alt_idxs[sv_location])]
      filtered_sv_vector <- append(filtered_sv_vector, selected_specie_sv)
    }
    #print(filtered_sv_vector[1:10])
    #print(length(filtered_sv_vector) == nrow(current_specie_file))
    
    # Append filtered SVs as new column
    current_specie_file <- cbind(current_specie_file, filtered_sv_vector)
    
    # initialize vector to save SV counts into 
    current_specie_chr_sv_counter <- c()
    
    # Split files into deletions and insertions (and substitutions?)
    # filter where the ref seq is longer than the filtered ALT seq
    current_specie_deletions <- current_specie_file[which(nchar(current_specie_file$REF) > nchar(current_specie_file$filtered_sv_vector)),]
    current_specie_complete_deletions <- current_specie_deletions[which(nchar(current_specie_deletions$filtered_sv_vector) == 1),]
    current_specie_partial_deletions <- current_specie_deletions[which(nchar(current_specie_deletions$filtered_sv_vector) > 1),]
    # filter where the ref seq is shorter than the filtered ALT seq
    current_specie_insertions <- current_specie_file[which(nchar(current_specie_file$REF) < nchar(current_specie_file$filtered_sv_vector)),]
    current_specie_complete_insertions <- current_specie_insertions[which(nchar(current_specie_insertions$REF) == 1),]
    current_specie_partial_insertions <- current_specie_insertions[which(nchar(current_specie_insertions$REF) > 1),]
    # Filter cases where they are the exact same length
    current_specie_exact_substitutions <- current_specie_file[which(nchar(current_specie_file$REF) == nchar(current_specie_file$filtered_sv_vector)),]
    
    #additional filter for <50bp variations
    current_specie_complete_deletions <- current_specie_complete_deletions[which(nchar(current_specie_complete_deletions$REF) >= 50),]
    current_specie_complete_insertions <- current_specie_complete_insertions[which(nchar(current_specie_complete_insertions$filtered_sv_vector) >= 50),]
    current_specie_partial_deletions <- current_specie_partial_deletions[which(nchar(current_specie_partial_deletions$REF) - nchar(current_specie_partial_deletions$filtered_sv_vector) >= 50),]
    current_specie_partial_insertions <- current_specie_partial_insertions[which(nchar(current_specie_partial_insertions$filtered_sv_vector) - nchar(current_specie_partial_insertions$REF) >= 50),]
    current_specie_exact_substitutions <- current_specie_exact_substitutions[which(nchar(current_specie_exact_substitutions$REF) >= 50),]
    true_subst_idxs <- c()
    for(sub in 1:nrow(current_specie_exact_substitutions)){
      truth_vector <- c()
      for(character in 1:nchar(current_specie_exact_substitutions$REF[sub])){
        is_character_equal <- matrix(unlist(strsplit(current_specie_exact_substitutions$REF[sub], split="")))[character] != matrix(unlist(strsplit(current_specie_exact_substitutions$filtered_sv_vector[sub], split="")))[character]
        truth_vector <- append(truth_vector, is_character_equal)
      }
      if(sum(truth_vector) >= 50){
        true_subst_idxs <- append(true_subst_idxs, sub)
      }
    }
    current_specie_exact_substitutions <- current_specie_exact_substitutions[true_subst_idxs,]
    
    # Counters for amount of each type of SV
    sequence_lost <- nrow(current_specie_deletions)
    complete_deletions <- nrow(current_specie_complete_deletions)
    partial_deletions <- nrow(current_specie_partial_deletions)
    
    sequence_gained <- nrow(current_specie_insertions)
    complete_insertions <- nrow(current_specie_complete_insertions)
    partial_insertions <- nrow(current_specie_partial_insertions)
    
    exact_substitutions <- nrow(current_specie_exact_substitutions)
    
    current_specie_chr_sv_counter <- c(sequence_lost, complete_deletions, partial_deletions, sequence_gained, complete_insertions, partial_insertions, exact_substitutions)
    #print(current_specie_chr_sv_counter)
    
    #count amount length of SVs in bp
    sv_seq_bp_complete_del <- sum(nchar(current_specie_complete_deletions$REF))
    sv_seq_bp_complete_ins <- sum(nchar(current_specie_complete_insertions$filtered_sv_vector))
    sv_seq_bp_exact_sub <- 0
    for(i in 1:nrow(current_specie_exact_substitutions)){
      sv_seq_bp_exact_sub = sv_seq_bp_exact_sub + length(unlist(setdiff(strsplit(current_specie_exact_substitutions$filtered_sv_vector[i], ""), strsplit(current_specie_exact_substitutions$REF[i], ""))))
    }
    sv_seq_bp_partial_del <- sum(nchar(current_specie_partial_deletions$REF)-nchar(current_specie_partial_deletions$filtered_sv_vector))
    sv_seq_bp_partial_ins <- sum(nchar(current_specie_partial_insertions$filtered_sv_vector)-nchar(current_specie_partial_insertions$REF))
    
    sv_seq_bp_total <- sv_seq_bp_complete_del + sv_seq_bp_complete_ins + sv_seq_bp_exact_sub + sv_seq_bp_partial_del + sv_seq_bp_partial_ins
    current_chr_bp_count <- append(current_chr_bp_count, sv_seq_bp_total)

    # Append data to the corresponding specie file as a new line
    #write.table(current_specie_chr_sv_counter, paste0("sv_category_count_per_chr", species[specie], ".txt"), append = TRUE)
    
    # Update the counter for the SVs across all species per chr
    chr_sv_counter_all_species <- chr_sv_counter_all_species + current_specie_chr_sv_counter
    
    print(current_specie_chr_sv_counter)
    
    # Append count to chr file with rows for species
    chr_sv_counter_per_species <- rbind(chr_sv_counter_per_species, current_specie_chr_sv_counter)
  }
  sv_categories_per_chr <- rbind(sv_categories_per_chr, chr_sv_counter_all_species)
  sv_bp_seq_df <- rbind(sv_bp_seq_df, current_chr_bp_count)

  # Edit sv per category per chromosome per species before writing to file
  chr_sv_counter_per_species <- chr_sv_counter_per_species[2:nrow(chr_sv_counter_per_species),]
  row.names(chr_sv_counter_per_species) <- species
  colnames(chr_sv_counter_per_species) <- sv_categories_per_chr_colnames
  
  write.table(chr_sv_counter_per_species, paste0("chr_sv_counter_per_species_chr", filename, ".txt"), sep=" ")
}

#Edit format of sv over all species per chromosome before writing to file
sv_categories_per_chr <- sv_categories_per_chr[2:nrow(sv_categories_per_chr),]
colnames(sv_categories_per_chr) <- sv_categories_per_chr_colnames
rownames(sv_categories_per_chr) <- vcf_file_number
write.table(sv_categories_per_chr, "sv_category_count_per_chr.txt", sep=" ")


# Create SVs per category per specie over all chromosomes
for(specie in 1:length(species)){
  current_specie <- species[specie]
  # initialize var to build df in
  specie_sv_per_category_per_chr <- sv_categories_per_chr_colnames
  for(file in vcf_file_number){
    current_chr_file <- read.table(paste0("chr_sv_counter_per_species_chr", file, ".txt"), sep=" ", header = TRUE)
    specie_sv_per_category_per_chr <- rbind(specie_sv_per_category_per_chr, current_chr_file[specie,])
    #print(current_chr_file[specie,])
  }
  #print(specie_sv_per_category_per_chr)
  specie_sv_per_category_per_chr <- specie_sv_per_category_per_chr[2:nrow(specie_sv_per_category_per_chr),]
  rownames(specie_sv_per_category_per_chr) <- vcf_file_number
  write.table(specie_sv_per_category_per_chr, paste0(current_specie, "_sv_per_category_per_chr.txt"), sep=" ")
}

# Edit and write SV sequence length in basepair to file
sv_bp_seq_df <- sv_bp_seq_df[2:nrow(sv_bp_seq_df),]
colnames(sv_bp_seq_df) <- species
rownames(sv_bp_seq_df) <- vcf_file_number
write.table(sv_bp_seq_df, "sv_bp_seq_table.txt", sep=" ")

# Make proportion of SV file
chrom_len_df <- read.table('chrom_len_df.txt', sep = " ")
ac_chrom_lengths <- chrom_len_df[c(1,2,4:22),]
nm_chrom_lengths <- chrom_len_df[c(23,24,26:44),]
pn_chrom_lengths <- chrom_len_df[c(67,68,70:88),]

ac_prop <- as.numeric(sv_bp_seq_df[,1]) / as.numeric(ac_chrom_lengths)
nm_prop <- as.numeric(sv_bp_seq_df[,2]) / as.numeric(nm_chrom_lengths)
pn_prop <- as.numeric(sv_bp_seq_df[,3]) / as.numeric(pn_chrom_lengths)
prop_df <- cbind(ac_prop, nm_prop, pn_prop)
rownames(prop_df) <- vcf_file_number
write.table(prop_df, "sv_prop_df.txt", sep=" ")

