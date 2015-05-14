require "missing_text/engine"
require "missing_text/diff"

module MissingText

  mattr_accessor :app_root, :locale_root, :write_to_file, :output_file_path, :skip_directories, :search_direct_locale

end
