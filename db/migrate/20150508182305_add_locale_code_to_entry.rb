class AddLocaleCodeToEntry < ActiveRecord::Migration
  def change
    add_column :missing_text_entries, :locale_code, :string
  end
end
