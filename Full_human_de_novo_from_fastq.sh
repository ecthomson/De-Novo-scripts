# Full de novo assembly including blastx and blastn of human viruses
# Emma Thomson December 2019

# Uses updated Metavic batch script Emma Thomson July 2017
# This will make a file of all fastq R1 and R2 fastq files in your folder and create a batch file to run the metavic_Cleaning script
# To run, type sh metavicbatchrun
# Before running, make sure that the number of R1 files is equal to the number of R2 ones
# Usage: Cleaning.sh file_R1.fastq file_R2.fastq OutputPrefix NumThreads 

#gunzip *gz
rm -rf num1 num2 n1 n2 clean threads op fq1 fq2
ls *R1*fastq > fq1
less fq1| sed 's/R1/R2/g' > fq2
wc -l fq1 | cut -f1 -d " "> num1
wc -l fq2 | cut -f1 -d " "> num2
read n1 < num1
read n2 < num2

echo "R1 files " $n1 "R2 files " $n2
for i in `seq $n1`; do echo "sh /home2/HCV2/Uganda/Scripts/metavic_Cleaning.sh " >>clean; done
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
for i in `seq $cno1`; do echo "sh /home2/HCV2/Uganda/Scripts/metavic_Assemble.sh " >>assemble; done
for i in `seq $cno1`; do echo "12" >>threads; done
less clean1| sed 's/\.fastq//g' >>op
paste assemble clean1 clean2 op threads > metavicassemblerun.sh

sh metavicassemblerun.sh

rm -rf assemble threads op clean1 clean2 clnum1 clnum2
rm -rf *_prinseq_* *nonrrna* *_unmapped_1.fq *unmapped_2.fq


chmod 777 *
#Full html_reader script
#Emma Thomson 17/11/19
#This script pulls out all the contigs for every virus in the html_op file, puts these into a folder, searches for the relevant sequences and then runs blastn on all of them

#1 All the contig html files are selected to make a directory based on the name of the file with a "_" delimiter
rm -rf html_list*

#All the garm contig html files are selected to make a directory based on the name of the file with a "_" delimiter
for garm in *garm*.html; do ls $garm | cut -f 1 -d "_">>html_list_1; done
while read dir; do mkdir $dir\_bx; done < html_list_1

#The html files are moved into the new folders
while read html; do cp $html*krona.html "$html"*bx/; done < html_list_1

#Move sequence blastn reader into all folders
for d in *_bx/; do cp /home2/HCV2/Uganda/Scripts/html_reader_2B_ET.sh "$d"; done


#2 This script makes a text output file from the htmls


for d in *_bx/; do cp /home2/HCV2/Uganda/Scripts/html_reader_3B_ET.sh "$d"; done
for d in *_bx/; do cp /home2/HCV2/Uganda/Scripts/html_reader_4_ET.sh "$d"; done

for h3 in *bx/; do (cd $h3; sh html_reader_2B_ET.sh); done
for h3 in *bx/; do (cd $h3; sh html_reader_3B_ET.sh); done
##html reader script 3 as below
#Copy in html_reader_4 script
#This script puts all the contigs into a folder of (almost) the same name (minus the _bx_contigs bit) then pulls in the right fasta files from outside and finally exports the html_reader_get_seq_5.sh file into all subdirectories
#The script contents follow below

for h4 in *bx/; do (cd $h4; sh html_reader_4_ET.sh); done


echo "HTML reader has completed. You will find a blastn_runner.sh script inside each virus folder. If you want to run a blastn in that folder, navigate inside and then type sh html_reader_blastn.sh. It takes a few minutes to run, so be patient..."


#Human html_reader blastn script
#Emma Thomson 17/11/19
#This script runs the human blastn script html_reader_5 in all the virus folders within Human/

##WARNING - take care! This script will run all Human/virus files!!!

#Copy in html_reader_5 script into the *bx/ folders
cp /home2/HCV2/Uganda/Scripts/htmlreadersuite/html_reader_5_ET.sh *bx/Human/*/

#The script contents follow below
for h5 in *bx/Human/*/; do (cd $h5; sh html_reader_5_ET.sh; chmod 777 *); done


