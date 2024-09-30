#!/bin/bash


# Read file 1

ALIGN_FILE=../results/26_minigraph_short_reads/reads_1/minigraph_shortread_mapping_1.gaf
STATS_FILE=../results/26_minigraph_short_reads/reads_1/minigraph_shortread_mapping_1_stats.txt
SEQ_READS_FILE=/lustre/scratch123/tol/projects/cichlid/ldekker/data/sequencing_reads/short_reads_A1-108416_R1_001

# Total reads
echo 'Total reads in fastq file:' > $STATS_FILE
TOTAL_READS=`zcat $SEQ_READS_FILE | wc -l`
echo $TOTAL_READS / 4 | bc >> $STATS_FILE

# Total aligned reads
echo 'Total aligned reads:' >> $STATS_FILE
LINES_NR=`wc -l < $ALIGN_FILE`
echo $LINES_NR >> $STATS_FILE

# Percentage aligned
echo 'Percentage of reads aligned to graph:' >> $STATS_FILE
#LINES_NR=`wc -l < $ALIGN_FILE`
#echo "$((LINES_NR))" / "$((TOTAL_READS))" | bc >> "$STATS_FILE"
#echo $TOTAL_READS >> $STATS_FILE
#awk '{  print lines/reads }' lines="${LINES_NR}" reads="${TOTAL_READS}" >> $STATS_FILE
awk -v lines="$LINES_NR" -v reads="$TOTAL_READS" 'BEGIN { print lines / (reads / 4) }' >> $STATS_FILE

# Sum the quality scores of GAF minigraph alignment
echo 'Average alignment quality score (0-255), lower is better:' >> $STATS_FILE
#LINES_NR=`wc -l $ALIGN_FILE`
awk '{ sum+=$12 } END { print sum/a }' a="${LINES_NR}" $ALIGN_FILE >> $STATS_FILE

# Take the average of the coverage
#COL_DIF=$(awk '{ result = ($4 - $3) / $2 } END { print result }' "../results/26_minigraph_short_reads/reads_1/minigraph_shortread_mapping_1.gaf")
echo 'Average coverage per read, higher is better: ' >> $STATS_FILE
awk '{ result = ($4 - $3) / $2 } { sum += result } { count ++ } END { print sum/count }' $ALIGN_FILE >> $STATS_FILE


# Read file 2

ALIGN_FILE=../results/26_minigraph_short_reads/reads_2/minigraph_shortread_mapping_2.gaf
STATS_FILE=../results/26_minigraph_short_reads/reads_2/minigraph_shortread_mapping_2_stats.txt
SEQ_READS_FILE=/lustre/scratch123/tol/projects/cichlid/ldekker/data/sequencing_reads/short_reads_A1-108416_R2_001

# Total reads
echo 'Total reads in fastq file:' > $STATS_FILE
TOTAL_READS=`zcat $SEQ_READS_FILE | wc -l`
echo $TOTAL_READS / 4 | bc >> $STATS_FILE

# Total aligned reads
echo 'Total aligned reads:' >> $STATS_FILE
LINES_NR=`wc -l < $ALIGN_FILE`
echo $LINES_NR >> $STATS_FILE

# Percentage aligned
echo 'Percentage of reads aligned to graph:' >> $STATS_FILE
#LINES_NR=`wc -l < $ALIGN_FILE`
#echo "$((LINES_NR))" / "$((TOTAL_READS))" | bc >> "$STATS_FILE"
#echo $TOTAL_READS >> $STATS_FILE
#awk '{  print lines/reads }' lines="${LINES_NR}" reads="${TOTAL_READS}" >> $STATS_FILE
awk -v lines="$LINES_NR" -v reads="$TOTAL_READS" 'BEGIN { print lines / (reads / 4) }' >> $STATS_FILE

# Sum the quality scores of GAF minigraph alignment
echo 'Average alignment quality score (0-255), lower is better:' >> $STATS_FILE
awk '{ sum+=$12 } END { print sum/a }' a="${LINES_NR}" $ALIGN_FILE >> $STATS_FILE

# Take the average of the coverage
echo 'Average coverage per read, higher is better: ' >> $STATS_FILE
#LINES_NR=`wc -l $ALIGN_FILE`
awk '{ result = ($4 - $3) / $2 } { sum += result } { count ++ } END { print sum/count }' $ALIGN_FILE >> $STATS_FILE






# sum the quality scores of GAF minigraph alignment echo 'Average alignment quality score (0-255), lower is better:' > 
#$STATS_FILE LINES_NR=`wc -l $ALIGN_FILE` awk '{ sum+=$12 } END { print sum/a }' a="${LINES_NR}" $ALIGN_FILE >> $STATS_FILE

# Take the average of the coverage COL_DIF=$(awk '{ result = ($4 - $3) / $2 } END { print result }' 
#"../results/26_minigraph_short_reads/reads_1/minigraph_shortread_m>echo 'Average coverage per read, higher is better: ' >> 
#$STATS_FILE awk '{ result = ($4 - $3) / $2 } { sum += result } { count ++ } END { print sum/count }' $ALIGN_FILE >> 
#$STATS_FILE
