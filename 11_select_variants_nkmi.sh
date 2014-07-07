#!/bin/bash
#select_variants_nkmi.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function SelectVariantsNKMI() {
	echo "Running SelectVariants NKMI..."
	sleep 1
	declare -a pids
 	
 	for sample in "${batch[@]}"
	do
		
		echo "Running SelectVariants for common no medical impact on sample ${sample}"
		
		#Remove common no known medical impact variants	
		#common_no_known_medical_impact_20140303-edited.vcf
		#edited to remove chr12.121432117 common SNV
		java -Xmx12g -jar ${gatk_path} -T SelectVariants \
		-R ${reference_path} \
		--variant ${base_path}/variants/haplotyper/${batch_id}_${sample}.filtered.hap_call.vcf \
		-o ${base_path}/variants/haplotyper/${batch_id}_${sample}.excl_common_non-clin.hap_call.vcf \
		--discordance ${common_variants_nkmi} \
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
