File.open('returns', 'r') do |f|
  puts "Preparing to download..."
  f.each.with_index do |url, index|
    puts "Downloading #{url}..."
    `wget -O output#{index} \"#{url}\"`
  end
end
