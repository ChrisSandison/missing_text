require "missing_text/engine"
require "missing_text/diff"

module MissingText

  mattr_accessor :app_root, :locale_root, :skip_directories, :search_direct_locale, :skip_patterns

end
