module MissingText
  class Warning < ActiveRecord::Base

    belongs_to :missing_text_warning

    STRICT_REGEX = "strict_regex"
    YAML_PARSE = "yaml_parse"
    RB_PARSE = "rb_parse"
    FILE_TYPE_ERROR = "file_type"

    MESSAGES = {
      "strict_regex" => "strict_regex_msg",
      "yaml_parse" => "yaml_parsing_error",
      "rb_parse" => "rb_parsing_error",
      "file_type" => "filetype_error"
    }

    def message
      self.send(MESSAGES[self.warning_type])
    end

    def strict_regex_msg
      "No files for parsing in #{self.filename}. If this directory is empty, you can add it to MissingText.skip_directories in config/initializers/missing_text.rb. Otherwise, please ensure that any regexes you are using for skip_patterns in the same file are not overly strict."
    end

    def yaml_parsing_error
      "Unable to open #{self.filename} as a .yml file. Please ensure that your file is valid and the extension matches the type."
    end

    def rb_parsing_error
      "Unable to open #{self.filename} as an .rb file. Please ensure that your file is valid and the extension matches the type."
    end

    def filetype_error
      "Unable to open #{self.filename} for parsing. Please ensure that file is a valid .yml or .rb file."
    end
  end
end
