class DashboardsController < ApplicationController

  def show

    #Not sure where this goes... it scrubs out the expired unaccepted wagers any time the dashboard is pulled
    Wager.all.each do |wager|
      if (wager.date_of_wager - Date.today).to_i < 0 && wager.status == "w/wageree"
        @wager = Wager.find(wager.id)
        @wager.status = "expired"
        if @wager.save!
          Chip.new.change_status_to_available(@wager.user.id, @wager.amount)
        end
      end
    end

    @dashboard = Dashboard.new

  end

end