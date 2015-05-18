class AddBatchReferenceToWarnings < ActiveRecord::Migration
  def change
    add_reference :missing_text_warnings, :missing_text_batch, index: true, foreign_key: true
  end
end
