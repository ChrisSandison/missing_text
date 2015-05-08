require 'pry'

module LocaleDiff

  class Diff

    class YamlParsingError < StandardError
    end

    class RbParsingError < StandardError
    end

    attr_accessor :hashes, :languages, :langmap, :diffmap, :files, :output, :parent_dir

    def setup!
      self.hashes = {}
      self.languages = []
      self.diffmap = {}
      self.files = []
    end

    alias_method :clear!, :setup!

    def initialize(options = [])
      setup!

      # save the name of the parent directory that we are operating on
      self.parent_dir = File.basename(File.expand_path("..", options[0][:path])) 

      options.each do |locale_file|

        # store all languages we are examining for this directory and the files we are examining
        languages << locale_file[:lang].try(:to_sym)
        files << locale_file
        parsed_locale = open_locale_file(locale_file)
        # TODO handle case where nothing is returned!
        if parsed_locale.present?
          locale_file[:parsed] = parsed_locale
          parsed_locale.each do |lang, body|
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
    # if there is nothing to detect, then just return
    return unless self.diffmap.present?
    
    # TODO: create record and begin adding entries to it

    # TODO: if initializer specifies it, write to output file

    File.open("output.txt", 'w') do |f|
      print_contents(f)
    end
  end

  def print_contents(file)
    # TODO files has changed
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

    def open_locale_file(file)
      if file[:type] == ".yml"
        open_yaml(file[:path])
      elsif file[:type] == ".rb"
        open_rb(file[:path])
      else
        raise LocaleDiff::FiletypeError(file), "Unable to open #{file} for parsing. Pleasure ensure file is .yml or .rb"
      end
    end

    def open_yaml(yml)
      begin
        file = symbolize_keys_nested!(YAML.load_file(yml))
        return file
      rescue => error
        raise YamlParsingError.new(yml), "Unable to parse YAML. Please verify it #{yml}"
      end
    end

    def open_rb(rb)
      begin
        file = symbolize_keys_nested!(eval(File.read(rb)))
        return {languages.last => file}
      rescue => error
        raise RbParsingError.new(rb), "Unable to parse .rb. Please verify #{rb}"
      end
    end

  end
end