class AddUserIdToWagers < ActiveRecord::Migration
  def change
    add_column :wagers, :user_id, :integer
  end
end
