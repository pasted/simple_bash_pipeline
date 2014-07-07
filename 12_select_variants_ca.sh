#!/bin/bash
#select_variants_CA.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function SelectVariantsCA() {
	echo "Running SelectVariants CA..."
	sleep 1
	declare -a pids
 	
 	for sample in "${batch[@]}"
	do
		
		echo "Running SelectVariants for common artefacts on sample ${sample}"
		
		#Remove common artefacts	
		java -Xmx12g -jar ${gatk_path} -T SelectVariants \
		-R ${reference_path} \
		--variant ${base_path}/variants/haplotyper/${batch_id}_${sample}.excl_common_non-clin.hap_call.vcf \
		-o ${base_path}/variants/haplotyper/${batch_id}_${sample}.excl_common_non-clin.excl_common_artefacts.hap_call.vcf \
		--discordance ${common_artefacts_path} \
		-U LENIENT_VCF_PROCESSING &
	
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
