# Emma Thomson 23/3/18 
# Script for running diamond on contig fasta files
# Make sure they end in .fa


# The database can be chaged as required to one of:
# nr.dmnd  refseq_protein_blastdbcmd.faa  ViralRefSeqProtein.dmnd   refseq_protein.dmnd 
# Obviously the bigger the database, the longer it will take to run.
# Don't run this on too many threads or you will lose friends (the p number)
# There is often no point in doing both R1 and R2 reads



for fa in *.fa; do
echo "Running raw diamond for " $fa
echo "This is running on 12 threads - reduce the input p value if others are online!!!"
diamond blastx -d /db/diamond/ViralRefSeqProtein -p 12 -q $fa -a $fa\_viruses.daa -k 1
done

for daa in *viruses.daa; do 
diamond view -a $daa -o $daa.m8 
done

for kt in *.m8; do
ktImportBLAST $kt -o $kt\_rawdiamond_krona.html
done 


