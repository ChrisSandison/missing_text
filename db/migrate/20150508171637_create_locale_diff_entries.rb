class CreateLocaleDiffEntries < ActiveRecord::Migration
  def change
    create_table :locale_diff_entries do |t|
      t.references :locale_diff_records
      t.string :base_language
      t.string :base_string
      t.text :target_languages
      t.timestamps
    end
  end
end
