class SportsGamesOutcomesController < ApplicationController

  before_action :ensure_admin


  def index

    wagered_sports_games = SportsGame.find_games_with_wagers
    SportsGamesOutcome.remove_incomplete_outcomes
    new_outcomes = SportsGamesOutcome.gather_game_outcome_updates(wagered_sports_games)
    flash[:notice] = "#{new_outcomes.count} game outcomes have been updated"
    redirect_to root_path

  end

end

