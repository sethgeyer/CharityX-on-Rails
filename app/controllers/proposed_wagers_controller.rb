class ProposedWagersController < ApplicationController

  def new
    # if !current_user
    #   flash[:notice] = "You are not authorized to visit this page"
    #   redirect_to root_path
    # else

      if kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
        @account = kenny_loggins.account
        @account = kenny_loggins.account
        @proposed_wager = ProposedWager.new
        @list_of_users = User.where('id != ?', kenny_loggins.id)
        render :new
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    # end
  end

  def create
    proposed_wager = ProposedWager.create!(account_id: params[:account_id], title: params[:proposed_wager][:title], date_of_wager: params[:proposed_wager][:date_of_wager], details: params[:proposed_wager][:details], amount: params[:proposed_wager][:amount].to_i * 100, wageree_id: params[:proposed_wager][:wageree_id].to_i, status: "w/wageree")
    #UNTESTED ########################################################
    Chip.new.change_status_to_wager(proposed_wager.account.id, proposed_wager.amount)
    ################
    wageree = User.find(params[:proposed_wager][:wageree_id].to_i)
    flash[:notice] = "Your proposed wager has been sent to #{wageree.username}."
    redirect_to user_path(kenny_loggins)
  end

  def edit

  end

  def update
    proposed_wager = ProposedWager.find(params[:id])
    proposed_wager.status = "accepted"
    proposed_wager.save!
    # if shakes on it wout revisions
    #UNTESTED ########################################################
    Chip.new.change_status_to_wager(kenny_loggins.account.id, proposed_wager.amount)
    ###############
    redirect_to user_path(kenny_loggins)
  end

  def destroy
    # if wagerer withdraws the bet
    proposed_wager = ProposedWager.find(params[:id])
    proposed_wager.destroy
    #UNTESTED ########################################################
    Chip.new.change_status_to_available(kenny_loggins.account.id, proposed_wager.amount)
    ###############
    redirect_to user_path(kenny_loggins)
  end



end