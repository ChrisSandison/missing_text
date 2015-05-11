module LocaleDiff
  class Record < ActiveRecord::Base
    has_many :locale_diff_entries
    belongs_to :locale_diff_batch

    serialize :files, Array

    def entries
      LocaleDiff::Entry.where(locale_diff_records_id: self.id)
    end
  end
end
