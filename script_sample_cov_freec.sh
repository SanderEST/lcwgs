

sample_name=$1

cov=$2


tools/FREEC-11.6/src/freec -conf config_WGS.txt  -sample ${sample_name}_${cov}x.bam

cat tools/FREEC-11.6/scripts/assess_significance.R | R --slave --args ${sample_name}_${cov}x.bam_CNVs ${sample_name}_${cov}x.bam_ratio.txt

cat tools/FREEC-11.6/scripts/makeGraph.R | R --slave --args 2 ${sample_name}_${cov}x.bam_ratio.txt

Rscript inputprep.R ${sample_name} ${cov}

AnnotSV \
  -SvinputFile ${sample_name}_${cov}x.bam_CNVs.p.value.input.bed \
  -genomeBuild GRCh38 \
  -SVinputInfo 1 \
  -svtBEDcol 4 \
  -outputFile  ${sample_name}_${cov}x.bam_CNVs.annotated.tsv


