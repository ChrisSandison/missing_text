module MissingText

  class Writer

    attr_accessor :languages, :langmap, :diffmap, :files, :hashes, :parent_dir, :batch_id

    def initialize(options = {})
      options.each do |key, value|
        self.send("#{key}=", value)
      end
      self.batch_id = MissingText::Batch.last.id
    end

    def write
      @record = write_record
      write_entries(@record)
    end

    def write_record
      record = Record.create(
        parent_dir: self.parent_dir,
        files: self.files,
        missing_text_batch_id: self.batch_id
        )
      record
    end

    def write_entries(record)
      languages.each do |lang|
        # for each language, get the entries from the diffmap where lang is the base language
        lang_entries = diffmap.select{|k, v| k.first == lang }

        # so now we have all entires that specify the target language. That is to say, comparator will be [:lang1, :lang2] where all entries in items are in lang1 but not in lang2
        # we need to find out all the languages that the item for lang1 is missing in and write that to the db
        entry_map = {}
        lang_entries.each do |comparator, items|
          target_language = comparator.last

          items.each do |item|
            if entry_map.has_key?(item)
              entry_map[item] << target_language
            else
              entry_map[item] = [target_language]
            end
          end

        end

        # There doesn't seem to be an efficient way to do this in one giant update... if anybody knows of another way please let me know!
        MissingText::Entry.transaction{
          MissingText::Entry.create(entry_map.map do |entry, target_languages|
              {missing_text_records_id: @record.id,
                locale_code: entry.join("."),
                base_language: lang.to_s,
                base_string: get_entry_for(entry, lang),
                target_languages: target_languages}
            end)
        }
      end
    end

    # Takes in a locale code and returns the string for that language
    def get_entry_for(entry, language)
      if entry.length > 1
        entry_string = get_entry_for_rec(entry[1..-1], language, hashes[language][entry[0]])
      else
        entry_string = hashes[language][entry[0]]
      end

      if entry_string.kind_of?(Array)
        entry_string = entry_string.map(&:inspect).join(', ')
      end
      entry_string
    end

    def get_entry_for_rec(entry, language, subhash)
      if entry.length > 1
        get_entry_for_rec(entry[1..-1], language, subhash[entry[0]])
      else
        subhash[entry[0]]
      end
    end

  end
end