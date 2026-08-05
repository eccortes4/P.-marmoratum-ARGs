# Script to run beagle 5.5 for phasing and imputing

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

ls /space/s1/eccortes/frogs/beagle_55_out/ | grep .vcf.gz > phase_files.txt
cd /space/s1/eccortes/frogs/beagle_55_out/
parallel -j 12 -a ~/Frog_ARGs/scripts/phase_files.txt bcftools index {}
bcftools concat --file-list ~/Frog_ARGs/scripts/phase_files.txt -Oz -o /home/eccortes/Frog_ARGs/beagle_out/phased.gt.vcf.gz