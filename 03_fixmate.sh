#!/bin/bash
#fixmate.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function FixMatePairs() {
	echo "Running Picard FixMateInformation..."
	sleep 1
	declare -a pids
	
	for sample in "${batch[@]}"
	do
	  echo "Running FixMateInformation on sample ${sample}"
	  (${java_path} -Xmx4g -jar ${picard_path}/FixMateInformation.jar INPUT=${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.bam OUTPUT=${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.bam TMP_DIR=${temp_path} SORT_ORDER=coordinate VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true) >& ${base_path}/logs/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.log &		
	
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
