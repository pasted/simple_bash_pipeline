#!/bin/bash
#simple bash pipeline
#Author 2014 Garan Jones
#Usage::

source ./config.sh
source ./00_wget.sh
source ./01_bwa_mem.sh
source ./02_sam_to_bam.sh
source ./03_fixmate.sh
source ./04_sort.sh
source ./05_markdup.sh
source ./06_realign.sh
source ./07_metrics.sh
source ./08_parse_batch_metrics.sh
source ./09_haplotyper.sh
source ./10_variant_filtration.sh
source ./11_select_variants_nkmi.sh
source ./12_select_variants_ca.sh
source ./13_select_variants_phenotype.sh
source ./14_alamut_annotation.sh
source ./15_metrics_by_phenotype.sh
source ./16_parse_batch_phenotype_metrics.sh

start_time=$(date)

 	#remove any old version of the capture metrics / duplicates, due to append
 	if [ -f ${base_path}/metrics/${batch_id}.bait_capture_metrics ]; then
 		rm ${base_path}/metrics/${batch_id}.bait_capture_metrics
	fi
	if [ -f ${base_path}/duplicates/${batch_id}.duplicates ]; then
 		rm ${base_path}/duplicates/${batch_id}.duplicates
	fi
	
for sub_batch in "${sub_batches[@]}"
do
	
	GetSamples $sub_batch

	Wget
	
	wait $!
	
	echo "Renaming FASTQ files..."
	
	perl -w ${base_path}/scripts/rename.pl 's/(.*)_[ACGT]{6}_(.*).fastq/$1_$2.fastq/' ${base_path}/raw_reads/*.fastq
	perl -w ${base_path}/scripts/rename.pl 's/(.*)_[ACGT]{6}_(.*).fastq/$1_$2.fastq/' ${base_path}/raw_reads/md5sum/*.fastq.md5sum
	
	wait $!
	
	ls -l --color=auto ${base_path}/raw_reads/
	
	echo "Starting alignment pipeline"
	
	BwaMem && SamToBam && FixMatePairs && SortBam && MarkDup && Realign && Metrics && ParseBatchMetrics
	
	wait $!

done

	#remove old headers if they exist
	if [ -f ${base_path}/metrics/header ]; then
		rm ${base_path}/metrics/header
	fi
	if [ -f ${base_path}/duplicates/header ]; then
		rm ${base_path}/duplicates/header
	fi
	
	#Add headers to the batch metrics / duplicates
	awk 'NR==7' ${base_path}/metrics/${batch_id}_${sample}.realigned.bait_capture_metrics > ${base_path}/metrics/header
	awk 'NR==7' ${base_path}/duplicates/${sequencing_batch_id}_${sample}_L00${lane}.duplicates > ${base_path}/duplicates/header
	
	cat ${base_path}/metrics/header ${base_path}/metrics/${batch_id}.bait_capture_metrics > ${base_path}/metrics/${batch_id}_final.bait_capture_metrics
	cat ${base_path}/duplicates/header ${base_path}/duplicates/${batch_id}.duplicates > ${base_path}/duplicates/${batch_id}_final.duplicates


#echo "Finished alignment and metrics"
#echo "Starting variant calling by phenotype"

for this_phenotype in "${phenotypes[@]}"
do

	GetSamplesByPhenotype $this_phenotype
	
  Haplotyper && VariantFiltration && SelectVariantsNKMI && SelectVariantsCA && SelectVariantsPhenotype && AlamutAnnotation && MetricsByPhenotype && ParseBatchPhenotypeMetrics
	
	wait
	
	cat ${base_path}/metrics/header ${base_path}/metrics/${batch_id}.${phenotype}_ROI_capture_metrics > ${base_path}/metrics/${batch_id}_final.${phenotype}_ROI_capture_metrics
	
done

wait $!

end_time=$(date)

echo "All Done - Sending notification email"


mail -s "${batch_id} Pipeline complete" "${user_email}" <<EOF
Pipeline complete
Start time		:: ${start_time}
End time		:: ${end_time}
EOF
