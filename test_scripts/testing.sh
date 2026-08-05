#!/bin/bash

DATA="/space/s1/eccortes/frogs/working/var_sites.vcf.gz"

java -Xss5m -Xmx$1g -jar ~/local/beagle.4.1.jar \
gl=$DATA \
out=~/Frog_ARGs/beagle_out/test.gt \
chrom=$2 \
niterations=0 \
gprobs=true \
impute=false \
nthreads=$3