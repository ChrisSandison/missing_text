class CreateMissingTextWarnings < ActiveRecord::Migration
  def change
    create_table :missing_text_warnings do |t|
      t.string :filename
      t.string :warning_type
      t.timestamps
    end
  end
end
