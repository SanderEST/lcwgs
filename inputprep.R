
args = commandArgs(trailingOnly=TRUE)

sample = args[1]
cov = args[2]

cnvs <- read.delim(paste0(sample, '_', cov, 'x.bam_CNVs.p.value.txt'))
cnvs$SV_type <- ifelse(cnvs$status == 'gain', 'DUP', 'DEL')


names(cnvs) <- c('#Chrom', 'Start', 'End', 'CN', 'status', 'WilcoxonRankSumTestPvalue', 'KolmogorovSmirnovPvalue', 'SV_type')

cnvs_final <- cnvs[, c(1, 2, 3, 8, 4,5,6,7)]

write.table(cnvs_final, file = paste0(sample, '_', cov, 'x.bam_CNVs.p.value.input.bed'), sep = '\t', quote = F, row.names = F)