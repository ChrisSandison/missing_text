module LocaleDiff
  class Batch < ActiveRecord::Base

    has_many :locale_diff_records

    def ask_for_refresh?
      LocaleDiff::Batch.count >= 1
    end

    def self.history_options(batch)
      LocaleDiff::Batch.where("created_at < ?", batch.created_at)
    end
  end
end
