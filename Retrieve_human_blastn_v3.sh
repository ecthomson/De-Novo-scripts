#This will pull out the relevant blastn results for human reads from 
#the human AVI samples- mosquito version doesn't work - don't know why
#Emma Thomson 26th August 2020

rm -rf len1 per1 sample1 accession1 blastn1 blastx1 All_human_blastn Blastn_human_results
grep -A 6 "Length=" *_bx/HUMAN/*/blastn_summary | grep -v "Score" | grep -v "Bits"|cat -s >>All_human_blastn
grep -A 6 "Length=" *_bx/Human/*/blastn_summary | grep -v "Score" | grep -v "Bits"|cat -s >>All_human_blastn

for bx in *_bx/HUMAN/*/; do cp /home2/HCV2/Uganda/Scripts/blast_op_gen.sh $bx; done

less All_human_blastn | cut -f 1 -d "/" >name_blast_res
less All_human_blastn | cut -f 2 -d ">" > blastn_res
less All_human_blastn | cut -f 3 -d "/" > blastx_res

paste name_blast_res blastx_res blastn_res > blastn_blastx_table

#Retrieve only viruses from the blastn
cat blastn_blastx_table | awk 'BEGIN { FS = "\t" } ; {if ($3 ~ "virus") print $1 "  "$2 "  " $3 "  " $4}'> blastn_blastx_table_viruses
cat blastn_blastx_table | awk 'BEGIN { FS = "\t" } ; {if ($3 ~ "No significant") print $1 "  "$2 "  " $3 "  " $4}'> blastn_blastx_table_novel

#rm -rf len1 per1 sample1 accession1 blastn1 blastx1
echo "Blastn retrieval complete - check blastn_blastx_table_viruses and _novel  for data"
