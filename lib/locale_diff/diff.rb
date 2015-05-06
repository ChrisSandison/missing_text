require 'pry'

module LocaleDiff

  class Diff

    attr_accessor :output

    SKIP_FILES = %w(. ..)

    # TODO get all of these from initializer
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
        
        parsed_yaml = open_yaml(yml)

        # TODO: what if it's not?? Handle this case
        if parsed_yaml.present?
          files << yml.gsub(/\.yml/, '')[-2..-1]
          parsed_yaml.each do |_, body|
            hashes[lang] = body
          end
        end

      end
    end

     #
  #
  # Runner
  #
  #

  def begin!(options = {})
    create_langmap!
    create_diffmap!
    print_missing_translations!
  end

  #
  #
  # PRINT MISSING TRANSLATIONS
  #
  #
  #
  def print_missing_translations!
    File.open("output.txt", 'w') do |f|
      print_contents(f)
    end
  end

  def print_contents(file)
    file.puts("Creating translation file for #{self.files.join(", ")}\n\n")
    file.puts("----------------------------------------------------------")
    diffmap.each do |translation, map_array|
      file.puts("Translations for comparison of #{translation[0]} with #{translation[1]}. All entires are missing respective translations in #{translation[1]}\n\n")
      file.puts("----------------------------------------------------------")
      map_array.each do |entry|
        file.puts("#{get_entry_for(entry, translation[0])} (#{entry.join(".")})\n\n")
      end
      file.puts("\n\n")
    end
  end

  def get_entry_for(entry, language)
    if entry.length > 1
      get_entry_for_rec(entry[1..-1], language, hashes[language][entry[0]])
    else
      hashes[language][entry[0]]
    end
  end

  def get_entry_for_rec(entry, language, subhash)
    if entry.length > 1
      get_entry_for_rec(entry[1..-1], language, subhash[entry[0]])
    else
      subhash[entry[0]]
    end
  end

  #
  #
  # KEYMAP DIFFs
  #
  #

  def create_diffmap!
    # for each language, step through the other languages and find the diffs
    languages.each do |language|
      current_language = language

      # get all target languages we are examining
      target_languages = languages - [current_language]

      target_languages.each { |target_language| generate_diff_for_language(current_language, target_language) }
    end
  end

  # a diffmap shows what is missing between two languages
  # the key is a two-element array, the first element is the current language 
  # and the second element is the target language
  #
  # for example
  # diffmap: {[:en, :fr] => [[:obj3], ...]}
  #
  # means that fr was examined against en, where en had an entry for obj3 that fr didn't

  def generate_diff_for_language(current_language, target_language)
    current_langmap = langmap[current_language]
    target_langmap = langmap[target_language]
    diffmap_key = [current_language, target_language]
    diffmap[diffmap_key] = current_langmap - target_langmap
  end

  #
  #
  # KEYMAP CREATION
  #
  #

  # call this after initialize in order to begin parsing all files
  def create_langmap!
    self.langmap = {}
    languages.each do |lang|
      # initialize key paths for this language hash
      langmap[lang] = []
      # recursively build keymap
      make_keymap(langmap[lang], hashes[lang])
    end
  end

  # outer method for creating keymap on parent hash
  def make_keymap(langmap_entry, language)
    language.each do |key, value|
      if value.is_a? Hash
        make_keymap_for(langmap_entry, value, [key.to_sym])
      else
        langmap_entry << [key.to_sym]
      end
    end
  end

  # recursive helper for creating keymap on children hashes
  def make_keymap_for(langmap_entry, language, key_path)
    language.each do |key, value|
      # need a new value of this for every value we are looking at because we want all route traces to have single threading for when they are called again
      new_path = Array.new key_path
      if value.is_a? Hash
        make_keymap_for(langmap_entry, value, new_path.push(key.to_s.to_sym))
      else
        langmap_entry << new_path.push(key.to_s.to_sym)
      end
    end
  end

  def symbolize_keys_nested!(hash) 
    hash.symbolize_keys!
    hash.values.each { |value| symbolize_keys_nested!(value) if value.is_a?(Hash)}
    hash
  end

  private

    def open_yaml(yml)
      begin
        file = symbolize_keys_nested!(YAML.load_file("#{LocaleDiff.app_root}/#{LocaleDiff.locale_root}#{yml}"))
        return file
      rescue => error
        raise "Error parsing YAML: #{error}"
      end
    end

  end
end