class AlamutParser
  require 'yaml'
  require 'smarter_csv'
  require './variant'
  require './sample'
  require 'spreadsheet'
  
  
  def parse_file(file_name, sample_id_lc)
  	options = { :col_sep => "\t" }
  	variant_array = Array.new 
  	
  	if File.exists?(file_name) && ( File.stat(file_name).size > 0 )           
  		SmarterCSV.process( file_name, options ) do |csv|
  			this_variant = Variant.new
  			this_variant.chromosome 					= csv.first[:chrom]
  			this_variant.position							= csv.first[:pos]
  			this_variant.gene 								= csv.first[:gene]
  			this_variant.genotype							=	csv.first[:"gt_(#{sample_id_lc})"]
  			this_variant.transcript 					= csv.first[:transcript]
  			this_variant.var_type							= csv.first[:vartype]
  			this_variant.coding_effect				= csv.first[:codingeffect]
  			this_variant.var_location 				= csv.first[:varlocation]
  			this_variant.genomic_nomen 				= csv.first[:gnomen]
  			this_variant.cdna_nomen	 					= csv.first[:cnomen]
  			this_variant.protein_nomen 				= csv.first[:pnomen]
  			this_variant.distance_nearest_splice_site 	= csv.first[:distnearestss]
  			this_variant.nearest_splice_site_type 			= csv.first[:nearestsstype]
  			this_variant.nearest_splice_site_change 		= csv.first[:nearestsschange]
  			this_variant.local_splice_effect						= csv.first[:localspliceeffect]
  			this_variant.rs_id 									= csv.first[:rsid]
  			this_variant.rs_validated 					= csv.first[:rsvalidated]
  			this_variant.rs_maf									= csv.first[:rsmaf]
  			this_variant.esp_all_maf						= csv.first[:espallmaf]
  			this_variant.hgmd_phenotype 				= csv.first[:hgmdphenotype]
  			this_variant.hgmd_pub_med_id 				= csv.first[:hgmdpubmedid]
  			this_variant.hgmd_sub_category 			= csv.first[:hgmdsubcategory]
  			this_variant.n_orthos								= csv.first[:northos]
  			this_variant.conserved_orthos				= csv.first[:conservedorthos]
  			this_variant.conserved_dist_species	= csv.first[:conserveddistspecies]
  			this_variant.grantham_dist					= csv.first[:granthamdist]
  			this_variant.agv_gd_class						= csv.first[:agvgdclass]
  			this_variant.sift_prediction				= csv.first[:siftprediction]
  			this_variant.wt_nuc									=	csv.first[:wtnuc]
  			this_variant.var_nuc								=	csv.first[:varnuc]
  			this_variant.ins_nucs								=	csv.first[:insnucs]
  			this_variant.del_nucs								= csv.first[:delnucs]
  			this_variant.filter_vcf							= csv.first[:"filter_(vcf)"]
  			
  			this_variant.ad											= csv.first[:"ad_(#{sample_id_lc})"]
  			this_variant.dp											= csv.first[:"dp_(#{sample_id_lc})"]
  			this_variant.gq											= csv.first[:"gq_(#{sample_id_lc})"]
  			this_variant.gt											= csv.first[:"gt_(#{sample_id_lc})"]
  			this_variant.pl											= csv.first[:"pl_(#{sample_id_lc})"]
  			
  			variant_array.push(this_variant)
  			
  			#puts csv.first.inspect
    	
  		end
  	else
  		puts "ERROR :: variants file has no content :: SAMPLE ID : #{sample_id_lc}"
  		puts "File exists? #{File.exists?(file_name)}"
  		puts "File size? #{File.stat(file_name).size}"
  	end
  	return variant_array
  end
  
  def parse_sample_list(sample_file_path)
  	options = { :col_sep => "," }
  	sample_array = Array.new
  	
  	SmarterCSV.process( sample_file_path, options ) do |csv|
  		this_sample = Sample.new
  		this_sample.capture_number 	= csv.first[:capture_number]
  		this_sample.mody_number			= csv.first[:mody_number]
  		this_sample.ex_number				= csv.first[:ex_number]
  		this_sample.gender					= csv.first[:gender]
  		this_sample.analysis_type		= csv.first[:analysis]
  		this_sample.geneset					= csv.first[:disease]
  		this_sample.sample_type			= csv.first[:sample_type]
  		this_sample.comment					= csv.first[:comment]
  		
  		sample_array.push(this_sample)
  		#puts csv.first.inspect
  	end
  	
  	return sample_array
  end
  
  def parse_unwanted_variants(unwanted_file_path)
  	options = { :col_sep => "," }
  	unwanted_array = Array.new
  	
  	SmarterCSV.process( unwanted_file_path, options ) do |csv|
  		this_unwanted_variant = Variant.new

  		this_unwanted_variant.chromosome 	= csv.first[:chrom]
  		this_unwanted_variant.position		= csv.first[:pos]
  		this_unwanted_variant.gene 				= csv.first[:gene]		
  		this_unwanted_variant.wt_nuc			=	csv.first[:wtnuc]
  		this_unwanted_variant.var_nuc			=	csv.first[:varnuc]
  		this_unwanted_variant.ins_nucs		=	csv.first[:insnucs]
  		this_unwanted_variant.del_nucs		= csv.first[:delnucs]
  		
  		unwanted_array.push(this_unwanted_variant)
  		#puts csv.first.inspect
  	end
  	
  	return unwanted_array
	end
  
  def parse_transcripts(transcript_file_name)				
  	transcript_array = Array.new
		
		File.readlines(transcript_file_name).each do |this_transcript|
			this_transcript.strip!
			transcript_array.push(this_transcript)
		end				
		return transcript_array
	end
  
  #Load the config YAML file and pass the settings to local variables
  config = YAML.load_file('../configuration/config.yaml')
  
  batch_id = config["batch_id"]
  base_path = config["base_path"]
  variants_directory = config["variants_directory"]
  transcript_file_path = config["transcript_file_path"]
  unwanted_file_path = config["unwanted_file_path"]
  sample_list_path = config["sample_list_path"]
  panel_id = config["panel_id"]
  
  #Init AlamutParser class
  parser = AlamutParser.new()
  
  samples = parser.parse_sample_list(sample_list_path)
  phenotype_store = Hash.new
  
  
  samples.each do |this_sample|

  	full_sample_id 	= this_sample.capture_number
  	phenotype		   	= this_sample.geneset
  	sample_id 			= full_sample_id.split('_')[2]
  	
  	puts "SAMPLE ID :: #{sample_id}"
  	
  	
  	if !phenotype_store.has_key?(phenotype)
  		sample_store_array = Array.new
  		phenotype_store["#{phenotype}"] = sample_store_array
  	end
  	
  	#Load variants from alltrans alamut file
  	variants = parser.parse_file("#{base_path}/#{batch_id}/#{variants_directory}/#{batch_id}_#{sample_id}_#{phenotype}.alamut.alltrans.txt", "#{panel_id}_#{sample_id}")
  	
  	puts "variants number :: #{variants.length}"
  	
  	selected_variants = Array.new
  	not_selected_variants = Array.new
  	
  	#Load allowed transcript IDs
  	transcripts = parser.parse_transcripts(transcript_file_path)
  	
  	#Load blacklisted variants
  	unwanted_variants = parser.parse_unwanted_variants(unwanted_file_path)
  		
  	#Loop through variants 
  	variants.each do |this_variant|
  		selected = false
  		#Check if the transcript is correct
  		if transcripts.include?(this_variant.transcript)
  			if this_variant.is_unwanted_variant?(unwanted_variants) == false
					if ['DM', 'DM?', 'FTV'].include?(this_variant.hgmd_sub_category)
						# DP, DFP, FP, FTV, DM?, DM
						#1.	Select all HGMD variants marked as DM
						this_variant.reason_for_selection = "HGMD sub-category"
						selected_variants.push(this_variant)
						selected = true
					elsif this_variant.var_type == 'substitution' && this_variant.filter_vcf == 'PASS'
						#2.	Select substitutions that contain ‘PASS’ in Filter(VCF) field; select all indels
						
						if ['missense', 'nonsense', 'start loss', 'stop loss'].include?(this_variant.coding_effect)
							#3.	Select all coding non-synonymous variants
							this_variant.reason_for_selection = "Coding effect"
							selected_variants.push(this_variant)
							selected = true
						else
							if [-3..3].include?(this_variant.distance_nearest_splice_site)
								#This should also catch canonical splice site variants
								#4.	Select all synonymous variants within 3bp from splice site
								this_variant.reason_for_selection = "Distance to splice site"
								selected_variants.push(this_variant)
								selected = true
							elsif this_variant.nearest_splice_site_change && ( ((this_variant.nearest_splice_site_change != nil) || (this_variant.nearest_splice_site_change.empty? == false)) ) && (this_variant.nearest_splice_site_change != 0)
								#5.	Select all variants that have values in the ‘nearestSSChange’ or ‘localSpliceEffect’ fields
								this_variant.reason_for_selection = "Nearest splice site change"
								selected_variants.push(this_variant)
								selected = true
							elsif this_variant.local_splice_effect && ((this_variant.local_splice_effect != nil) || (this_variant.local_splice_effect.empty? == false))
								#Possible values: Cryptic Donor Strongly Activated, Cryptic Donor Weakly Activated, Cryptic Acceptor Strongly Activated, Cryptic Acceptor Weakly Activated, New Donor Site, New Acceptor Site
								this_variant.reason_for_selection = "Local splice effect"
								selected_variants.push(this_variant)
								selected = true
							elsif ['upstream', '5\'UTR', '3\'UTR', 'downstream'].include?(this_variant.var_location)
							#upstream, 5'UTR, exon, intron, 3'UTR, downstream
							#6.	Select all variants with 'varLocation' of '3_UTR', '5_UTR', 'Upstream' and 'Downstream'
								this_variant.reason_for_selection = "Variant location"
								selected_variants.push(this_variant)
								selected = true
							end # Rest of selectors
							
						end # coding_effect
						
						
					elsif this_variant.var_type != 'substitution'
						#2. Select all Indels : var_type = ['duplication', 'insertion', 'deletion', 'delins']
						#7.	Select all unannotated variants as these will be in specifically selected non-coding ROIs known to contain pathogenic mutations
						this_variant.reason_for_selection = "Indel"
						selected_variants.push(this_variant)
						selected = true
					end # HGMD sub-cat / var_type
  			end # Unwanted_variants
  			
  		end
  		if selected == false
  			not_selected_variants.push(this_variant)
  		end
  	
  	end
  	
  		#puts "SELECTED"
  		#puts selected_variants.inspect
  		#puts selected_variants.length
  		#puts "========="
  		#puts "NOT_SELECTED"
  		#puts not_selected_variants.inspect
  		#puts not_selected_variants.length
  		#puts "========="
  	
  	
  	sample_store = Hash.new
  	sample_store["#{sample_id}"] = [selected_variants, not_selected_variants]
  	sample_store_array = phenotype_store["#{phenotype}"]
  	sample_store_array.push(sample_store)
  	phenotype_store["#{phenotype}"] = sample_store_array
  
  end#samples loop
  
  
  this_book = Spreadsheet::Workbook.new
  phenotype_store.each_pair do |this_phenotype, this_sample_store|
  	
  	this_sheet = this_book.create_worksheet :name => "#{this_phenotype}"
  	
  	row_number = 0
  	
  	puts "Number of samples with #{this_phenotype} phenotype :: #{this_sample_store.length}"
  	
  	this_sample_store.each do |samples|
  			samples.each_pair do |this_sample_id, this_variant_array|
  				header_array = Array.new
  				this_sheet.row(row_number).push "SAMPLE ::", this_sample_id
  				row_number = row_number + 1
  				
  				this_variant_array[0].each do |this_selected_variant|
  					if header_array.empty?
  						header_array = this_selected_variant.instance_variables
  						header_array.map!{ |element| element.to_s.gsub(/@/, '') }
  						
  						header_array.each do |this_header|
  							  this_sheet.row(row_number).push this_header  
  						end
  					end
  					row_number = row_number + 1
  					
  					this_selected_variant.instance_variables.map {|var|  this_sheet.row(row_number).push  "#{this_selected_variant.instance_variable_get(var)}" }
  					
  				end
  				row_number = row_number + 2
  				
  			end
  	end
  	
  	this_book.write "#{base_path}/#{batch_id}/results/#{batch_id}_variants.xls"
  	puts "Finished #{this_phenotype}"
	end
	
	
  
end#end AlamutParser class
