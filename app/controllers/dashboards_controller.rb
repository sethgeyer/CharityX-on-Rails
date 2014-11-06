class DashboardsController < ApplicationController

  def show

    #Not sure where this goes... it scrubs out the expired unaccepted wagers any time the dashboard is pulled
    Wager.all.each do |wager|
      if (wager.date_of_wager - Date.today).to_i < 0 && wager.status == "w/wageree"
        @wager = Wager.find(wager.id)
        @wager.status = "expired"
        if @wager.save!
          Chip.set_status_to_available(@wager.user.id, @wager.amount)
        end
      end
    end

    # current_users_wagers = (kenny_loggins.wagers.where(wager_type: "SportsWager").where(status: "accepted") + Wager.where(wageree_id: kenny_loggins.id).where(wager_type: "SportsWager").where(status: "accepted"))
    # current_users_wagers.each do |wager|
    #   game_outcome = SportsGamesOutcome.find_by(game_uuid: wager.game_uuid)
    #   if game_outcome
    #     wager.update(details: ("#{wager.details} <br/> ").html_safe
    #   end
    #
    #
    #
    # end
    #



    ###########################
    @dashboard = Dashboard.new

  end

end