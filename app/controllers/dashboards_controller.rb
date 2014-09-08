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

    @unallocated_chips = kenny_loggins.chips.where(status: "available")
    @distributed_chips = kenny_loggins.chips.where(status: "distributed")
    @wagered_chips = kenny_loggins.chips.where(status: "wagered")

    @deposit_total = kenny_loggins.deposits.sum(:amount) / 100
    @distribution_total = kenny_loggins.distributions.sum(:amount) / 100
    @wagered_total = (kenny_loggins.wagers.where(winner_id: nil).where('status != ?', 'declined').where('status != ?', 'expired').sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id, status: "accepted").where(winner_id: nil).sum(:amount) / 100)
    @winnings_total = (Wager.where(winner_id: kenny_loggins.id).sum(:amount) / 100) - ((kenny_loggins.wagers.where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id).where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100))
    @net_amount = @deposit_total - @distribution_total - @wagered_total + @winnings_total

    unfiltered_user_wagers = (kenny_loggins.wagers + Wager.where(wageree_id: kenny_loggins.id))
    @registered_wagers = Wager.compile_wagers_to_view_based_on_user_preferences(kenny_loggins, unfiltered_user_wagers)

    unfiltered_public_wagers = Wager.where(wageree_id: nil).where('user_id != ?', kenny_loggins.id).select { |wager| wager.non_registered_wageree == nil }
    @public_wagers = Wager.compile_wagers_to_view_based_on_user_preferences(kenny_loggins, unfiltered_public_wagers)
  end


end