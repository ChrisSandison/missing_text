module LocaleDiff
  class Record < ActiveRecord::Base
    has_many :locale_diff_entries


    serialize :files, Array
  end
end
