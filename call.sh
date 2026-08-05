#!/usr/bin/env bash
# Running beagle for genotype calling, imputation, and phasing
# Running beagle for genotype calling, imputation, and phasing

echo
echo "***Running genotype calling***"
echo

# Directory for holding large amounts of data
DATA="/space/s1/eccortes/frogs"
# Directory for scripts and final outputs
WORKING="/home/eccortes/Frog_ARGs"

# Using parallel for faster run times
# Using niterations=0 to avoid using 4.1 phasing algo
# Using 11 threads is good enough and increasing will slow down performance

parallel -j 12 -a ./input_text/scaffolds.txt \
"java -Xss5m -Xmx80g -jar ~/local/beagle.4.1.jar \
gl=$DATA/working/var_sites.vcf.gz \
out=$DATA/beagle_41_out/called.{}.gt \
chrom={} \
niterations=0 \
gprobs=true \
impute=false \
nthreads=11"

echo
echo "Merging files back into one"
echo

cd $DATA/beagle_41_out/
ls | grep .vcf.gz > ~/Frog_ARGs/scripts/input_text/called_files.txt

parallel -j 12 -a ~/Frog_ARGs/scripts/input_text/called_files.txt bcftools index {}

bcftools concat --file-list ~/Frog_ARGs/scripts/input_text/called_files.txt -Oz \
"-o /home/eccortes/Frog_ARGs/beagle_out/called.gt.vcf.gz"

cd ~/Frog_ARGs/scripts

# Phase output from 4.1
echo
echo "***Running Beagle 5.5 for phasing***"
echo

INPUT="~/Frog_ARGs/beagle_out/called.gt.vcf.gz"

# Reminder: pay attention to how long it takes to run: if not bad, may want to update burnin and iterations paramters for 
# better accuracy


parallel -j 12 -a scaffolds.txt "java -Xmx60g -jar ~/local/beagle.5.5.jar \
gt=$INPUT \
out=$DATA/beagle_55_out/phase.{}.gt \
chrom={} \
nthreads=11"

# Merge files back together
echo
echo "***Merging Files back together***"
echo

cd ~/Frog_ARGs/scripts

ls $DATA/beagle_55_out/ | grep .vcf.gz > ~/Frog_ARGs/scripts/input_text/phase_files.txt
cd $DATA/beagle_55_out/
parallel -j 12 -a ~/Frog_ARGs/scripts/input_text/phase_files.txt bcftools index {}
bcftools concat --file-list ~/Frog_ARGs/scripts/input_text/phase_files.txt -Oz \
"-o /home/eccortes/Frog_ARGs/beagle_out/phased.gt.vcf.gz"

echo
echo "Filtering sites w/ less than 0.8 R^2"
echo

bcftools index ~/Frog_ARGs/beagle_out/phased.gt.vcf.gz

bcftools view -Oz -o ~/Frog_ARGs/beagle_out/filtered.gt.vcf.gz \
--regions-file filtered.txt \
~/Frog_ARGs/beagle_out/phased.gt.vcf.gz