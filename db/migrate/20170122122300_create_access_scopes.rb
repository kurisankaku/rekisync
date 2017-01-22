class CreateAccessScopes < ActiveRecord::Migration[5.0]
  def change
    create_table :access_scopes do |t|
      t.string :code, null: false, limit: 45
    end
  end
end
