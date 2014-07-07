#!/bin/bash
#2_sam_to_bam
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh


function SamToBam() {
	echo "Converting files, SAM to BAM format..."
	sleep 1
	declare -a pids
	
	for sample in "${batch[@]}"
	do	
	  echo "Converting sample ${sample} to BAM"
	  (${java_path} -jar ${picard_path}/SamFormatConverter.jar I=${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.sam O=${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.bam TMP_DIR=${temp_path} VALIDATION_STRINGENCY=SILENT) &
	  
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
