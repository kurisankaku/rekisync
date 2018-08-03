class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.integer :user_id, null: false, limit: 8
      t.string :name, null: false, limit: 128
      t.text :about_me
      t.integer :birthday_access_scope_id, null: false
      t.string :img_dir_prefix, null: false, limit: 8
      t.string :avator_image
      t.string :background_image
      t.datetime :birthday
      t.integer :country_id
      t.string :state_city
      t.string :street
      t.string :website, limit: 1024
      t.string :google_plus, limit: 1024
      t.string :facebook, limit: 1024
      t.string :twitter, limit: 1024
      t.integer :lock_version
      t.timestamps null: false
      t.datetime :deleted_at
    end

    add_index :profiles, :user_id, unique: true
    add_index :profiles, :birthday_access_scope_id
    add_index :profiles, :deleted_at
  end
end
