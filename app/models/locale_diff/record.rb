module LocaleDiff
  class Record < ActiveRecord::Base
    has_many :locale_diff_entries
    belongs_to :locale_diff_batch

    serialize :files, Array
  end
end
