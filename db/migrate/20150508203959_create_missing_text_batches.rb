class CreateMissingTextBatches < ActiveRecord::Migration
  def change
    create_table :missing_text_batches do |t|

      t.timestamps
    end
  end
end
