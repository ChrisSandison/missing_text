class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :missing_text_entries, :missing_text_records_id
  end
end
