library(ggplot2)
library(dplyr)
library(vcfR)
library(cachem)

disk_cache <- cache_disk(dir = "/space/s1/eccortes/frogs/r_cache")
# Might need to change path later
# vcf <- read.vcfR("~/Frog_ARGs/beagle_out/called.gt.vcf.gz")
# vcf_df <- vcfR2tidy(vcf, info_only = TRUE)
# disk_cache$set("called_vcf", vcf_df)

vcf_df <- disk_cache$get("called_vcf")
vcf_df <- vcf_df$fix


sprintf("Number of sites above 0.8 R^2 value: %s out of %s",
        sum(vcf_df$DR2 >= 0.8), nrow(vcf_df))

# Filter by DR2 value
vcf_df <- vcf_df |> filter(DR2 >= 0.8)

# Put into text file
writeLines(paste(as.character(vcf_df$CHROM),
                 as.character(vcf_df$POS), sep = "\t"),
           "Filtered.txt", sep = "\n")
# DR2_bar <- ggplot(
#     data = vcf_df,
#     mapping = aes(
#         x = DR2
#     )
# ) +
#     geom_histogram() +
#     labs(
#         X = "R^2 Value",
#         title = "Distribution of R^2 after imputation"
#     )

# ggsave("DR2_bar.pdf", path = "../plots", plot=DR2_bar, device = "pdf", dpi = 300)

