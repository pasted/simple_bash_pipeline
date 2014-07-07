#Script to retrieve Alamut annotation on a transcript by transcript basis when using the --alltrans flag in Alamut-HT
#transcript_list.txt contains the transcripts to be written out to file.
class TranscriptParser

		attr_accessor :input_file_name, :output_file_name, :sample_id, :transcripts_file_name, :batch_id, :base_path, :variants_dir		
		attr_accessor :phenotype
		
		def set_directories(base_path, variants_dir)
				self.base_path = base_path
				self.variants_dir = variants_dir
		end
		
		def set_input_file_name(batch_id, sample_id, phenotype)
			self.batch_id ||= batch_id
			self.sample_id ||= sample_id
			self.phenotype ||= phenotype
			if (self.batch_id != nil) && (self.sample_id != nil) && (self.phenotype != nil)
				self.input_file_name = "#{self.base_path}/#{batch_id}/#{self.variants_dir}/#{batch_id}_#{sample_id}_#{phenotype}.alamut.alltrans.txt"
			else
				raise ArgumentError "Missing sample information for Input file name: batch_id, sample_id or phenotype"
			end
		end
		
		def set_output_file_name(batch_id, sample_id, phenotype)
			self.batch_id ||= batch_id
			self.sample_id ||= sample_id
			self.phenotype ||= phenotype
			if (self.batch_id != nil) && (self.sample_id != nil) && (self.phenotype != nil)
				self.output_file_name = "#{self.base_path}/#{batch_id}/#{self.variants_dir}/#{batch_id}_#{sample_id}_#{phenotype}.alamut.selected.txt"
			else
				raise ArgumentError "Missing sample information for Output file name: batch_id, sample_id or phenotype"
			end
		end
		
		def set_file_names(batch_id, sample_id, phenotype, transcripts_file_name)
			self.set_input_file_name(batch_id, sample_id, phenotype)
			self.set_output_file_name(batch_id, sample_id, phenotype)
			self.transcripts_file_name = transcripts_file_name
		end
		
		def select_header
					self.batch_id ||= "P5_385-432"
					self.base_path ||= "/mnt/Data1/targeted_sequencing"
					self.variants_dir ||= "variants/haplotyper"
						
					output_file = File.open(self.output_file_name, "w+")
					
					File.readlines(self.transcripts_file_name).each do |this_transcript|
						this_transcript.strip!
					
						File.readlines(self.input_file_name).each do |line|
							if line =~ /#id/
									output_file.puts(line)
							end
						end
						
					end
				
					output_file.close
		end
		
		def select_transcripts
					self.batch_id ||= "P5_385-432"
					self.base_path ||= "/mnt/Data4/"
					self.variants_dir ||= "variants/haplotyper"
						
					output_file = File.open(self.output_file_name, "w+")
					
					File.readlines(self.transcripts_file_name).each do |this_transcript|
						this_transcript.strip!
					
						File.readlines(self.input_file_name).each do |line|
							if line =~ /#{this_transcript}/
									output_file.puts(line)
							end
						end
						
					end
				
					output_file.close
		end

end

batch_id = "P5_385-432"
transcripts_file_name = "/mnt/Data1/targeted_sequencing/v5_transcript_list.txt"
ndm_batch = ["389", "390", "391", "393", "395", "397", "398", "399", "408", "411", "413", "415", "417", "420", "421", "423", "425"]
mody_batch = ["385", "386", "387", "388", "392", "396", "400", "401", "402", "403", "404", "405", "406", "407", "409", "410", "412", "414", "416", "418", "419", "422", "424", "426", "427", "428", "429", "430", "431", "432"]
hi_batch = []
ndm_mody_batch = ["394"]
phenotype = ""
batch = Array.new

case ARGV[0]
			when "-ndm"
				puts "Calling variants for samples with NDM phenotype." 
				phenotype = "NDM"
				batch = ndm_batch	
			when "-mody"
			  puts "Calling variants for samples with MODY phenotype."
				phenotype = "MODY"
				batch = mody_batch
			when "-hi"
				puts "Calling variants for samples with HI phenotype."
				phenotype="HI"
				batch = hi_batch
			when "-ndm_mody"
				puts "Calling variants for samples with NDM_MODY phenotype."
				phenotype="NDM_MODY"
				batch = ndm_mody_batch
			else
				puts "Please provide a phenotype (-ndm, -mody, -hi, -ndm_mody)"
end

batch.each do |sample_id|

	ts = TranscriptParser.new
	ts.set_directories("/mnt/Data4/", "variants/haplotyper")
	ts.set_file_names(batch_id, sample_id, phenotype, transcripts_file_name)
	ts.select_header
	ts.select_transcripts
	puts ts.inspect
	
end
