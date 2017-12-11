require 'csv'
require 'set'
require 'byebug'
require './cleaner.rb'
require 'active_support/inflector'

normalised_set = Set.new
CSV.foreach('cleaned_names.csv', headers: true) do |row|
  normalised_set << row[0]
end
CSV.open('join_file.csv', 'wb') do |output|
  output << %w(ReportId DPO)
  CSV.foreach('for_table.csv', headers: true) do |row|

    id = row[0]
    dpos = row[8]
    next if dpos.nil?
    current_dpos = []
    dpos.split('::').each do |dpo|
      dpo_name = dpo.split('|').first
      norm_name = Cleaner.normalise(dpo_name)
      current_dpos << norm_name
    end
    # We take this extra step to prevent duplicate entries for individual reports
    current_dpos.uniq.each do |norm_dpo|
      next unless normalised_set.include?(norm_dpo)
      output << [id, norm_dpo]
    end
  end
end
