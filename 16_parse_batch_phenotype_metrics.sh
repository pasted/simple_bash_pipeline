#!/bin/bash
#parse_batch_phenotype_metrics.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function ParseBatchPhenotypeMetrics() {
	echo "Parsing batch metrics by phenotype specific genomic intervals..."
	sleep 1
	
 	declare -a pids
 	
 	#remove any old version of the capture metrics, due to append
 	if [ -f ${base_path}/metrics/${batch_id}.${phenotype}_ROI_capture_metrics ]; then
 		rm ${base_path}/metrics/${batch_id}.${phenotype}_ROI_capture_metrics
	fi
 	
 	for sample in "${batch[@]}"
	do
		
		awk 'NR==9' ${base_path}/metrics/${batch_id}_${sample}.${phenotype}_ROI_capture_metrics >> ${base_path}/metrics/${batch_id}.${phenotype}_ROI_capture_metrics

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
		
