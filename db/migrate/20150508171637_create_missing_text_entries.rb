class CreateMissingTextEntries < ActiveRecord::Migration
  def change
    create_table :missing_text_entries do |t|
      t.references :missing_text_records
      t.string :base_language
      t.string :base_string
      t.text :target_languages
      t.string :locale_code
      t.timestamps
    end
  end
end
