# Measure evolutionary distance by counting inversions

# Strategy:
# Order per chromosome by bp_start_1 position
# Loop over orientation column
# add a counter that counts when the orientations changes
# currently do not care about length of inversion only about their count
# Does not matter how short or long the inversion is

# Official tree: (close to far relation)
# AstCal -> PunNye -> NeoMul -> OreNil


    #Load dataset: output .paf file from alignment-only updated PGGB

# Set working directory
setwd('C:/Users/laura/OneDrive/Documenten/Bern/Universiteit/FS2024/Master thesis/pggb_updated_alignment')

raw_alignment <- read.delim('fTotalCichlids.fa.bf3285f.alignments.wfmash_5krecon.paf', header=F)
# V1 = Sequence match 1
# V2 = Chromosome length of match 1
# V3 = bp position on chromosome where match started
# V4 = bp position on chromosome where match ended
# V5 = Orientation of mapping, +/-, inversion
# V6 = Sequence match 2
# V7 = Chromosome length of match 2
# V8 = bp position on chromosome where match started
# V9 = bp position on chromosome where match ended
# V10 = Matched sequence length without gaps
# V11 = Matched sequence length based on bp start and end of match 2, with gaps 
# V12 = (?) Depth of match 
# V13-V20 = IDs & quality scores ??


    # Duplicate & inverse duplicate dataset to make analysis easier

#Divide the dataset into parts
left_data <- raw_alignment[,1:4]
right_data <- raw_alignment[,6:9]
orientation_data <- raw_alignment[,5]
quality_etc_data <- raw_alignment[,10:20]

#Rearrange and merge
rev_data <- cbind(right_data, orientation_data, left_data, quality_etc_data)
colnames(rev_data) <- colnames(raw_alignment)
merge_data <- rbind(raw_alignment, rev_data)

#add astcal seq len column
astcal_seqlen <- merge_data$V4-merge_data$V3
left_data <- merge_data[,1:4]
right_data <- merge_data[,5:20]
merge_data <- cbind(left_data, astcal_seqlen, right_data)

#Name columns
colnames(merge_data) <- c('chrom_match_1', 'chrom_len_1', 'bp_start_1', 'bp_end_1', 'astcal_seqlen', 'orientation', 'chrom_match_2', 'chrom_len_2', 'bp_start_2', 'bp_end_2', '?_seq len wogaps', 'seq_len_wgaps', '?depth', 'unknown1', 'unknown2', 'unknown3', 'unknown4', 'unknown5', 'unknown6', 'unknown7', 'unknown8')

#######################################################################################
# Flexible version that should work for the user specified species

#################################
                                # Enter preferred reference species here
reference <- "OreNil"           # Legal choices: AstCal, NeoMul, PunNye, OreNil
                                #
#################################


  # Functions

#function to extract the data of the above defined reference species
get_reference_data <- function(all_data, species){
  reference_pos <- grep(species, all_data$`chrom_match_1`)
  reference_data <- all_data[reference_pos,]
}

#function to filter out current AstCal chromosome
filter_data <- function(data_set, chrom_label){
  
  #Use to filter for a specific astcal chromosome from the astcal_data'
  filtered_data <- data_set[grep(chrom_label, data_set$`chrom_match_1`),]
  
  return(filtered_data)
}

#function to filter the species
filter_species <- function(data_set, specie_label){
  #print(specie_label)
  #Use to filter for a specific astcal chromosome from the astcal_data'
  filtered_data <- data_set[grep(specie_label, data_set$`chrom_match_2`),]
  
  return(filtered_data)
}

#function to count the amount of orientation changes
count_orientations <- function(species_data){
  
  #Order the data according to bp_start1
  ordered_data <- species_data[order(species_data$bp_start_1),]
  #get the orientation column
  orientation_info <- ordered_data$orientation
  #print(orientation_info)
  #get the starting orientation
  current_orientation <- orientation_info[1]
  
  total_changes <- 0
  
  #loop over the orientation column to count the changes
  for(i in 1:length(orientation_info)){
    if(orientation_info[i] != current_orientation){
      current_orientation <- orientation_info[i]
      total_changes <- total_changes + 1
    }
  }
  
  return(total_changes)
}

#function to determine the chromosome with most matches, the 'true' match
find_match <- function(current_data, current_species){
  
  #Find the matching chromosome on the other accession by making a frequency table
  #of the matches sequences. Return the accession chromosome label with the highest
  #reported frequency as the label to use to filter true match alignments
  astcal_to_species_data <- current_data[grep(current_species, current_data$`chrom_match_2`),]
  
  align_freq <- as.data.frame(table(astcal_to_species_data$`chrom_match_2`))
  high_score <- max(align_freq$Freq)
  true_match <- as.character(align_freq[which(align_freq$Freq==high_score),1])
  
  return(true_match)
}

