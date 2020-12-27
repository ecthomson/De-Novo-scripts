# Emma Thomson 23/3/18 
# Script for running diamond on cleaned but raw fq files

# List files to be run
#ls *R1*clean*.fq >r1clean
#sed 's/R1/R2/g' r1 > r2clean
#paste r1clean r2clean > diamondlist


# The database can be chaged as required to one of:
# nr.dmnd  refseq_protein_blastdbcmd.faa  ViralRefSeqProtein.dmnd   refseq_protein.dmnd 
# Obviously the bigger the database, the longer it will take to run.
# Don't run this on too many threads or you will lose friends.
# There is often no point in doing both R1 and R2 reads



for cleanfq in *R1*.fastq; do
echo "Running raw diamond for " $cleanfq 
#Adjust number of threads with the p value
diamond blastx -d /db/diamond2/ViralRefSeqProtein -p 8 -q $cleanfq -a $cleanfq\_viruses.daa -k 1
done

for daa in *viruses.daa; do 
diamond view -a $daa -o $daa.m8 
done

for kt in *.m8; do
ktImportBLAST $kt -o $kt\_rawdiamond_krona.html
done 


