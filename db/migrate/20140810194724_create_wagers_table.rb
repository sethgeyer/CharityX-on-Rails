class CreateWagersTable < ActiveRecord::Migration
  def change
    create_table :wagers do |t|
      t.integer "account_id"
      t.string  "title"
      t.date    "date_of_wager"
      t.string  "details"
      t.integer "amount"
      t.integer "wageree_id"
      t.string  "status"
    end
  end
end
