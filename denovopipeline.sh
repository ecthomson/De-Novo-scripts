# De novo pipeline (spades and dipspades) Emma Thomson MRC CVR August 2016 
# Must have equal number of R1 and R2 files

#Step 1 - weeCleaner and weeMapper
echo "Unzipping...
"
gunzip *gz

echo "You are about to run the entire de novo pipeline. Make sure there is no junk in your folder - should be only fastq files (a sample xls sheet won't matter) but no directories and no extra files...Proceed otherwise at your own risk..."
echo "Preparing files for weeCleaner"
rm -Rf dn1 dn2 filenodn1 filenodn2 cleaner two a weecleanerrun.sh num1 num2 n1 n2 temp1 temp2 weemapperrun.sh cleanandmap.sh
ls *R1*fastq>>dn1
ls *R2*fastq>>dn2
wc -l dn1 > filenodn1
wc -l dn2 > filenodn2
read fdn1 <filenodn1
read fdn2 <filenodn2
cut -f1 -d " " filenodn1 > num1
cut -f1 -d " " filenodn2 > num2
read n1<num1
read n2<num2
echo "R1 files" $n1 "R2 files" $n2  
if num1=num2
then 
# Will only proceed if number of R1 files is equal to number of R2 files
	echo "Pipeline proceeding"
	for i in `seq $n1`; do echo "-2 ">>two; done
	for i in `seq $n1`; do echo "-a ">>a; done
	for i in `seq $n1`; do echo "weeCleaner -1 ">>cleaner; done
# weecleanerrun.sh will run weeCleaner only
	paste cleaner dn1 two dn2 a >>weecleanerrun.sh
# weemapperrun.sh will run weeMapper - files are adapted from weecleanerrun.sh
	less weecleanerrun.sh| sed -e 's/\.fastq/\_clean\.fq/g'>>temp1
	less temp1 | sed -e 's/\weeCleaner/weeMapper/g'>>temp2
	less temp2 | sed -e 's/\-a/-b -c/g'>>weemapperrun.sh
	cat num1 num2 temp1 temp2 two a cleaner weecleanerrun.sh weemapperrun.sh>>logfile_cleaner_mapper
# The logfile shows all the temp files
# The cleanandmap.sh file will run both cleaning and mapping
	cat weecleanerrun.sh weemapperrun.sh>> cleanandmap.sh 
	rm -Rf temp1 temp2 num1 num2 n1 n2 cleaner a dn1 dn2 filenodn1 filenodn2
