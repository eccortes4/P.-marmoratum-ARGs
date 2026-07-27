# Running beagle for genotype calling as well as phasing and imputation

echo
echo "***Running genotype calling***"
echo

DATA="/space/s1/eccortes/frogs/working/var_sites.vcf.gz"

# Using parallel for faster run times
# If receiving error from bcftools try running bcftools index path/to/vcf/file
#Using  niterations=0 to avoid using 4.1 phasing algo

mkdir /space/s1/eccortes/frogs/temp ; cd /space/s1/eccortes/frogs/temp

parallel -a ~/Frog_ARGs/scripts/Scaffolds.txt "bcftools view -Oz -o inp{}.vcf.gz -r {} $DATA"

parallel -j 10 "java -Xss5m -Xmx40g -jar ~/local/beagle.4.1.jar gl={1} out=/space/s1/eccortes/frogs/beagle_41_out/{1/.}out.gt \
niterations=0 gprobs=true impute=false nthreads=11" ::: *.vcf.gz

# Put list of new files into a file for merging
echo
echo "Merging files back into one"
echo

ls /space/s1/eccortes/frogs/beagle_41_out | grep inp > ~/Frog_ARGS/scripts/files.txt
bcftools merge --file-list files.txt -Oz -o ~/Frog_ARGs/beagle_out/called.vcf.gz

