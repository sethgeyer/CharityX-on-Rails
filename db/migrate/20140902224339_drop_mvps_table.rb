class DropMvpsTable < ActiveRecord::Migration
  def change
    drop_table :mvps
  end
end
