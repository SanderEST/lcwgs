library(tidyverse)
options(scipen = 999)

ratio <-read_tsv('HK095-002_1.bam_ratio.txt', col_types = 'cinni') %>% filter(Chromosome %in% c(1:22,'X','Y'))

ploidy <- 2

chr13 <- ratio %>% filter(Chromosome == '13')


ggplot(ratio %>% filter(Chromosome == '1'), aes(Start, Ratio * 2)) +
  geom_point() +
  theme_bw() +
  scale_y_continuous(limits = c(0,4))

a <- ratio %>% filter(Chromosome == '13', Start > 41000000, Start < 41200000)

ggplot(a, aes(Start, Ratio * 2)) +
  geom_point() +
  theme_bw() +
  scale_y_continuous(limits = c(0,4))


ratio1x <- read_tsv('HK095-002_1_1x.bam_ratio.txt', col_types = 'cinni') %>% filter(Chromosome %in% c(1:22,'X','Y'))

ggplot(ratio1x %>% filter(Chromosome == '13', Start > 41000000, Start < 41200000), aes(Start, Ratio * 2)) +
  geom_point() +
  theme_bw() +
  scale_y_continuous(limits = c(0,4))

ggplot(ratio1x %>% filter(Chromosome == '13'), aes(Start, Ratio * 2)) +
  geom_point() +
  theme_bw() +
  scale_y_continuous(limits = c(0,4))

ratio2x <- read_tsv('HK095-002_1_2x.bam_ratio.txt', col_types = 'cinni') %>% filter(Chromosome %in% c(1:22,'X','Y'))

ggplot(ratio2x %>% filter(Chromosome == '13', Start > 41000000, Start < 41200000), aes(Start, Ratio * 2)) +
  geom_point() +
  theme_bw() +
  scale_y_continuous(limits = c(0,4))

ggplot(ratio2x %>% filter(Chromosome == '13'), aes(Start, Ratio * 2)) +
  geom_point() +
  theme_bw() +
  scale_y_continuous(limits = c(0,4))




ratios <- c(0.5, 1, 2, 4, 30)
sample='HK087-001_1'


data <- tibble(cov = ratios, sample = sample) %>%
  mutate(filename = paste0(sample, '_', cov, 'x.bam_ratio.txt')) %>%
  mutate(file_contents = map(filename,
                             ~ read_tsv(file.path(.), col_types = 'cinni'))) %>% 
  select(-filename) %>% # remove filenames, not needed anynmore
  unnest(cols = c(file_contents))


ggplot(data %>% filter(Chromosome == '5', Start > 36000000, Start < 38000000), aes(Start, Ratio * 2)) +
  geom_point() +
  facet_grid(cov ~ .) +
  theme_bw() +
  scale_y_continuous(limits = c(0,4))

ggplot(data %>% filter(Chromosome == '13'), aes(Start, Ratio * 2)) +
  geom_point() +
  facet_grid(cov ~ .) +
  theme_bw() +
  scale_y_continuous(limits = c(0,4))

cnvs <- read_tsv('HK095-001_1_2x.bam_CNVs.p.value.txt') %>% 
  mutate(len = end - start)


