class AddUserIdToChips < ActiveRecord::Migration
  def change
    add_column :chips, :user_id, :integer
  end
end
