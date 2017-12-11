require 'csv'
require './cleaner'
require 'byebug'

CSV.foreach('combined_output.tsv', col_sep: "\t") do |line|
  id = line[0]
  lobbyist = line[2]
  dpos = line[8]
  byebug
end
