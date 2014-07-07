#!/bin/bash
#Author 2014 Garan Jones
#Configuration file for each tNGS project pipeline to be run

#Modify this section for each project
#
#User details
#email will be sent to this account on completion
user_email="xxx@nhs.net"

#ftp details
#Available from notification email from the Exeter sequencing service
ftp_string="ftp://xxxx"
#ftp_string=""

#Sequencing batch id
#name of sample folders on FTP server
sequencing_batch_id="P5_8"

#batch id given by sequencing spreadsheet
#batch_id="P5_385-432"
batch_id=""

#Flowcell lane will be in the summary
lane="2"
#lane=""

#Flowcell details should be on the sequencing run summary in the FTP folder
flowcell_id="H871LADXX"
#flowcell_id=""

#Processing steps are sub-batched so as to not overload the server
#the sub_batch array contains the selections for the GetSamples function
#add or remove integers representing the sub_batches as required
#sub_batches=(1 2 3 4 5 6 7 8 9)
sub_batches=(1 2 3 4 5 6)

#maximum number of samples to be run at once to help limit
#the processing requirements for the larger sma
max_samples=8

#The integers for each case statement are taken from the command line argument
#Replace the sample ids on each line with the ones for the required batch
function GetSamples() {
		#loop through range of sample ids
		#replace with sample ids specific to the project to be run
		batch=()
		if [ "$1" ]
		then
			case "$1" in
			1) batch=("385" "386" "387" "388" "389" "390" "391" "392")
				;;
			2) batch=("393" "394" "395" "396" "397" "398" "399" "400")
				;;
			3) batch=("401" "402" "403" "404" "405" "406" "407" "408")
				;;
			4) batch=("409" "410" "411" "412" "413" "414" "415" "416")
				;;
			5) batch=("417" "418" "419" "420" "421" "422" "423" "424")
				;;
			6) batch=("425" "426" "427" "428" "429" "430" "431" "432")
				;;
			esac
		else
			echo "No batch id given, please a provide an integer"
		fi

}

#Phenotype specific sub-batches - Change these to reflect the distribution of the samples by phenotype


ndm_batch=("398" "425")
mody_batch=("425" "398")
#hi_batch=()
ndm_mody_batch=("394")
all_batch=("")

phenotypes=("all")

function GetSamplesByPhenotype() {
	case "$1" in
	 "ndm") echo "Calling variants for samples with NDM phenotype." 
					phenotype="NDM"
					batch=("${ndm_batch[@]}")
					roi_intervals_path="/mnt/Data1/targeted_sequencing/v5_NDM_diagnostic_ROI.interval_list"
					;;
	 "mody") echo "Calling variants for samples with MODY phenotype."
					phenotype="MODY"
					batch=("${mody_batch[@]}")
					roi_intervals_path="/mnt/Data1/targeted_sequencing/v5_MODY_diagnostic_ROI.interval_list"
					;;
	 "hi") echo "Calling variants for samples with HI phenotype."
					phenotype="HI"
					batch=("${hi_batch[@]}")
					roi_intervals_path="/mnt/Data1/targeted_sequencing/v5_HI_diagnostic_ROI.interval_list"
					;;
	 "ndm_mody") echo "Calling variants for samples with NDM_MODY phenotype."
					phenotype="NDM_MODY"
					batch=("${ndm_mody_batch[@]}")
					roi_intervals_path="/mnt/Data1/targeted_sequencing/v5_NDM_MODY_diagnostic_ROI.interval_list"
					;;
		"all")	echo "Calling variants for samples with ALL phenotype."
					phenotype="ALL"
					batch=("${all_batch[@]}")
					roi_intervals_path="/mnt/Data1/targeted_sequencing/PAv5_variant_calling_intervals.interval_list"
					;;
	esac
}

################################################################################
#HGMD account details for use with Alamut-Batch
#contains 
#hgmd_user=""
#hgmd_pass=""
#kept seperate so git-ignore can be used
source ./passwords.sh

################################################################################

#Version specific interval files
#Version 5 intervals for all bases
bait_intervals_path="/mnt/Data1/targeted_sequencing/PAv5_all_covered_bases.interval_list"

#Version 5 intervals for variant calling - enlarged ROI over original ROI file to account for Indels starting outside of old ROI
target_intervals_path="/mnt/Data1/targeted_sequencing/PAv5_variant_calling_intervals.interval_list"

################################################################################

#Executable URLs

#Java executable path
#Usually this set by a symbolic link in /usr/bin to the most recent version available of Java
#However previously this has not always been up-to-date enough for Picard
#Explicitly state the location of the Java executable to use
java_path="/usr/share/java/jre1.7.0_40/bin/java"

#BWA path (update after validation of a new version)
bwa_path="/usr/share/bwa/bwa-0.7.8/bwa"

#Picard URL executable
picard_path="/usr/share/picard/picard-tools-1.114"

#GATK URL executable
gatk_version="3.1-1"
gatk_path="/usr/share/gatk/GenomeAnalysisTK-3.1-1/GenomeAnalysisTK.jar"

#Alamut-Batch
alamut_path="/mnt/Data3/alamut-batch-1.2.0/alamut-ht"

################################################################################

#Reference URLs
#Reference genome path, currently 1000genomes GRCh37
#http://www.1000genomes.org/category/assembly
reference_path="/mnt/Data1/resources/human_g1k_v37.fasta"

#Known Indels required as statistical controls
#http://www.broadinstitute.org/gatk/guide/article?id=1247
known_path="/mnt/Data1/resources/Mills_and_1000G_gold_standard.indels.b37.vcf"

common_variants_nkmi="/mnt/Data1/resources/common_no_known_medical_impact_20140303-edited.vcf"

common_artefacts_path="/mnt/Data1/targeted_sequencing/database/2014_03_HC-3-1.1/P1_to_P5.HC_3.1-1.excl_common_non-clin.19052014.AF005.AN100.vcf"

dbsnp_path="/mnt/Data1/resources/dbsnp_137.b37.vcf"

#Working directory - absolute URL
working_dir="/mnt/Data4"

#Base URL of the current project
#base_path="/mnt/Data1/targeted_sequencing/P5_145-216"
base_path="${working_dir}/${batch_id}"

#BAM file directory
bam_directory="${base_path}/assembly"

#Only use ILLUMINA sequencers with the current pipeline
sequencer_name="ILLUMINA"

#Temp directory URL
temp_path="/mnt/Data3/tmp"




















