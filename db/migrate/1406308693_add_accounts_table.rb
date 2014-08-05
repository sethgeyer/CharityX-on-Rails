class AddAccountsTable < ActiveRecord::Migration
  def up
    create_table :accounts do |t|
      t.string :amount
      t.integer :user_id
    end
  end

  def down
    drop_table :accounts
  end
end
