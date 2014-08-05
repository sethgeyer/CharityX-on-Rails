class CreateUsersTable < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :profile_picture
    end

    add_index :users, :email, unique: true

  end

  def down
    drop_table :users
  end
end
