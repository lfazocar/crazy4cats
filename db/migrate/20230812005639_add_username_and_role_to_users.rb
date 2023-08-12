class AddUsernameAndRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :username, :string, null: false
    add_column :users, :role, :integer, default:0
    add_index :users, :username, unique: true, name: "index_users_on_username"
  end
end