#function to make a match table for each chromosome
make_match_table <- function(ref_data, species_list){
  #determine labels to loop over
  ref_chrom_labels <- as.data.frame(table(ref_data$chrom_match_1))[,1]
  
  #initialize empty table
  match_table <- c('Col1','Col2', 'Col3', 'Col4')
  
  for(i in 1:length(ref_chrom_labels)){
    #Filter dataset for current astcal chromosome
    current_label <- as.character(ref_chrom_labels[i])
    #current_ref_chrom_data <- filter_data(ref_data, current_label) # make which to avoid chr 1 & chr 10 confusion
    current_ref_chrom_data <- ref_data[which(ref_data[,1] == current_label),]
    # start new row to append to match_table
    new_row <- c(current_label)
    for(j in 1:length(species_list)){
      # for the current astcal chromosome find out which match is the most likely
      current_species <- species_list[j]
      chrom_match <- find_match(current_ref_chrom_data, current_species)
      # add the match to the new row vector
      new_row <- append(new_row, chrom_match)
    }
    match_table <- rbind(match_table, new_row)
  }
  column_names <- append(matrix(unlist(strsplit(current_label, '#')))[1], as.vector(species_list))
  match_table <- as.data.frame(match_table)[2:length(match_table[,1]),]
  colnames(match_table) <- column_names
  match_table <- match_table[order(match_table$NeoMul),]
  rownames(match_table) <- paste0(c('chr'), 1:22)
  return(match_table)
}


  # Code

#extract the data and chromosome labels of the specified reference species
reference_data <- get_reference_data(merge_data, reference)
ref_chrom_labels <- as.data.frame(table(reference_data$chrom_match_1))[,1]

#Get the species we compare the current reference species to
#Make function?
species <- as.data.frame(table(matrix(unlist(strsplit(reference_data$chrom_match_2, split='#')), ncol=3, byrow=T)[,1]))[,1]

#make a match table to easily retrieve which chromosomes are matched to each other
ref_matches <- make_match_table(reference_data, species)

#initialize data frame to store changes in
changes_table <- as.vector(species)

#count the amount of orientation changes per chromosome per species
# Outer loop: go over the AstCal chromosomes
for(i in 1:length(ref_chrom_labels)){
  current_chromosome <- as.character(ref_chrom_labels[i])
  #current_chromosome_data <- filter_data(reference_data, current_chromosome) # make which to avoid chr 1 & chr 10 confusion
  current_chromosome_data <- reference_data[which(reference_data$chrom_match_1 == current_chromosome),]
  new_row <- c()
  #print(current_chromosome_data[1:10,1:10])
  # Inner loop: go over the 3 species and count the orientation changes
  for(j in 1:length(species)){
    #current_specie <- ref_matches[grep(ref_chrom_labels[i], ref_matches[,1]),j+1] # make which to avoid chr 1 & chr 10 confusion
    current_specie <- ref_matches[which(ref_matches[,1] == ref_chrom_labels[i]),j+1]
    #current_species_data <- filter_species(current_chromosome_data, current_specie) # make which to avoid chr 1 & chr 10 confusion
    current_species_data <- current_chromosome_data[which(current_chromosome_data$chrom_match_2 == current_specie),]
    #print(table(current_species_data$chrom_match_2))
    changes <- count_orientations(current_species_data)
    new_row <- append(new_row, changes)
  }
  changes_table <- rbind(changes_table, new_row)
}

#Give row and column names
changes_table <- changes_table[2:nrow(changes_table),]
rownames(changes_table) <- ref_chrom_labels
colnames(changes_table) <- species

#reorder the table according to proper chromosome labels (it is ordered according to given label, which is often wrong)
#if(reference != 'NeoMul'){
#  unordered <- cbind(ref_matches[,1], ref_matches$NeoMul)
#  ordered <- unordered[order(unordered[,1]),]
#  changes_table <- cbind(ordered[,2], changes_table)
#  changes_table <- changes_table[order(changes_table[,1]),]
#  changes_table <- changes_table[,2:ncol(changes_table)]
#}

#rownames(changes_table) <- paste0(reference, '#chr', 1:22)
print(changes_table)
# Write tabel to txt
write.table(changes_table, "orientation_changes_table.txt", sep="\t")

#make a table of summary statistics
summary_stats <- c('Min.', '1st Qu.', 'Median', 'Mean', '3rd Qu.', 'Max.')
for(i in 1: length(species)){
  new_row <- as.vector(summary(as.numeric(changes_table[,i])))
  summary_stats <- rbind(summary_stats, new_row)
}
summary_stats <- summary_stats[2:nrow(summary_stats),]
rownames(summary_stats) <- as.vector(species)
colnames(summary_stats) <- c('Min.', '1st Qu.', 'Median', 'Mean', '3rd Qu.', 'Max.')
print(summary_stats)

#make a table of cumulative changes per species
sum_table <- as.vector(species)
sum_row <- c()
for(i in 1:length(species)){
  col_sum <- sum(as.numeric(changes_table[,i]))
  sum_row <- append(sum_row, col_sum)
}
sum_table <- rbind(sum_table, sum_row)
rownames(sum_table) <- c('species', 'sum changes')
colnames(sum_table) <- as.vector(species)
sum_table <- sum_table[2: nrow(sum_table),]
print(sum_table)


