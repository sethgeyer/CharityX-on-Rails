class AddProposedWagersTable < ActiveRecord::Migration
  def up
    create_table :proposed_wagers do |t|
      t.integer :account_id
      t.string  :title
      t.date    :date_of_wager
      t.string  :details
      t.integer :amount
      t.integer :wageree_id
    end
  end

  def down
    drop_table :proposed_wagers
  end
end
