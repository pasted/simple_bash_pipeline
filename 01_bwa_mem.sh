#!/bin/bash
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function BwaMem() {
	
		echo "Running BWA MEM..."
		sleep 1
		
		#Initialise temp variables
		forward_reads=""
		reverse_reads=""
		read_group=""	
		declare -a pids
		
		for sample in "${batch[@]}"
		do
		 #Loop to parse the URL of the forward and reverse raw fastq reads
		 for direction in 1 2
		 do
		 	  if [ "$direction" -eq 1 ]; then
		 	  	  forward_reads="${working_dir}/${batch_id}/raw_reads/${sequencing_batch_id}_${sample}_L00${lane}_R${direction}_001.fastq"
		 	  else
		 	  	  reverse_reads="${working_dir}/${batch_id}/raw_reads/${sequencing_batch_id}_${sample}_L00${lane}_R${direction}_001.fastq"
		 	  fi
		 done
		  	  
		  #See SOP for details on how the read group header is constructed
		 	read_group="@RG\tID:${flowcell_id}\tPL:${sequencer_name}\tSM:P5_${sample}\tLB:${batch_id}"
		  
		 	(${bwa_path} mem -t 4 -M -v 1 -R ${read_group} \
		  ${reference_path} ${forward_reads} ${reverse_reads} > ${working_dir}/${batch_id}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.sam) \
		 	>& ${working_dir}/${batch_id}/logs/${sequencing_batch_id}_${sample}_L00${lane}.bwa_mem.log &
		 		
			#grab PID of last process - stored in array
			echo "Process ${!} started."
			pids+=($!)
		 		
		  #Echo the details to screen so that the read_group header can be checked manually  		
		  echo "(${bwa_path} mem -t 4 -M -v 1 -R ${read_group} \
		  ${reference_path} ${forward_reads} ${reverse_reads} > ${working_dir}/${batch_id}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.sam) \
		  >& ${working_dir}/${batch_id}/logs/${sequencing_batch_id}_${sample}_L00${lane}.bwa_mem.log &"
		  
	done
		
  echo "Number of processes :: ${#pids[@]}"
		
	for pid in "${pids[@]}"
	do
		wait ${pid}
		echo "Process ${pid} finished."
 	done
 	unset pids[@]
		
}

