BiocManager::install("Biostrings")

library(Biostrings)
library(ggplot2)
library(vcfR)
library(dplyr)
library(cachem)

# Getting scaffold lengths
print("Reading fasta file")
scaffolds <- readDNAStringSet("/space/s1/eccortes/frogs/data/PmarmReference_masked.fasta")
print("Finished reading fasta file")

scaffolds <- readDNAStringSet("/space/s1/eccortes/frogs/data/PmarmReference_masked.fasta")

scaffold_lengths_df <- data.frame(
  ID = names(scaffolds),
  lengths = width(scaffolds)
)
sprintf("Number of scaffolds before filtering: %s", length(scaffold_lengths_df$lengths))

scaffold_lengths_df <- scaffold_lengths_df |> filter(lengths < 20000)
sprintf("Number of scaffoldsafter filtertin: %s", length(scaffold_lengths_df$lengths))

scaffold_lengths_plot <- ggplot(data = scaffold_lengths_df,
                                mapping = aes(
                                  x = lengths
                                ))
scaffold_lengths_histogram <- scaffold_lengths_plot +
  geom_histogram(binwidth = 10^3) + labs(
    title = "Scaffold Lengths",
    X = "Lengths",
    Y = "Count"
  )
print("Created scaffold length histogram")
sprintf("Number of scaffolds: %s", length(scaffold_lengths_df$lengths))
sprintf("IQR: %s", IQR(scaffold_lengths_df$lengths))
sprintf("SD: %s", sd(scaffold_lengths_df$lengths))

ggsave("scaffold_lengths_plot.pdf", path = "../plots", plot=scaffold_lengths_histogram, device = "pdf", dpi = 300)

# Variable sites per scaffold
disk_cache <- cache_disk(dir = "/space/s1/eccortes/frogs/r_cache")
scaffold_counts <- disk_cache$get("scaffold_counts")
print("Reading vcf file")
# if (!is.key_missing(scaffold_counts)) {
#   vcf <- read.vcfR("/space/s1/eccortes/frogs/data/var_sites.vcf.gz")
#   chroms <- getCHROM(vcf)
#   
#   scaffold_counts <- data.frame(table(chroms))
#   colnames(scaffold_counts) <- c("Scaffold", "variable_sites")
#   disk_cache$set("scaffold_counts", scaffold_counts)
# }
sprintf("Number of scaffolds before filtering: %s", length(scaffold_counts$variable_sites))
scaffold_counts <- scaffold_counts |> filter(variable_sites < 500)

sprintf("Number of scaffolds after filtering: %s", length(scaffold_counts$variable_sites))
var_sites_dot <- ggplot(data = scaffold_counts,
                         mapping = aes(
                           x = variable_sites)) +
                  geom_histogram() + labs(
    title = "Variable site counts per scaffold",
    X = "Number of sites")
print("Created variable sites histogram")
print(scaffold_counts)
print(summary(scaffold_counts$variable_sites))

ggsave("variable_per_scaffold_plot.pdf", path = "../plots", plot=var_sites_dot, device = "pdf", dpi = 300)
       


