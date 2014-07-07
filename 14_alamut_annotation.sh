#!/bin/bash
#alamut_annotation.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function AlamutAnnotation() {
	echo "Annotating variants..."
	sleep 1
	
 	declare -a pids
 	
 	for sample in "${batch[@]}"
	do
		
		echo "Annotation with Alamut-Batch on sample ${sample}"

  	#Annotate selected variants with Alamut-HT
		${alamut_path} \
		--hgmdUser ${hgmd_user} --hgmdPasswd ${hgmd_pass} \
		--in ${base_path}/variants/haplotyper/${batch_id}_${sample}_${phenotype}.vcf  \
		--ann ${base_path}/variants/haplotyper/${batch_id}_${sample}_${phenotype}.alamut.alltrans.txt \
		--unann ${base_path}/variants/haplotyper/${batch_id}_${sample}_${phenotype}.alamut.alltrans.unannotated.txt \
		--alltrans \
		--ssIntronicRange 2 \
		--outputVCFInfo AC AF AN DP FS MQ MQ0 QD \
		--outputVCFGenotypeData AD DP GQ GT PL \
		--outputVCFQuality --outputVCFFilter
		
		#sleep for 1 second to allow for HGMD lock-out
		sleep 1
		
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
