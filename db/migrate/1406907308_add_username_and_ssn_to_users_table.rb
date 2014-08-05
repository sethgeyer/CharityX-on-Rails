class AddUsernameAndSsnToUsersTable < ActiveRecord::Migration
  def up
    add_column :users, :username, :string
    add_column :users, :ssn, :integer
  end

  def down
    remove_column :users, :username
    remove_column :users, :ssn
  end
end
