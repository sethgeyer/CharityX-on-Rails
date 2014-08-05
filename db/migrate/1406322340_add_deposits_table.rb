class AddDepositsTable < ActiveRecord::Migration
  def up
    create_table :deposits do |t|
      t.integer :account_id
      t.integer :amount
      t.integer :cc_number
      t.date    :exp_date
      t.string  :name_on_card
      t.string  :cc_type
      t.date    :date_created
    end
  end

  def down
    drop_table :deposits
  end
end
