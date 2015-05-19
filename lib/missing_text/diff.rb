require 'missing_text/writer'
require 'pry'

module MissingText

  class Diff

    attr_accessor :hashes, :languages, :langmap, :diffmap, :files, :parent_dir, :writer, :current_batch_id

    def setup!
      self.hashes = {}
      self.languages = []
      self.diffmap = {}
      self.files = []
      self.current_batch_id = MissingText::Batch.last.id
    end

    alias_method :clear!, :setup!

    def initialize(options = [])
      setup!

      # save the name of the parent directory that we are operating on
      self.parent_dir = File.basename(File.expand_path("..", options[0][:path])) 

      options.each do |locale_file|

        # store all languages we are examining for this directory and the files we are examining
        
        parsed_locale = open_locale_file(locale_file)

        # if the file was unable to be parsed, it will be skipped. The warning for the file has already been logged, so the operation can continue
        if parsed_locale.present?

          languages << locale_file[:lang].try(:to_sym)
          files << locale_file

          parsed_locale.each do |lang, body|
            key = File.basename(files.last[:path], File.extname(files.last[:path])).to_sym
            hashes[key] = body
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
    print_missing_translations
  end

  #
  #
  # PRINT MISSING TRANSLATIONS
  #
  #
  #
  def print_missing_translations
    # if there is nothing to detect, then just return
    return unless self.diffmap.present?
    
    self.writer = MissingText::Writer.new({
      languages: self.languages,
      diffmap: self.diffmap,
      langmap: self.langmap,
      files: self.files,
      hashes: self.hashes,
      parent_dir: self.parent_dir
      })
    self.writer.write
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

      # check to make sure that we have an entry for this filename
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
        parsed_file = open_yaml(file[:path])
      elsif file[:type] == ".rb"
        parsed_file = open_rb(file[:path], file[:lang])
      else
        # Just incase something has slipped through, at least tell the user that it won't be processed.
        MissingText::Warning.create(
          filename: file[:path],
          warning_type: MissingText::Warning::FILE_TYPE_ERROR,
          missing_text_batch_id: self.current_batch_id
          )
        parsed_file = {}
      end
      parsed_file
    end

    def open_yaml(yml)
      begin
        file = symbolize_keys_nested!(YAML.load_file(yml))
      rescue => error
        MissingText::Warning.create(
          filename: yml,
          warning_type: MissingText::Warning::YAML_PARSE,
          missing_text_batch_id: self.current_batch_id
        )
        file = {}
      end
      file
    end

    def open_rb(rb, lang)
      # It seems like when rb files are parsed, it doesn't keep the parent key. Just in case, we will use the language of the file name as the parent key.
      begin
        file = symbolize_keys_nested!(eval(File.read(rb)))
        file = {lang.to_sym => file}
      rescue => error
        MissingText::Warning.create(
          filename: rb,
          warning_type: MissingText::Warning::RB_PARSE,
          missing_text_batch_id: self.current_batch_id
          )
        file = {}
      end
      file
    end

  end
end