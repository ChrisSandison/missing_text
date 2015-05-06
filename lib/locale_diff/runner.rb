module LocaleDiff
  class Runner

    def self.run
      # start at the root folder and begin performing the diff operation on all inner locale directories

      Dir.glob("#{LocaleDiff.app_root}/#{LocaleDiff.locale_root}*").select{ |file| File.directory?(file)}.each do |directory|
        
        unless self.skip_directories.include?(directory)
          # Get a set of locale files and begin performing the diff operation on them
          locales = Dir.glob("#{directory}/*")
          # run the diff on this directory
        end
      end

      # then loop through every sub directory and do the same thing
    end

    def self.skip_directories
      [".", ".."] + LocaleDiff.skip_directories
    end

  end
end