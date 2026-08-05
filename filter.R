library(cachem)
library(dplyr)
library(vcfR)
library(stringr)
library(ggplot2)

# Writes all scaffolds w/ less than 100 variable sites to txt file for input to bcftools
# vcf <- read.vcfR("/space/s1/eccortes/frogs/working/var_sites.vcf.gz")


# meta_lines <- vcf@meta
# contig_lines <- grep("##contig=<ID=", meta_lines, value = TRUE)

# contig_info_df <- data.frame(str_split_fixed(contig_lines, ',', 2))
# colnames(contig_info_df) <- c("ID", "Length")

# contig_info_df$ID <- str_remove(contig_info_df$ID, "##contig=<ID=")
# contig_info_df$Length <- as.numeric(gsub("\\D", "", contig_info_df$Length))


# var_counts <- data.frame(table(getCHROM(vcf)))
# colnames(var_counts) <- c("ID", "variable_sites")

# print("Joining")
# contig_info_df <- inner_join(contig_info_df, var_counts, by="ID")

disk_cache <- cache_disk(dir = "/space/s1/eccortes/frogs/r_cache")
# scaffold_counts <- disk_cache$set("contig_info", contig_info_df)

contig_info_df <- disk_cache$get("contig_info")


contig_info_df <- contig_info_df |> filter(variable_sites >= 100)
# var_sites_bar <- ggplot(data = contig_info_df,
#                          mapping = aes(
#                            x = variable_sites)) +
#                   geom_histogram() + labs(
#     title = "Variable site counts per scaffold",
#     X = "Number of sites") + xlim(90, 750)
# ggsave("variable_per_scaffold_plot.pdf", path = "../plots", plot=var_sites_bar, device = "pdf", dpi = 300)
writeLines(paste(as.character(contig_info_df$ID), as.character(contig_info_df$Length), sep = '  '), "Lengths.txt", sep = '\n')