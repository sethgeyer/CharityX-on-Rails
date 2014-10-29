class WagerViewPreferencesController < ApplicationController

  def create
    wager_view_preference = kenny_loggins.wager_view_preferences.new(wager_id: params[:wager_id], show: false)
    wager_view_preference.save!
    render nothing: true
  end

end