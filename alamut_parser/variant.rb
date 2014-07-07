class Variant

	  attr_accessor :id, :unannotated_reason, :gene, :chromosome, :position, :gene_symbol, :genotype, :transcript, :strand
		attr_accessor :transcript_length, :protein, :uniprot, :var_type, :coding_effect, :var_location
		attr_accessor :assembly, :genomic_dna_start, :genomic_dna_end, :genomic_nomen
		attr_accessor :complementary_dna_start, :complementary_dna_end, :cdna_nomen
		attr_accessor :protein_nomen, :alt_protein_nomen, :exon, :intron, :omim_id
		attr_accessor :distance_nearest_splice_site, :nearest_splice_site_type
		attr_accessor :wt_ssf_score, :wt_max_ent_score, :wt_nns_score, :wt_gs_score, :wt_hsf_score, :var_ssf_score, :var_max_ent_score
		attr_accessor :var_nns_score, :var_gs_score, :var_hsf_score, :nearest_splice_site_change, :local_splice_effect
		attr_accessor :protein_domain_1, :protein_domain_2, :protein_domain_3, :protein_domain_4
		attr_accessor :rs_id, :rs_validated, :rs_suspect, :rs_validations, :rs_validation_number, :rs_ancestral_allele
		attr_accessor :rs_heterozygosity, :rs_clinical_significance, :rs_maf, :rs_maf_allele, :rs_maf_count
		attr_accessor :esp_ref_ea_count, :esp_ref_aa_count, :esp_ref_all_count, :esp_alt_ea_count, :esp_alt_aa_count
		attr_accessor :esp_alt_all_count, :esp_ea_maf, :esp_aa_maf, :esp_all_maf, :esp_eaaaf,	:esp_aaaaf, :esp_all_aaf, :esp_avg_read_depth
		attr_accessor :hgmd_id, :hgmd_phenotype, :hgmd_pub_med_id, :hgmd_sub_category
		attr_accessor :ins_nucs, :del_nucs, :subst_type, :wt_nuc, :var_nuc, :nuc_change, :phast_cons, :phylo_p
		attr_accessor :wt_aa_1, :wt_aa_3, :wt_codon, :wt_codon_freq, :var_aa_1, :var_aa_3, :var_codon, :var_codon_freq
		attr_accessor :pos_aa, :n_orthos, :conserved_orthos, :conserved_dist_species
		attr_accessor :blosum_45, :blosum_62, :blosum_80, :wt_aa_composition, :var_aa_composition, :wt_aa_polarity
		attr_accessor :var_aa_polarity, :wt_aa_volume, :var_aa_volume, :grantham_dist, :agv_gd_class, :agv_gd_gv, :agv_gd_gd
		attr_accessor :sift_prediction, :sift_weight, :sift_median, :mapp_prediction, :mapp_p_value, :mapp_p_value_median
		attr_accessor :quality_vcf, :filter_vcf
		attr_accessor :ac, :af, :an, :dp, :fs, :mq, :mq_0, :qd
		attr_accessor :ad, :dp, :gq, :gt, :pl
		attr_accessor :reason_for_selection

		def print_attributes
			attr_array = Array.new
			self.instance_variables.map do |var|
				attr_array.push(self.instance_variable_get(var))
  		end
  			return attr_array
		end
		

		def print_attributes_string
			attr_string = '"'
			self.instance_variables.map.with_index do |var, this_index|
				if this_index < self.instance_variables.length-1
					attr_string << self.instance_variable_get(var).to_s 
					attr_string << '", "'
				else
					attr_string << self.instance_variable_get(var).to_s 
					attr_string << '"'
			  end
  		end
  			return attr_string
		end
		
		def is_unwanted_variant?(unwanted_variant_array)
			unwanted_variant_array.each do |unwanted_variant|
				if (self.chromosome == unwanted_variant.chromosome) && (self.position == unwanted_variant.position)
					if (unwanted_variant.wt_nuc && (self.wt_nuc == unwanted_variant.wt_nuc) ) && (unwanted_variant.var_nuc && (self.var_nuc == unwanted_variant.var_nuc) )
						return true
					elsif (unwanted_variant.ins_nucs && (self.ins_nucs == unwanted_variant.ins_nucs) ) && (unwanted_variant.del_nucs && (self.del_nucs == unwanted_variant.del_nucs) )
						return true
					else
						return false
					end
				else
						return false
				end
			end
		end

end
