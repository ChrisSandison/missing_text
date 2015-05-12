module LocaleDiff
  class Batch < ActiveRecord::Base

    has_many :locale_diff_records

    def self.history_options(batch)
      LocaleDiff::Batch.where("created_at < ?", batch.created_at).order('created_at DESC')
    end
  end
end
