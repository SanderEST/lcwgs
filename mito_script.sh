sample=$1

mkdir $sample
cd $sample

cat /mnt/sda/exomes/CNV/cromwell.options | sed "s/SAMPLE/${sample}/g" > cromwell.options
cat /mnt/sda/exomes/CNV/mitochondria-pipeline.inputs.json | sed "s/SAMPLE/${sample}/g" > mitochondria-pipeline.inputs.json
cp /mnt/sda/exomes/mito_wgs/wgs_broad/launch_cromwell_mito_cram.sh .

sh launch_cromwell_mito_cram.sh

find MitochondriaPipeline -type f -exec cp {} . \;

gatk LeftAlignAndTrimVariants -V output.vcf -R /mnt/sda/exomes/mito_wgs/chrM/Homo_sapiens_assembly38.chrM.fasta --split-multi-allelics -O ${sample}.splitmulti.vcf

hmtnote annotate ${sample}.splitmulti.vcf ${sample}.annotated.vcf --csv --offline

Rscript /mnt/sda/exomes/mito_wgs/post_process.R $sample
