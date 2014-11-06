class AddWeekToSportsGamesOutcomes < ActiveRecord::Migration
  def change
    add_column :sports_games_outcomes, :week, :integer
  end
end
