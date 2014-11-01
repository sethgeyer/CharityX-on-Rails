class AddWagerTypeToWagers < ActiveRecord::Migration
  def change
    add_column :wagers, :wager_type, :string
  end
end
