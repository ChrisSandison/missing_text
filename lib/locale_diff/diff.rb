require 'pry'

module LocaleDiff

  def symbolize_keys_nested!(hash) 
    hash.symbolize_keys!
    hash.values.each { |value| symbolize_keys_nested!(value) if value.is_a? Hash}
    hash
  end
  
  class Diff

     LANGUAGES = {
      en: "English",
      fr: "Francais"
    }

    attr_accessor :hashes, :languages, :langmap, :diffmap, :content_map, :files

    # when options contains mapped language codes to their respective yml files
    # it loads all languages for the diff into the object and sets up all hashes
    # after this is called, call process() in order to begin entire operation
    # options is a hash such as
    # {
    #   en: ...en.yml
    #   fr: ...fr.yml
    #   ...
    # }
    # for now, it takes a path relative to config/locales/... but this will be upgraded
    # later to take directories

    def setup!
      self.hashes = {}
      self.languages = []
      self.diffmap = {}
      self.content_map = {}
      self.files = []
    end

    alias_method :clear!, :setup!

    def initialize(options = {})
      setup!
      options.each do |lang, yml|
        languages << lang
        # file = symbolize_keys_nested!(YAML.load_file("config/locales/#{yml}"))
        # files << yml.gsub(/.yml/, '')[-2..-1]
        # file.each do |_, body|
        #   hashes[lang] = body
        # end
      end
    end

    def rummage!
      "Finished!"
    end

  end
end