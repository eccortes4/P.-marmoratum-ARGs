#!/bin/bash
bcftools index ~/Frog_ARGs/beagle_out/phased.gt.vcf.gz

bcftools view -Oz -o ~/Frog_ARGs/beagle_out/filtered.gt.vcf.gz \
--regions-file Filtered.txt \
~/Frog_ARGs/beagle_out/phased.gt.vcf.gz
