# Running beagle for genotype calling as well as phasing and imputation

echo
echo "***Running genotype calling***"
echo

DATA="/space/s1/eccortes/frogs/working/var_sites.vcf.gz"

# Using parallel for faster run times
# If receiving error from bcftools try running bcftools index path/to/vcf/file
#Using  niterations=0 to avoid using 4.1 phasing algo



parallel -j 10 -a Scaffolds.txt "java -Xss5m -Xmx40g -jar ~/local/beagle.4.1.jar gl=$DATA out=~/Frog_ARGs/beagle_out/called.gt \
chrom={} niterations=0 gprobs=true impute=false nthreads=11"


