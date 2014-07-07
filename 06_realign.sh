#!/bin/bash
#realign.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function Realign() {
		echo "Realigning reads..."
		sleep 1
		declare -a pids
		
		input_file_string=""
		
		for sample in "${batch[@]}"
		do
			
			echo "Running RealignerTargetCreator on sample ${sample}"
			input_file_string="-I ${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.rmdup.bam"
			
			
			${java_path} -Djava.io.tmpdir=${temp_path} -Xmx6g -jar ${gatk_path} -T RealignerTargetCreator \
			-known ${known_path} \
			-R ${reference_path} \
			-log ${base_path}/logs/RealignerTargetCreator.${batch_id}_${sample}.nodup.log \
			${input_file_string} -o ${base_path}/intervals/${batch_id}_${sample}.intervals  &
			
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
 		
 		sleep 1
		declare -a pids
		
		input_file_string=""
		
		for sample in "${batch[@]}"
		do
			echo "Running IndelRealigner on sample ${sample}"
			
			input_file_string="-I ${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.rmdup.bam"
			
			${java_path} -Djava.io.tmpdir=${temp_path} -Xmx6g -jar ${gatk_path} -T IndelRealigner \
			-known ${known_path} \
			-R ${reference_path} \
			-log  ${base_path}/logs/IndelRealigner.${batch_id}_${sample}.nodup.log\
			-compress 0 --maxReadsInMemory 1000000000 --maxReadsForRealignment 6000000 \
			${input_file_string} -o ${base_path}/assembly/${batch_id}_${sample}.realigned.bam \
			-targetIntervals ${base_path}/intervals/${batch_id}_${sample}.intervals  &
			
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
 		
 		sleep 1
		declare -a pids
		
		input_file_string=""
		
		for sample in "${batch[@]}"
		do
			
			echo "Running SortSam on sample ${sample}"
			
			input_file_string="-I ${base_path}/assembly/${sequencing_batch_id}_${sample}_L00${lane}.fixmate.rmdup.bam"
			
			${java_path} -Djava.io.tmpdir=${temp_path} -jar ${picard_path}/SortSam.jar \
			INPUT=${base_path}/assembly/${batch_id}_${sample}.realigned.bam \
			OUTPUT=${base_path}/assembly/${batch_id}_${sample}.realigned.sorted.bam \
			SO=coordinate \
			VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true &
			
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




 
