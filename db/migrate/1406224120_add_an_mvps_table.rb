class AddAnMvpsTable < ActiveRecord::Migration
  def up
    create_table :mvps do |t|
      t.date :date
      t.string :description
    end
  end

  def down
    drop_table :mvps
  end
end
