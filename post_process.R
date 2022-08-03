library(tidyverse)
library(openxlsx)
options(scipen=999)
options(digits=4)
args = commandArgs(trailingOnly=TRUE)

sample=args[1]
#sample='OUN_HK124_001_D1'


## vars

vcf <- read_tsv(paste0(sample,'.annotated.vcf'), comment = '##') %>% 
  select(-INFO) %>%
  rename(CHROM = '#CHROM')

format <- vcf$FORMAT[1] %>% str_split(':', simplify = T)
vcfsamp <- names(vcf)[length(names(vcf))]

vcf <- vcf %>% 
  select(-FORMAT) %>% 
  separate(vcfsamp, format, sep = ':') %>% 
  select(CHROM, POS, REF, ALT, FILTER, DP, AD) %>%
  separate(AD, c('REF_READS', 'ALT_READS')) %>%
  select(-REF_READS) %>%
  mutate(
    DP = as.integer(DP),
    ALT_READS = as.integer(ALT_READS),
    VAF = round(ALT_READS / DP * 100, 1))


anno <- read_csv(paste0(sample,'.annotated.csv')) %>%
  select(CHROM, POS, REF, ALT, Locus, AaChange, Pathogenicity, DiseaseScore, HmtVar, Clinvar, 
         dbSNP, OMIM, MitomapAssociatedDiseases, MitomapHeteroplasmy, MitomapHomoplasmy, 
         `1KGenomesHeteroplasmy`, `1KGenomesHomoplasmy`, AlleleFreqH, AlleleFreqP, AlleleFreqH_EU, AlleleFreqP_EU, ends_with('_Prediction')) %>%
  mutate_at(vars(starts_with("AlleleFreq")), as.numeric) %>%
  mutate_at(vars(starts_with("AlleleFreq")), signif, digits = 3)


vars <- vcf %>% left_join(anno) 

## coverage

cov_sum <- read_tsv('metrics.txt', skip = 6, n_max = 1)

cov_base <- read_tsv('per_base_coverage.tsv')

cov_plot <- ggplot(cov_base, aes(pos, coverage)) +
  geom_bar(stat = 'identity') +
  theme_bw() +
  ggtitle(paste0(sample, ' chrM coverage'))

ggsave(plot = cov_plot, 'per_base_coverage.png', width = 8, height = 3)


## haplogroup

haplogr <- read_tsv(paste0(sample,'.realigned.contamination.txt'))


##create excel

list_of_datasets <- list("Variants" = vars, 
                         "Cov_summary" = cov_sum,
                         "Haplogroup" = haplogr)

write.xlsx(list_of_datasets, file = paste0(sample,'.xlsx'), asTable = T, na.string = '.', keepNA = T)




