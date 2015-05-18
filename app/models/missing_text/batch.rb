module MissingText
  class Batch < ActiveRecord::Base

    has_many :missing_text_records
    has_many :missing_text_warnings

    def self.history_options(batch)
      MissingText::Batch.where("id != ?", batch.id).order('created_at DESC')
    end

    def created_time
      self.created_at.strftime('%b %e, %Y at %H:%M:%S')
    end
  end
end
