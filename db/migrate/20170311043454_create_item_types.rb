class CreateItemTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :item_types do |t|
      t.string :code, null: false
      t.timestamps null: false
      t.datetime :deleted_at
    end
  end
end
