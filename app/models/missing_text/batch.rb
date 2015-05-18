module MissingText
  class Batch < ActiveRecord::Base

    has_many :missing_text_records
    has_many :missing_text_warnings

    # every batch except this one
    def self.history_options(batch)
      MissingText::Batch.where("id != ?", batch.id).order('created_at DESC')
    end

    def created_time
      self.created_at.strftime('%b %e, %Y at %H:%M:%S')
    end

    def high_entry_count
      500
    end

    def entries
      MissingText::Entry.where("missing_text_records_id in (?)", MissingText::Record.where(missing_text_batch_id: self.id).pluck(:id))
    end

    def high_entry_count?
      entries.count >= high_entry_count
    end
  end
end
