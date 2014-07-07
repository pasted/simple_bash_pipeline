#!/bin/bash
#Author 2014 Garan Jones
#Usage::
#part of pipeline, see pipeline.sh

function Wget() {
	
		echo "Downloading FASTQ raw reads..."
		sleep 1
		
		for sample in "${batch[@]}"
		do
			echo "Downloading sample :: ${sample}"
			
			#generate folder and filenames
			#this_folder="Sample_P5_5_${sample}/raw_illumina_reads/"
			#check the FTP folder for the sample string details
			this_folder="Sample_${sequencing_batch_id}_${sample}/raw_illumina_reads/"
			
			# Wget options
			# -r recursively download
			# -l maximum depth to descend to
			# --no-parent ignore upper directories
			# -nH dont save under hostname folder (zeus-galaxy.ex.ac.uk)
			# --cut-dirs number of directory levels to remove
			# -A select only files with this extension
			# -P directory prefix
			# -w wait time between requests
			wget -r -l 1 --no-parent -nH --cut-dirs=3 -A "*.fastq" -P "${base_path}/raw_reads/" -w 1 ${ftp_string}/${this_folder}		
			wget -r -l 1 --no-parent -nH --cut-dirs=3 -A "*.fastq.md5sum" -P "${base_path}/raw_reads/md5sum/" -w 1  ${ftp_string}/${this_folder}
			

			
		done
		
		
}
