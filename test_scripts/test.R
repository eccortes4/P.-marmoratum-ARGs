library(vcfR)

vcf <- read.vcfR("~/Frog_ARGs/beagle_out/test.gt.vcf.gz")
chroms <- getCHROM(vcf)

scaffold_counts <- data.frame(table(chroms))
colnames(scaffold_counts) <- c("Scaffold", "variable_sites")

print(head(scaffold_counts))
