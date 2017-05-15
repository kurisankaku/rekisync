class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags, id: :bigint do |t|
      t.string :name, null: false, limit: 64
      t.timestamps null: false
    end

    add_index :tags, :name, unique: true
  end
end
