#!/usr/bin/env ruby
class CoverageParser
  require 'smarter_csv'
  require 'yaml'
  require 'spreadsheet'
  #require_relative 'coverage'
  #require_relative 'interval'
  require './coverage'
  require './interval'
  require './sample'
  require './metric'
  require 'active_support'
  require 'active_support/core_ext'
  
  def load_coverage(file_name, sample_id, coverage_cutoff)
  	#set options for smarter csv: tab-delimited
  	options = { :col_sep => "\t" }
  	
  	coverage_array = Array.new
  	coverage_depth = "depth_for_#{sample_id}".parameterize

  	this_coverage_cutoff = coverage_cutoff.to_i

  	SmarterCSV.process( file_name, options ) do |csv|
  
  	  if csv.first[coverage_depth.to_sym] < this_coverage_cutoff
  		  this_coverage_line = Coverage.new
  		  this_coverage_line.locus = csv.first[:locus]
  		  this_coverage_line.coverage_depth = csv.first[coverage_depth.to_sym]
  		  this_coverage_line.parse_locus()
  		
  		  coverage_array.push(this_coverage_line)
  	  end
  	end
  	return coverage_array
  end
  
  def load_intervals(interval_file_name)
  	options = { :col_sep => "\t" }
  	interval_array = Array.new
  	  
  	SmarterCSV.process( interval_file_name, options ) do |csv|
  		
  	  	this_interval_line = Interval.new
  	  	this_interval_line.chromosome = csv.first[:chromosome].to_s
  	  	
  	  	this_interval_line.genomic_start = csv.first[:genomic_start].to_s
  	  	this_interval_line.genomic_end = csv.first[:genomic_end].to_s
  	  	this_interval_line.strand = csv.first[:strand].to_s
  	  	this_interval_line.interval_name = csv.first[:interval_name].to_s
  	  	
  	  	interval_array.push(this_interval_line)
  	end
  	return interval_array 
  end
  
  def parse_intervals(coverage_array, interval_array)
  	completed_coverage_array = Array.new
  	interval_array.each do |this_interval|
  	  coverage_array.each do |this_coverage|
  	  	if (this_coverage.chromosome == this_interval.chromosome) && (this_coverage.genomic_coords.to_i >= this_interval.genomic_start.to_i) && (this_coverage.genomic_coords.to_i <= this_interval.genomic_end.to_i)
  	  		this_coverage.interval_name = this_interval.interval_name
  	  		completed_coverage_array.push(this_coverage)
  	  		#coverage_array.delete(this_coverage)
  	  	end	  
  	  end
  	  #interval_array.delete(this_interval)
  	end
  	return completed_coverage_array
  end
  
  def parse_sample_list(sample_file_path)
  	options = { :col_sep => "," }
  	sample_array = Array.new
  	
  	SmarterCSV.process( sample_file_path, options ) do |csv|
  		this_sample = Sample.new
  		this_sample.capture_number 	= csv.first[:capture_number]
  		this_sample.mody_number		= csv.first[:mody_number]
  		this_sample.ex_number		= csv.first[:ex_number]
  		this_sample.gender		= csv.first[:gender]
  		this_sample.analysis_type	= csv.first[:analysis]
  		this_sample.geneset		= csv.first[:disease]
  		this_sample.sample_type		= csv.first[:sample_type]
  		this_sample.comment		= csv.first[:comment]
  		this_sample.parse_sample_id
  		
  		sample_array.push(this_sample)

  	end
  	
  	return sample_array
  end
  
  def parse_metrics(metrics_file_path)
  	options = { :col_sep => "\t" }
  	metrics_array = Array.new
  	
  	SmarterCSV.process( metrics_file_path, options ) do |csv|
  		this_metric = Metric.new
  		this_metric.bait_set 										= csv.first[:bait_set]
  		this_metric.genome_size 								= csv.first[:genome_size]
  		this_metric.bait_territory 							= csv.first[:bait_territory]
  		this_metric.target_territory 						= csv.first[:target_territory]
  		this_metric.bait_design_efficiency 			= csv.first[:bait_design_efficiency]
  		this_metric.total_reads 								= csv.first[:total_reads]
  		this_metric.pf_reads 										= csv.first[:pf_reads]
  		this_metric.pf_unique_reads 						= csv.first[:pf_unique_reads]
  		this_metric.pct_pf_reads 								= csv.first[:pct_pf_reads]
  		this_metric.pct_pf_uq_reads 						= csv.first[:pct_pf_uq_reads]
  		this_metric.pf_uq_reads_aligned 				= csv.first[:pf_uq_reads_aligned]
  		this_metric.pct_pf_uq_reads_aligned 		= csv.first[:pct_pf_uq_reads_aligned]
  		this_metric.pf_uq_bases_aligned 				= csv.first[:pf_uq_bases_aligned]
  		this_metric.on_bait_bases 							= csv.first[:on_bait_bases]
  		this_metric.near_bait_bases 						= csv.first[:near_bait_bases]
  		this_metric.off_bait_bases 							= csv.first[:off_bait_bases]
  		this_metric.on_target_bases 						= csv.first[:on_target_bases]
  		this_metric.pct_selected_bases 					= csv.first[:pct_selected_bases]
  		this_metric.pct_off_bait 								= csv.first[:pct_off_bait]
  		this_metric.on_bait_vs_selected 				= csv.first[:on_bait_vs_selected]
  		this_metric.mean_bait_coverage 					= csv.first[:mean_bait_coverage]
  		this_metric.mean_target_coverage 				= csv.first[:mean_target_coverage]
  		this_metric.pct_usable_bases_on_bait		= csv.first[:pct_usable_bases_on_bait]
  		this_metric.pct_usable_bases_on_target 	= csv.first[:pct_usable_bases_on_target]
  		this_metric.fold_enrichment							= csv.first[:fold_enrichment]
  		this_metric.zero_cvg_targets_pct 				= csv.first[:zero_cvg_targets_pct]
  		this_metric.fold_80_base_penalty 				= csv.first[:fold_80_base_penalty]
  		this_metric.pct_target_bases_2x 				= csv.first[:pct_target_bases_2x]
  		this_metric.pct_target_bases_10x 				= csv.first[:pct_target_bases_10x]
  		this_metric.pct_target_bases_20x 				= csv.first[:pct_target_bases_20x]
  		this_metric.pct_target_bases_30x 				= csv.first[:pct_target_bases_30x]
  		this_metric.pct_target_bases_40x 				= csv.first[:pct_target_bases_40x]
  		this_metric.pct_target_bases_50x 				= csv.first[:pct_target_bases_50x]
  		this_metric.pct_target_bases_100x 			= csv.first[:pct_target_bases_100x]
  		this_metric.hs_penalty_10x 							= csv.first[:hs_penalty_10x]
  		this_metric.hs_penalty_20x 							= csv.first[:hs_penalty_20x]
  		this_metric.hs_penalty_30x 							= csv.first[:hs_penalty_30x]
  		this_metric.hs_penalty_40x 							= csv.first[:hs_penalty_40x]
  		this_metric.hs_penalty_50x 							= csv.first[:hs_penalty_50x]
  		this_metric.hs_penalty_100x 						= csv.first[:hs_penalty_100x]
  		this_metric.at_dropout 									= csv.first[:at_dropout]
  		this_metric.gc_dropout 									= csv.first[:gc_dropout]
  		this_metric.sample_id										= csv.first[:sample]
  		
  		metrics_array.push(this_metric)

  	end

  	return metrics_array

	end
	
	def write_metrics_worksheet(metrics_array, this_book, worksheet_name)
		this_sheet = this_book.create_worksheet :name => "#{worksheet_name}"
		
		row_number = 0
		header_array = metrics_array.first.instance_variables
  	tmp_header_array = header_array.map{ |element| element.to_s.gsub(/@/, '') }
  						
  	tmp_header_array.each do |this_header|
  		this_sheet.row(row_number).push this_header  
  	end
  	
  	row_number = row_number + 1
		metrics_array.each do |this_metric|
			header_array.each do |this_variable|				
				this_sheet.row(row_number).push "#{this_metric.instance_variable_get(this_variable)}"
			end
			row_number = row_number + 1
		end

		return this_book
	end
	
	
	def write_sample_worksheet(this_sample, this_book, config)
		
			batch_id 							= config["batch_id"]
  		base_path 						= config["base_path"]
  		variants_directory		= config["variants_directory"]
  		transcript_file_path 	= config["transcript_file_path"]
  		sample_list_path 			= config["sample_list_path"]
  		intervals_directory		=	config["intervals_directory"]
  		panel_id 							= config["panel_id"]
  		coverage_cutoff 			= config["coverage_cutoff"]
  		
		  full_sample_id 		= this_sample.capture_number
  		phenotype					= this_sample.geneset
  		mody_id						= this_sample.mody_number
  		exeter_id					= this_sample.ex_number
  	
  		sample_id = full_sample_id.split('_')[2]
  		
  		puts "SAMPLE ID :: #{sample_id}"
  		
  		temp_sample_id = "#{panel_id.upcase}_#{sample_id}"
  		
  		this_sheet = this_book.create_worksheet :name => "#{temp_sample_id}_#{phenotype}"
  		
  		local_parser = CoverageParser.new()
  	
  		coverage_array = local_parser.load_coverage("#{base_path}/#{batch_id}/coverage/#{batch_id}_#{sample_id}.#{phenotype}_ROI.by_base_coverage", temp_sample_id, coverage_cutoff)
  		puts "Loaded coverage : #{coverage_array.length} records"
  		
  		interval_array = local_parser.load_intervals("#{intervals_directory}/v5_#{phenotype}_diagnostic_ROI.tsv")
  		puts "Loaded intervals : #{interval_array.length} records"
  		
  		if (coverage_array != nil) && (interval_array != nil)
  		  completed_coverage = local_parser.parse_intervals(coverage_array, interval_array)
  		  file_name = "#{base_path}/#{batch_id}/coverage/#{sample_id}_#{phenotype}_ROI.less_than_30_coverage"
  		  File.open(file_name, "w") do |this_file|
  		  	output_count = 0
  		  	row_count = 0
  		  	
  		  	interval_names_seen = Array.new
  		  	this_sheet.row(row_count).push "SAMPLE_NAME", "#{full_sample_id}"
  		  	row_count = row_count + 1
  		  	this_sheet.row(row_count).push "MODY_NUMBER", "#{mody_id}"
  		  	row_count = row_count + 1
  		  	this_sheet.row(row_count).push "EX_NUMBER", "#{exeter_id}"
  		  	row_count = row_count + 1
  		  	this_sheet.row(row_count).push "GENESET_ANALYSED", "#{phenotype}"
  		  	row_count = row_count + 1
  		  	this_sheet.row(row_count).push "MEAN_BAIT_COVERAGE", "#{this_sample.mean_bait_coverage}"
  		  	row_count = row_count + 1
  		  	this_sheet.row(row_count).push "PCT_TARGET_BASES_30X", "#{this_sample.pct_target_bases_30x}"
  		  	
  		  	row_count = row_count + 3
  		  	this_sheet.row(row_count).push "CHROMOSOME", "COORDINATE", "COVERAGE_DEPTH", "GENE_ANNOTATION"
  		  	row_count = row_count + 1
  		  	completed_coverage.each do |this_coverage|
  		  		#write out to coverage file
  		  		coverage_line = ["#{this_coverage.chromosome}", "#{this_coverage.genomic_coords}", "#{this_coverage.coverage_depth}", "#{this_coverage.interval_name}"].join("\t")
  		  		this_file.puts(coverage_line)
  		  		
  		  		#write out to spreadsheet
  		  		this_sheet.row(row_count).push "#{this_coverage.chromosome}", "#{this_coverage.genomic_coords}", "#{this_coverage.coverage_depth}", "#{this_coverage.interval_name}"
  		  		interval_names_seen.push(this_coverage.interval_name)
  		  		
  		  		row_count = row_count + 1
  		  		output_count = output_count + 1
  		  			
  		  	end
  		  	
  		  	row_count = 9
  		  	this_sheet.row(row_count).push "", "", "", "REGIONS WITH LESS THAN x30 COVERAGE"
  		  	row_count = row_count + 1
  		  	
  		  	interval_names_seen.uniq!
  		  	interval_names_seen.each do |this_interval_name|
  		  		this_sheet.row(row_count).push "", "", "", "#{this_interval_name}"
  		  		row_count = row_count + 1
  		  	end
  		  	
  		  	
  		  	puts "Finished writing to #{file_name}"
  		  	puts "#{output_count} completed coverage records written from #{coverage_array.length} original coverage records"
  		  end
  		else
  			puts "Error: coverage_array or interval_array returned as nil"
  		end
  		
  		local_parser = nil
  		return this_book
  		
  end
  
  if __FILE__ == $PROGRAM_NAME

  		#Load the config YAML file and pass the settings to local variables
 			config = YAML.load_file('../configuration/config.yaml')
  		
  		batch_id 							= config["batch_id"]
  		base_path 						= config["base_path"]
  		sample_list_path 			= config["sample_list_path"]
  		
  		metrics_file_path = "#{base_path}/#{batch_id}/metrics/#{batch_id}_final.bait_capture_metrics"
  		
  		#Init CoverageParser class
  		parser = CoverageParser.new()
  		
  		#load the overall metrics
  		metrics_array = parser.parse_metrics(metrics_file_path)
  		
  		samples = parser.parse_sample_list(sample_list_path)
  		
  		this_book = Spreadsheet::Workbook.new
  		
  		this_book = parser.write_metrics_worksheet(metrics_array, this_book, "Batch metrics")
  		
  		genesets = samples.collect { |this_sample| this_sample.geneset }
  		genesets.uniq!
  		
  		genesets.each do |this_geneset|
  			phenotype_metric_file_path = "#{base_path}/#{batch_id}/metrics/#{batch_id}_final.#{this_geneset}_ROI_capture_metrics"
  			
  			geneset_metrics_array = parser.parse_metrics(phenotype_metric_file_path)

  			this_book = parser.write_metrics_worksheet(geneset_metrics_array, this_book, "#{this_geneset}")
  			
  			samples.each do |this_sample|
  				this_sample.add_metrics(geneset_metrics_array)
  			end
  		end
  		
  		samples.each do |this_sample|
  			this_book = parser.write_sample_worksheet(this_sample, this_book, config)
  		end
  		
  		this_book.write "#{base_path}/#{batch_id}/results/#{batch_id}_coverage.xls"
  
	end
  
end
