class AddUserIdToDistributions < ActiveRecord::Migration
  def change
    add_column :distributions, :user_id, :integer
  end
end
