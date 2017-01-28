class CreateFollowings < ActiveRecord::Migration[5.0]
  def change
    create_table :followings, id: :bigint do |t|
      t.integer :owner_id, limit: 8, null: false
      t.integer :user_id, limit: 8, null: false
      t.timestamps null: false
      t.datetime :deleted_at
    end

    add_index :followings, [:owner_id, :user_id], unique: true
    add_index :followings, :deleted_at
    add_foreign_key :followings, :users, column: :user_id
    add_foreign_key :followings, :users, column: :owner_id
  end
end
