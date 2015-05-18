class CreateMissingTextRecords < ActiveRecord::Migration
  def change
    create_table :missing_text_records do |t|
      t.string :parent_dir
      t.text :files
      t.timestamps
    end
  end
end
