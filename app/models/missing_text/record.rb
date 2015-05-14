module MissingText
  class Record < ActiveRecord::Base
    has_many :missing_text_entries
    belongs_to :missing_text_batch

    serialize :files, Array

    def entries
      MissingText::Entry.where(missing_text_records_id: self.id)
    end
  end
end
