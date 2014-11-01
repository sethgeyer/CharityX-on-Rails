class AddGameIdAndSelectedWinnerIdToWagers < ActiveRecord::Migration
  def change
    add_column :wagers, :game_id, :integer
    add_column :wagers, :selected_winner_id, :integer

  end
end
