class CreateLocaleDiffRecords < ActiveRecord::Migration
  def change
    create_table :locale_diff_records do |t|
      t.string :parent_dir
      t.text :files
      t.text :languages
      t.timestamps
    end
  end
end
