exec < $1
while read id
    do
     wget -O $id https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore\&id=$id\&rettype=fasta\&retmode=text
    done
