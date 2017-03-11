class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items, id: :bigint do |t|
      t.integer :item_type_id, null: false
      t.string :name, null: false
      t.string :description, limit: 1024
      t.integer :country_id
      t.string :state_city
      t.string :street
      t.decimal :latitude,  precision: 11, scale: 8
      t.decimal :longitude, precision: 11, scale: 8
      t.integer :from_at, limit: 8
      t.integer :to_at, limit: 8
      t.integer :created_by, limit: 8
      t.integer :updated_by, limit: 8
      t.timestamps null: false
      t.datetime :deleted_at
    end

    add_index :items, :item_type_id
    add_index :items, :country_id
    add_index :items, :created_by
    add_index :items, :updated_by

    add_foreign_key :items, :item_types, column: :item_type_id
    add_foreign_key :items, :countries, column: :country_id
    add_foreign_key :items, :users, column: :created_by
    add_foreign_key :items, :users, column: :updated_by
  end
end
