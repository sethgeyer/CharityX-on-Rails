class WagerViewPreferencesController < ApplicationController
  def create

    wager_view_preference = WagerViewPreference.new
    wager_view_preference.user_id = kenny_loggins.id
    wager_view_preference.wager_id = params[:wager_id]
    wager_view_preference.show = false
    wager_view_preference.save!
    render nothing: true
  end

  def destroy

  end
end