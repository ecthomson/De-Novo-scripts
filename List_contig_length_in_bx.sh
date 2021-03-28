#Sort out only the contigs 1000 in length or greater

#for LONG in *.fasta; do awk '!/^>/ { next } { getline seq } length(seq) >= 500 { print $0 "\n" seq }' $LONG > $LONG.1000long

#Create a log with the length of the contigs found
for cl in *bx/HUMAN/*/; do (cd $cl; awk 'BEGIN{FS="[> ]"} /^>/{val=$2;next}  {print val,"   ",length($0)}' blastx.fa >> human_contig_lengths); done
for cl in *bx/Animal/*/; do (cd $cl; awk 'BEGIN{FS="[> ]"} /^>/{val=$2;next}  {print val,"   ",length($0)}' blastx.fa >> animal_contig_lengths); done
for cl in *bx/Insect/*/; do (cd $cl; awk 'BEGIN{FS="[> ]"} /^>/{val=$2;next}  {print val,"   ",length($0)}' blastx.fa >> insect_contig_lengths); done
