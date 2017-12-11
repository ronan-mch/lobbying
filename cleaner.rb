class Cleaner
  # Create a latinised name with normalised spaces
  # to prevent false duplicates
  def self.normalise(text)
    ActiveSupport::Inflector.transliterate(text)
      .downcase
      .gsub("'", ' ')
      .gsub('  ', ' ')
      .gsub(/\t/, ' ')
  end
end
