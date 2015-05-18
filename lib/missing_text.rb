require "missing_text/engine"
require "missing_text/diff"

module MissingText

  # These are needed for the initializer
  mattr_accessor :app_root, :locale_root, :skip_directories, :search_direct_locale, :skip_patterns

end
