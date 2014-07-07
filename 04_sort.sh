#!/bin/bash
#sort.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function SortBam() {
	echo "Sorting BAM files..."
	sleep 1
	declare -a pids
	
	for sample in "${batch[@]}"
	do
			echo "Sorting sample ${sample}"
			(${java_path} -Djava.io.tmpdir=${temp_path} -jar ${picard_path}/SortSam.jar \
			INPUT=${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.bam \
			OUTPUT=${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.sorted.bam \
			SO=coordinate \
			VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true ) &
		
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
