class SportsGamesController < ApplicationController

  before_action :ensure_admin

  def create
    game_count = SportsDataCollector.all
    flash[:notice] = "#{game_count} NFL Games have been created"
    redirect_to root_path
  end


end