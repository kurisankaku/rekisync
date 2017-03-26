class CreateHistoryCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :history_categories do |t|
      t.string :name, null: false, limit: 64
      t.integer :large_category_id
      t.integer :middle_category_id
      t.timestamps null: false
    end

    add_index :history_categories, :large_category_id
    add_index :history_categories, :middle_category_id
  end
end
