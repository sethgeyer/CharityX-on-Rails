class DashboardsController < ApplicationController

  def show
    # if kenny_loggins == User.find(params[:id])   #<--- no test written to test whether a sessioned user can view someone else's view
      @account = kenny_loggins.account
      #UNTESTED ######################

      @unallocated_chips = @account.chips.where(status: "available")
      @distributed_chips = @account.chips.where(status: "distributed")
      @wagered_chips = @account.chips.where(status: "wagered")

      ###################
      @deposit_total = @account.deposits.sum(:amount) / 100
      @distribution_total = @account.distributions.sum(:amount) / 100
      @wagered_total = (@account.wagers.where(winner_id: nil).sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id, status: "accepted").where(winner_id: nil).sum(:amount) / 100)

      # @winnings_total = (@account.proposed_wagers.where(winner_id: kenny_loggins.id).sum(:amount) / 100) + (ProposedWager.where(wageree_id: kenny_loggins.id).where(winner_id: kenny_loggins.id).sum(:amount) / 100) - ( (@account.proposed_wagers.where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100) + (ProposedWager.where(wageree_id: kenny_loggins.id).where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100))
      @winnings_total = (Wager.where(winner_id: kenny_loggins.id).sum(:amount) / 100) - ( (@account.wagers.where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id).where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100))

      @net_amount = @deposit_total - @distribution_total - @wagered_total + @winnings_total
      @registered_wagers = @account.wagers + Wager.where(wageree_id: kenny_loggins.id)
      @public_wagers = Wager.where(wageree_id: nil).where('account_id != ?', @account.id ).select { |wager| wager.non_registered_user == nil}
      # @wageree_wagers = ProposedWager.where(wageree_id: kenny_loggins.id)
    # else
    #   flash[:notice] = "You are not authorized to visit this page"
    #   redirect_to root_path
    # end

  end

end