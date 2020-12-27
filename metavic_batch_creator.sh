# Metavic batch script Emma Thomson July 2017
# This will make a file of all fastq R1 and R2 fastq files in your folder and create a batch file to run the metavic_Cleaning script
# To run, type sh metavicbatchrun
# Before running, make sure that the number of R1 files is equal to the number of R2 ones
# Usage: metavic_Cleaning.sh file_R1.fastq file_R2.fastq OutputPrefix NumThreads 

rm -rf num1 num2 n1 n2 clean threads op fq1 fq2
ls *R1*fastq.gz | sed 's/\.gz//g'> fq1
less fq1 | sed 's/R1/R2/g' > fq2
gunzip *.gz
wc -l fq1 | cut -f1 -d " "> num1
wc -l fq2 | cut -f1 -d " "> num2
read n1 < num1
read n2 < num2

echo "R1 files " $n1 "R2 files " $n2
for i in `seq $n1`; do echo "metavic_Cleaning.sh " >>clean; done
for i in `seq $n1`; do echo "12 " >>threads; done
less fq1| sed 's/\.fastq//g'>op
paste clean fq1 fq2 op threads > metavicbatchrun.sh

rm -rf num1 num2 n1 n2 clean threads op fq1 fq2
echo "Batch file created. Check that the number of R1 files equals the number of R2 files before running. To run type sh metavicbatchrun.sh"


