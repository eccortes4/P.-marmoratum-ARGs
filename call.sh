#!/usr/bin/env bash
# Running beagle for genotype calling, imputation, and phasing

echo
echo "***Running genotype calling***"
echo

DATA="/space/s1/eccortes/frogs/working/var_sites.vcf.gz"

# Using parallel for faster run times
# Using niterations=0 to avoid using 4.1 phasing algo
# Using 11 threads is good enough and increasing will slow down performance

parallel -j 12 -a ./input_text/Scaffolds.txt \
"java -Xss5m -Xmx80g -jar ~/local/beagle.4.1.jar \
gl=$DATA \
out=/space/s1/eccortes/frogs/beagle_41_out/called.{}.gt \
chrom={} \
niterations=0 \
gprobs=true \
impute=false \
nthreads=11"

echo
echo "Merging files back into one"
echo

cd /space/s1/frogs/beagle_41_out/
ls -d "$PWD"/* | grep .vcf.gz > ~/Frog_ARGs/scripts/input_text/test.txt

parallel -j 12 -a ~/Frog_ARGs/scripts/input_text/files.txt bcftools index {}

bcftools concat --file-list ~/Frog_ARGs/scripts/input_text/test.txt -Oz \
"-o /home/eccortes/Frog_ARGs/beagle_out/test.gt.vcf.gz"

cd ~/Frog_ARGs/scripts

# Phase output from 4.1
echo
echo "***Running Beagle 5.5 for phasing***"
echo

INPUT="~/Frog_ARGs/beagle_out/called.gt.vcf.gz"

# Reminder: pay attention to how long it takes to run: if not bad, may want to update burnin and iterations paramters for 
# better accuracy


parallel -j 12 -a Scaffolds.txt "java -Xmx60g -jar ~/local/beagle.5.5.jar \
gt=$INPUT \
out=/space/s1/eccortes/frogs/beagle_55_out/phase.{}.gt \
chrom={} \
nthreads=11"

# Merge files back together
echo
echo "***Merging Files back together***"
echo

cd ~/Frog_ARGs/scripts

ls /space/s1/eccortes/frogs/beagle_55_out/ | grep .vcf.gz > ~/Frog_ARGs/scripts/input_text/phase_files.txt
cd /space/s1/eccortes/frogs/beagle_55_out/
parallel -j 12 -a ~/Frog_ARGs/scripts/input_text/phase_files.txt bcftools index {}
bcftools concat --file-list ~/Frog_ARGs/scripts/input_text/phase_files.txt -Oz \
"-o /home/eccortes/Frog_ARGs/beagle_out/phased.gt.vcf.gz"

echo
echo "Filtering sites w/ less than 0.8 R^2"
echo

bcftools index ~/Frog_ARGs/beagle_out/phased.gt.vcf.gz

bcftools view -Oz -o ~/Frog_ARGs/beagle_out/filtered.gt.vcf.gz \
--regions-file Filtered.txt \
~/Frog_ARGs/beagle_out/phased.gt.vcf.gz