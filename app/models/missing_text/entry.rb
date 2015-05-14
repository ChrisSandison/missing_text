module MissingText
  class Entry < ActiveRecord::Base
    belongs_to :missing_text_record

    serialize :target_languages, Array

  end
end
