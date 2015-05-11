module LocaleDiff
  class Entry < ActiveRecord::Base
    belongs_to :locale_diff_record

    serialize :target_languages, Array

  end
end
