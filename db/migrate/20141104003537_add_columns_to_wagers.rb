class AddColumnsToWagers < ActiveRecord::Migration
  def change
    change_column :wagers, :game_id, :string
    change_column :wagers, :selected_winner_id, :string
    add_column :wagers, :game_week, :integer
    add_column :wagers, :home_id, :string
    add_column :wagers, :vs_id, :string
  end
end
