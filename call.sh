# Running beagle for genotype calling as well as phasing and imputation

echo
echo "***Running genotype calling***"
echo

DATA="/space/s1/eccortes/frogs/working/var_sites.vcf.gz"

#Using  niterations=0 to avoid using 4.1 phasing algo
java -xss5m -Xmx20g -jar ../../local/beagle.4.1.jar gl=$DATA out=~/Frog_ARGs/beagle_out/out.gt niterations=0 gprobs=true impute=false
