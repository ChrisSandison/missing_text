# The directory where all of the locale files live. An additional directory can be specified if your locales are in a location other than the default "config/locales/". This is a relative path and will be appended to Rails.root
LocaleDiff.locale_root = "config/locales/"

# All output records can be written to a text file.
# This is false by default
LocaleDiff.write_to_file = false

# The location where the output file will be saved.
# This will default to Rails root
LocaleDiff.output_file_path = ""

# Include any directories in locales/ that you would like to skip. By default this will be appended to "." and ".."
LocaleDiff.skip_directories = []