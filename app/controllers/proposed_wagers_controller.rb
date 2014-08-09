class ProposedWagersController < ApplicationController

  def new
    # if !current_user
    #   flash[:notice] = "You are not authorized to visit this page"
    #   redirect_to root_path
    # else

      if current_user.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
        @account = current_user.account
        @account = current_user.account
        @proposed_wager = ProposedWager.new
        @list_of_users = User.where('id != ?', current_user.id)
        render :new
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    # end
  end

  def create
    proposed_wager = ProposedWager.create(account_id: params[:account_id], title: params[:proposed_wager][:title], date_of_wager: params[:proposed_wager][:date_of_wager], details: params[:proposed_wager][:details], amount: params[:proposed_wager][:amount].to_i * 100, wageree_id: params[:proposed_wager][:wageree_id].to_i)
    #UNTESTED ########################################################
    Chip.new.change_status_to_wager(proposed_wager.account.id, proposed_wager.amount )
    ################
    # wageree = User.find(params[:proposed_wager][:wageree_id].to_i)
    flash[:notice] = "You're proposed wager has been sent"#" to #{wageree["email"]}"
    redirect_to user_path(current_user)
  end


end