# Clean and map file is displayed just to make sure it's ok!
#	echo "WeeCleaner and WeeMapper files created - please check them before running de novo assembly. You can run weecleanerrun.sh alone or combined with weemapper using cleanandmap.sh. "
#else
#echo "Error: Input R1 and R2 file number is not equal"; exit
#fi	
#echo "Warning: Do not proceed until you have checked clean and map files"
# Check that you want to proceed if setup is ok
#while true; do
#    read -p "Have you checked the cleanandmap.sh input file and do you wish to run cleaning and mapping? Please answer yes or no - type either y or n and return: " yn
#    case $yn in
#        [Yy]* ) sh cleanandmap.sh; break;;
#        [Nn]* ) exit;;
#        * ) echo "Please answer yes or no.";;
#    esac
#done
sh cleanandmap.sh
#Step 2 De novo setup and run
echo "Preparing files for de novo assembly. Stop if you didn't run weeCleaner and weeMapper first!"
# nohup sh cleanandmap.sh &
rm -Rf di op dip d1 d2 f1 f2 fn1 fn2 n1 n2
ls *unmapped_1.fq>>d1
ls *unmapped_2.fq>>d2
wc -l d1 > fn1
wc -l d2 > fn2
cut -f1 -d " " fn1 > fnum1
cut -f1 -d " " fn2 > fnum2
read n1<fnum1
read n2<fnum2
echo "Unmapped R1 files" $n1 "Unmapped R2 files" $n2  
if fnum1=fnum2
then 
echo "De novo assembly file being made"
less d1| cut -f 1 -d "_">>directory
for i in `seq $n1`; do echo "-o ">>op; done
for i in `seq $n1`; do echo "dipspades.py --careful -1 ">>dip; done
paste dip d1 two d2 op directory >>dipspades.sh
echo "De novo assembly has started - this may take some time..."
sh dipspades.sh
echo "Dipspades and spades assembly complete - check inside folders for contig information. Dipspades contigs are found in FOLDER/dipspades/consensus_contigs.fasta. Spades contigs are found in FOLDER/spades/scaffolds.fasta. You can run diamondsetup.sh now to carry out a blast search if you like - use this directory."
else
echo "Error: Input unmapped R1 and R2 file number is not equal - fix files in folder"; exit
fi
#Step 3: Blastx (diamond blastx)
clear
echo "Running diamond blastx"
echo "Preparing files for de novo assembly. Cut if you didn't run a de novo assembly with dipspades and spades first! Output files are called dipdiamondrun.sh and spdiamondrun.sh"
#Making name of output files based on directory names
rm -Rf daa* *daa_out temp* spdiamondrun.sh dipdiamondrun.sh diamond location a_out daa_temp db diamondrun.sh dirno directories temp1_dir dirno spdia*
ls */>>directories
#All this just sorts out the directory names so they can be used to label the files
less directories|sed -e 's/\///g'>>temp1_dir
less temp1_dir|sed -e 's/dipspades//g'>>temp2_dir
less temp2_dir|sed -e 's/spades//g'>>temp3_dir
less temp3_dir|sed -e 's/\://g'>>temp4_dir
#remove blank lines
sed '/^$/d' temp4_dir >> temp5_dir
read nmdir<temp5_dir
wc -l temp5_dir | cut -f1 -d " ">dirno
read dirn<dirno
for i in `seq $dirn`; do echo "diamond blastx -q ">>diamond; done
for i in `seq $dirn`; do echo "-a  ">>a_out; done
for i in `seq $dirn`; do echo "/dipspades/consensus_contigs.fasta">>location; done
for i in `seq $dirn`; do echo "-d /db/diamond/viruses_protein_all">>db; done 
for i in `seq $dirn`; do echo "-d /db/diamond/nr">>db_nr; done 
sed 's/$/\/dipspades\/consensus_contigs\.fasta/' temp5_dir >> dp_daa_out
sed 's/$/\/spades\/scaffolds\.fasta/' temp5_dir >> sp_daa_out
sed 's/$/\_dip_viruses/' temp5_dir >> daa_dip
sed 's/$/\_dip_nr/' temp5_dir >> daa_dip_nr
sed 's/$/\_sp_viruses/' temp5_dir >> daa_sp
sed 's/$/\_sp_nr/' temp5_dir >> daa_sp_nr
paste diamond dp_daa_out a_out daa_dip db >>dipdiamondrun.sh
paste diamond dp_daa_out a_out daa_dip_nr db_nr >>dipdiamondrun_nr.sh
paste diamond sp_daa_out a_out daa_sp db >>spdia_temp1
paste diamond sp_daa_out a_out daa_sp_nr db_nr >>spdia_temp1_nr
echo "for one in *scaffolds.fasta; do cat $one | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}'>>$one.one; done">spdia_temp2
cat spdia_temp1 spdia_temp2 >> spdiamondrun.sh
cat spdia_temp1_nr spdia_temp2 >> spdiamondrun_nr.sh
echo "Running diamond blastx (viruses) for dipspades files - this may take a while..."
sh dipdiamondrun.sh
echo "Running diamond blastx (viruses) for spades files - this may also take a while..." 
sh spdiamondrun.sh
echo "Blastx search complete. Commencing taxonomy labelling and tidying up. Time for a coffee."
mkdir Diamond_blastx Diamond_html Diamond_raw
#Create blast m8 tables
for dm in *.daa; do diamond view -a $dm -o $dm.m8; done
#Create html files
for kt in *.m8; do ktImportBLAST -c -i $kt -o $kt.html; done 
#Results directories
mv *m8 Diamond_blastx/
mv *html Diamond_html/
mv *daa Diamond_raw/
rm -Rf daa* *daa_out temp* diamond location a_out daa_temp db dirno directories dirno spdia*
echo "Running diamond blastx (nr) for dipspades files - this may take a while..."
sh dipdiamondrun_nr.sh
echo "Running diamond blastx (nr) for spades files - this may also take a while..."
sh spdiamondrun_nr.sh
echo "Blastx search complete. Commencing taxonomy labelling and tidying up. Time for a coffee."
#Create blast m8 tables
for dm in *.daa; do diamond view -a $dm -o $dm.m8; done
#Create html files
for kt in *.m8; do ktImportBLAST -c -i $kt -o $kt.html; done
#Results directories
mv *m8 Diamond_blastx/
mv *html Diamond_html/
mv *daa Diamond_raw/
rm -Rf daa* *daa_out temp* diamond location a_out daa_temp db dirno directories dirno spdia*

echo "Diamond blastx is complete. You can find the files you need in Diamond_blastx and Diamond_html. To visualise the html files, you can download directly to your computer or run sensible-browser <filename>"

