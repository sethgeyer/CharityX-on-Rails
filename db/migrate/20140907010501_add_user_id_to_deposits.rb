class AddUserIdToDeposits < ActiveRecord::Migration
  def change
    add_column :deposits, :user_id, :integer
  end
end
