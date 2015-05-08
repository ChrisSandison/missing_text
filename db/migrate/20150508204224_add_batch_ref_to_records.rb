class AddBatchRefToRecords < ActiveRecord::Migration
  def change
    add_reference :locale_diff_records, :locale_diff_batch, index: true, foreign_key: true
  end
end
