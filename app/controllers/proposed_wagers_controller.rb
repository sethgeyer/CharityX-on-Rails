class ProposedWagersController < ApplicationController

  def new
    if session[:user_id] == nil
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    else
      @account = Account.find_by(user_id: session[:user_id])
      if session[:user_id] == @account.user_id
        @proposed_wager = ProposedWager.new
        @list_of_users = User.where('id != ?', session[:user_id])
        # deposits = account.deposits
        # distributions = account.distributions
        # erb name_of_erb_template.to_sym, locals: {account: account, deposits: deposits, distributions: distributions}
        render :new
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    end
  end

  def create
    proposed_wager = ProposedWager.create(account_id: params[:account_id], title: params[:proposed_wager][:title], date_of_wager: params[:proposed_wager][:date_of_wager], details: params[:proposed_wager][:details], amount: params[:proposed_wager][:amount].to_i * 100, wageree_id: params[:proposed_wager][:wageree_id].to_i)
    #UNTESTED ########################################################
    Chip.new.change_status_to_wager(proposed_wager.account.id, proposed_wager.amount )
    ################
    # wageree = User.find(params[:proposed_wager][:wageree_id].to_i)
    flash[:notice] = "You're proposed wager has been sent"#" to #{wageree["email"]}"
    redirect_to user_path(session[:user_id])
  end


end