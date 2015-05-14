# The directory where all of the locale files live. An additional directory can be specified if your locales are in a location other than the default "config/locales/". This is a relative path and will be appended to Rails.root
LocaleDiff.locale_root = "config/locales/"

# Include any directories in locales/ that you would like to skip. By default this will be appended to "." and "..". Please make these paths relative to your locale_root
LocaleDiff.skip_directories = []

# Include the search of the locale root itself (e.g. config/locales) when looking for missing translations. This is true by default.
LocaleDiff.search_direct_locale = true