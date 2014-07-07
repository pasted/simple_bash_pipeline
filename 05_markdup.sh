#!/bin/bash
#markdup.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function MarkDup() {
	echo "Marking duplicate reads..."
	sleep 1
	declare -a pids
	
	for sample in "${batch[@]}"
	do
		echo "Running MarkDuplicates on sample ${sample}"
		(${java_path} -Djava.io.tmpdir=${temp_path} -jar ${picard_path}/MarkDuplicates.jar \
		I=${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.sorted.bam O=${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.rmdup.bam \
		METRICS_FILE=${base_path}/duplicates/${sequencing_batch_id}_${sample}_L00${lane}.duplicates REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true) &	
		
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
