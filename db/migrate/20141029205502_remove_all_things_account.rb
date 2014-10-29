class RemoveAllThingsAccount < ActiveRecord::Migration

  def change
    drop_table :accounts
    remove_column :chips, :account_id, :integer
    remove_column :deposits, :account_id, :integer
    remove_column :distributions, :account_id, :integer
    remove_column :wagers, :account_id, :integer
  end

end
