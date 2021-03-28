#Wee script to pull out top Animal hits from blastx 
head -4  *bx/Animal/*/blastn_summary | grep -v "<p>" | grep -v "<PRE>" | grep -v "Mos" | sort | uniq | sed 's/>//g' | grep "virus" | cut -f 1 -d " " | sort | uniq > animal_pathogen_accession_list

head -4  *bx/Animal/*/blastn_summary | grep -v "<p>" | grep -v "<PRE>" | grep -v "Mos" | sort | uniq | sed 's/>//g' | grep "virus" | cut -f 1,2,3,4,5 -d " " | sort | uniq > animal_pathogen_names_and_accessions_list

