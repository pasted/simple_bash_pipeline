#!/bin/bash
#variant_filtration.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function VariantFiltration() {
	echo "Running VariantFiltration..."
	sleep 1
	declare -a pids
 	
 	for sample in "${batch[@]}"
	do
		echo "Adding VariantFiltration annotation on sample ${sample}"
		
		#Add Filters to the variants based on given criteria - annotation only no variants removed
		java -Xmx4g -jar ${gatk_path} -T VariantFiltration \
		-R ${reference_path} \
		--filterExpression "QD < 2.0" --filterName "QD2" \
		--filterExpression "MQ < 40.0" --filterName "MQ40" \
		--filterExpression "ReadPosRankSum < -8.0" --filterName "RPRS-8" \
		--filterExpression "FS > 60.0" --filterName "FS60" \
		--filterExpression "MQRankSum < -12.5" --filterName "MQRankSum-12.5" \
		-o ${base_path}/variants/haplotyper/${batch_id}_${sample}.filtered.hap_call.vcf \
		--variant ${base_path}/variants/haplotyper/${batch_id}_${sample}.hap_call.vcf \
		-log ${base_path}/logs/${batch_id}_${sample}.filtered_hap_call.log &
		
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
