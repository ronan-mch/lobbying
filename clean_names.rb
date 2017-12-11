require 'csv'
require 'set'
require 'byebug'
require './cleaner.rb'
require 'active_support/inflector'

@name_dedups = Set.new
dpos = Set.new

def name_encountered?(dedup_name)
  if @name_dedups.include?(dedup_name)
    true
  else
    @name_dedups << dedup_name
    false
  end
end

CSV.foreach('dpos') do |row|
  name = row[0]
  label = row[1]
  if label.nil?
    label = ''
    role = ''
  else
    parts = label.split('|')
    role = parts.shift
    label = parts.join('|')
  end
  dedup_name = Cleaner.normalise(name)
  if name_encountered?(dedup_name)
    next
  else
    dpos << [dedup_name, name, role, label]
  end
end
CSV.open('cleaned_names.csv', 'wb') do |f|
  f << ['Normalised', 'Name', 'Role', 'Label']
  dpos.each do |dpo|
    f << dpo
  end
end
