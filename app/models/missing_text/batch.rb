module MissingText
  class Batch < ActiveRecord::Base

    has_many :missing_text_records

    def self.history_options(batch)
      MissingText::Batch.where("created_at < ?", batch.created_at).order('created_at DESC')
    end
  end
end
