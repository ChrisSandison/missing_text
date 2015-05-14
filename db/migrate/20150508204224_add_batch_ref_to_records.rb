class AddBatchRefToRecords < ActiveRecord::Migration
  def change
    add_reference :missing_text_records, :missing_text_batch, index: true, foreign_key: true
  end
end
