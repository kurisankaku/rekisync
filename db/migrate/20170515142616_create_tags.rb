class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags, id: :bigint do |t|
      t.string :name, null: false, limit: 64
      t.timestamps null: false
      t.datetime :deleted_at
    end

    add_index :tags, :name, unique: true
    add_index :tags, :deleted_at
  end
end
