#!/bin/bash
#select_variants_phenotype.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function SelectVariantsPhenotype() {
	echo "Running SelectVariants phenotypes..."
	sleep 1
	
 	declare -a pids
 	
 	for sample in "${batch[@]}"
	do
		
		echo "Running SelectVariants for phenotype specific regions of interest (${phenotype}) on sample ${sample}"
		
		#Select variants based on	phenotype
		${java_path} -Xmx4g -jar ${gatk_path} -T SelectVariants \
		-R ${reference_path} \
		-L ${roi_intervals_path} \
		--variant ${base_path}/variants/haplotyper/${batch_id}_${sample}.excl_common_non-clin.excl_common_artefacts.hap_call.vcf  \
		-o ${base_path}/variants/haplotyper/${batch_id}_${sample}_${phenotype}.vcf \
		-log ${base_path}/logs/${batch_id}_${sample}_${phenotype}.log &			

	
	  #grab PID of last process - stored in array
		echo "Process ${!} started."
		pids+=($!)
		
	done
	
	echo "Number of processes :: ${#pids[@]}"
		
	for pid in "${pids[@]}"
	do
		wait ${pid}
		echo "Process ${pid} finished."
 	done
 	unset pids[@]
 	
}
