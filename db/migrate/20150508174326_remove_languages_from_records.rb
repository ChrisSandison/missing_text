class RemoveLanguagesFromRecords < ActiveRecord::Migration
  def change
    remove_column :missing_text_records, :languages
  end
end
