# Metavic batch script Emma Thomson July 2017
# This will make a file of all fastq R1 and R2 fastq files in your folder and create a batch file to run the metavic_Cleaning script
# To run, type sh metavicbatchrun
# Before running, make sure that the number of R1 files is equal to the number of R2 ones
# Usage: Cleaning.sh file_R1.fastq file_R2.fastq OutputPrefix NumThreads 

rm -rf num1 num2 n1 n2 clean threads op fq1 fq2
ls *R1*fastq > fq1
less fq1| sed 's/R1/R2/g' > fq2
wc -l fq1 | cut -f1 -d " "> num1
wc -l fq2 | cut -f1 -d " "> num2
read n1 < num1
read n2 < num2

echo "R1 files " $n1 "R2 files " $n2
for i in `seq $n1`; do echo "metavic_Cleaning.sh " >>clean; done
for i in `seq $n1`; do echo "12 " >>threads; done
less fq1| sed 's/\.fastq//g'>>op 
paste clean fq1 fq2 op threads > metaviccleanrun.sh
echo "Batch run file created. Check that it looks ok before running!"
#less metavicbatchrun.sh
rm -rf num1 num2 n1 n2 clean threads op fq1 fq2

sh metaviccleanrun.sh

#Can also separate here into creating an assemble run

ls *clean_1.fastq > clean1
less clean1| sed 's/_1/_2/g' > clean2


wc -l clean1| cut -f1 -d " ">clnum1
wc -l clean2| cut -f1 -d " ">clnum2 
read cno1<clnum1 
read cno2<clnum2
echo "Clean R1 files" $cno1 "Clean R2 files" $cno2
for i in `seq $cno1`; do echo "metavic_Assemble.sh " >>assemble; done
for i in `seq $cno1`; do echo "12" >>threads; done
less clean1| sed 's/\.fastq//g' >>op
paste assemble clean1 clean2 op threads > metavicassemblerun.sh

sh metavicassemblerun.sh

rm -rf assemble threads op clean1 clean2 clnum1 clnum2


