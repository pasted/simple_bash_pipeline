#!/bin/bash
#parse_batch_metrics.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function ParseBatchMetrics() {
	echo "Parsing batch metrics..."
	sleep 1
	
 	declare -a pids
 	
 	header_set=0
 	
 	for sample in "${batch[@]}"
	do
			awk 'NR==9' ${base_path}/metrics/${batch_id}_${sample}.realigned.bait_capture_metrics >> ${base_path}/metrics/${batch_id}.bait_capture_metrics
			awk 'NR==8' ${base_path}/duplicates/${sequencing_batch_id}_${sample}_L00${lane}.duplicates >> ${base_path}/duplicates/${batch_id}.duplicates
		
		#grab PID of last process - stored in array

		pids+=($!)
		
	done
	

		
	for pid in "${pids[@]}"
	do
		wait ${pid}
		echo "Process ${pid} finished."
 	done
 	unset pids[@]
 	
}
