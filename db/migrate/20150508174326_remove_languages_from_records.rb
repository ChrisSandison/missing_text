class RemoveLanguagesFromRecords < ActiveRecord::Migration
  def change
    remove_column :locale_diff_records, :languages
  end
end
