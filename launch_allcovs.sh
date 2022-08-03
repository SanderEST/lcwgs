
ref_fasta=/mnt/sda/reference/hg38/Homo_sapiens_assembly38.fasta 

input_cram=/media/arhiiv2/Eksoomid/Patsiendid_mujalt/Broad/WGS/${1}.cram 

samtools view -h -T ${ref_fasta} ${input_cram} | samtools view -b -o ${1}_30x.bam - 

samtools index -b ${1}_30x.bam 

sh script_sample_cov.sh $1 0.5
sh script_sample_cov.sh $1 1
sh script_sample_cov.sh $1 2
sh script_sample_cov.sh $1 4
sh script_sample_cov_freec.sh $1 30
