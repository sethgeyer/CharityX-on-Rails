class DropWagersTable < ActiveRecord::Migration
  def change
    drop_table :wagers
  end
end
