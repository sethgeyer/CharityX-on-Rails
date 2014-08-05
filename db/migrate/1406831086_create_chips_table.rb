class CreateChipsTable < ActiveRecord::Migration
  def up
    create_table :chips do |t|
      t.integer :account_id
      t.integer :owner_id
      t.string  :status
      t.string  :l1_tag_id
      t.string  :l2_tag_id
      t.integer :charity_id
      t.date    :purchase_date
      t.date    :cashed_in_date
      t.boolean :wagerable
    end
  end

  def down
    drop_table :chips
  end
end
