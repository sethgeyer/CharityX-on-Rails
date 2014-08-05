class AddDistributionsTable < ActiveRecord::Migration
  def up
    create_table :distributions do |t|
      t.integer :account_id
      t.integer :amount
      t.string  :charity
    end
  end

  def down
    drop_table :distributions
  end
end
