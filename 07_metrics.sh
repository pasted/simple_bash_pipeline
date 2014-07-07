#!/bin/bash
#metrics.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function Metrics() {
	echo "Running metrics..."
	sleep 1
	declare -a pids
    
	for sample in "${batch[@]}"
	do
		echo "Running CalculateMetrics on sample ${sample}"
		
		( ${java_path} -Xmx8g -jar ${picard_path}/CalculateHsMetrics.jar \
		I=${base_path}/assembly/${batch_id}_${sample}.realigned.sorted.bam \
		O=${base_path}/metrics/${batch_id}_${sample}.realigned.bait_capture_metrics \
		LEVEL=SAMPLE \
		BAIT_INTERVALS=${bait_intervals_path} \
		TARGET_INTERVALS=${bait_intervals_path} \
		VALIDATION_STRINGENCY=SILENT ) &
			
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
