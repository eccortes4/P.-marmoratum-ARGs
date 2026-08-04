#!/usr/bin/env bash
# Running beagle for genotype calling and imputation

echo
echo "***Running genotype calling***"
echo

DATA="/space/s1/eccortes/frogs/working/var_sites.vcf.gz"

# Using parallel for faster run times
# Using niterations=0 to avoid using 4.1 phasing algo
# Using 11 threads is good enough and increasing will slow down performance

parallel -j 12 -a Scaffolds.txt \
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

cd /space/s1/eccortes/frogs/beagle_41_out/
ls | grep .vcf.gz > ~/Frog_ARGs/scripts/files.txt
parallel -j 12 -a ~/Frog_ARGs/scripts/files.txt bcftools index {}
bcftools concat --file-list ~/Frog_ARGs/scripts/files.txt -Oz -o /home/eccortes/Frog_ARGs/beagle_out/called.gt.vcf.gz