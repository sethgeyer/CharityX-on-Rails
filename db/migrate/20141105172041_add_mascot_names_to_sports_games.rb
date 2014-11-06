class AddMascotNamesToSportsGames < ActiveRecord::Migration
  def change
    rename_column :sports_games, :nfl_week, :week
    add_column :sports_games, :full_home_name, :string
    add_column :sports_games, :full_visitor_name, :string
  end
end
