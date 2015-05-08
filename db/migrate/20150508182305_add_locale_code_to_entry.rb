class AddLocaleCodeToEntry < ActiveRecord::Migration
  def change
    add_column :locale_diff_entries, :locale_code, :string
  end
end
