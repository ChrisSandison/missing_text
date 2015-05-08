class CreateLocaleDiffBatches < ActiveRecord::Migration
  def change
    create_table :locale_diff_batches do |t|

      t.timestamps
    end
  end
end
