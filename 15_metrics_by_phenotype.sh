#!/bin/bash
#metrics_by_phenotype.sh
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function MetricsByPhenotype() {
	echo "Running Picard CalculateHsMetrics by phenotype specific genomic intervals..."
	sleep 1
	
 	declare -a pids
 	
 	for sample in "${batch[@]}"
	do
		
		echo "Running Picard CalculateHsMetrics for phenotype specific regions of interest (${phenotype}) on sample ${sample}"
		
		( ${java_path} -Xmx4g -jar ${picard_path}/CalculateHsMetrics.jar \
			I=${base_path}/assembly/${batch_id}_${sample}.realigned.sorted.bam \
			O=${base_path}/metrics/${batch_id}_${sample}.${phenotype}_ROI_capture_metrics \
			LEVEL=SAMPLE \
			BAIT_INTERVALS=${roi_intervals_path} \
			TARGET_INTERVALS=${roi_intervals_path}  \
			VALIDATION_STRINGENCY=SILENT ) &
			
		#grab PID of last process - stored in array
		pids+=($!)
		echo "Process ${!} started."
		echo "Number of processes :: ${#pids[@]}"
		if [ ${#pids[@]} -eq ${max_samples}]; then
				for pid in "${pids[@]}"
				do
					wait ${pid}
					echo "Process ${pid} finished."
 				done
 				unset pids[@]
		fi
		
	done

 	
 	echo "Running GATK DepthOfCoverage by phenotype specific genomic intervals..."
	sleep 1
	
 	declare -a pids
 	
 	for sample in "${batch[@]}"
	do
		
		echo "Running GATK DepthOfCoverage for phenotype specific regions of interest (${phenotype}) on sample ${sample}"
		
		( ${java_path} -Xmx4g -jar ${gatk_path} -T DepthOfCoverage \
		-L ${roi_intervals_path} \
		-R ${reference_path} \
		-I ${base_path}/assembly/${batch_id}_${sample}.realigned.sorted.bam \
		-o ${base_path}/coverage/${batch_id}_${sample}.${phenotype}_ROI.by_base_coverage \
		-mmq 30 -mbq 30 -dels -ct 1 -ct 10 -ct 20 -ct 30 -ct 40 -ct 50 -omitLocusTable ) &
			
		#grab PID of last process - stored in array
		pids+=($!)
		echo "Process ${!} started."
		echo "Number of processes :: ${#pids[@]}"
		if [ ${#pids[@]} -eq ${max_samples}]; then
				for pid in "${pids[@]}"
				do
					wait ${pid}
					echo "Process ${pid} finished."
 				done
 				unset pids[@]
		fi
		
	done
	
}
