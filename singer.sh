# Script to run singer

ratio="{$3:-1}"


# Won't run yet, need to ask about some of the parameters
    ~/local/singer-0.1.9-beta-linux-x86_64/singer_master  \
    -m [mutation rate] \
    -vcf ~/Frog_ARGs/beagle_out/phase.gt \
    -output singer_out ~Frog_ARGs/singer_out/out \
    -Ne [diploid Ne calculated from pi=4Ne*mu] \
    -n 100 \
    -thin 20 \
    -ratio 1
