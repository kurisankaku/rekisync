class AddBirthdayAccessScopeIdToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :birthday_access_scope_id, :integer, null: false
    add_index :profiles, :birthday_access_scope_id
    add_foreign_key :profiles, :access_scopes, column: :birthday_access_scope_id
  end
end
