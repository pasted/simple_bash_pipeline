#!/bin/bash
#haplotyper.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function Haplotyper() {
	echo "Running HaplotypeCaller..."
	sleep 1
	declare -a pids
    
	for sample in "${batch[@]}"
	do
  			
		echo "Running HaplotypeCaller on sample ${sample}"
		
		input_file_string="-I ${bam_directory}/${batch_id}_${sample}.realigned.sorted.bam"
  	
		#Haplotype Caller used to call variants
		java -Xmx4g -jar ${gatk_path} -T HaplotypeCaller \
		-R ${reference_path} \
		-rf BadCigar -stand_call_conf 50.0 -stand_emit_conf 30.0 -dcov 100000 \
		-L ${target_intervals_path} \
		-log ${base_path}/logs/${batch_id}_${sample}_haplotype_caller.log \
		${input_file_string} \
		-o ${base_path}/variants/haplotyper/${batch_id}_${sample}.hap_call.vcf
		
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
