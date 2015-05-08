module LocaleDiff
  class Batch < ActiveRecord::Base

    has_many :locale_diff_records
  end
end
