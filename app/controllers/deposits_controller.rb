class DepositsController < ApplicationController

  def index
    if session[:user_id] == nil
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    else
      @account = Account.find_by(user_id: session[:user_id])
      if session[:user_id] == @account.user_id
        @deposits = @account.deposits
        @distributions = @account.distributions
        render :index
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    end
  end

  def new
    if session[:user_id] == nil
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    else
      @account = Account.find_by(user_id: session[:user_id])
      if session[:user_id] == @account.user_id
        @deposit = Deposit.new
        render :new
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    end
  end

  def create
    deposit = Deposit.new
    deposit.account_id = params[:account_id].to_i
    deposit.amount = params[:deposit][:amount].to_i * 100
    deposit.cc_number = params[:deposit][:cc_number].to_i
    deposit.exp_date =params[:deposit][:exp_date]
    deposit.name_on_card = params[:deposit][:name_on_card]
    deposit.cc_type = params[:deposit][:cc_type]
    deposit.date_created = Time.now
    deposit.save!
    newest_deposit = Deposit.where(account_id: params[:account_id].to_i).last
    #UNTESTED ########################################################
    Chip.new.purchase(session[:user_id], newest_deposit.account.id, newest_deposit.amount, newest_deposit.date_created, "available")
    #################
    flash[:notice] = "Thank you for depositing $#{newest_deposit.amount / 100} into your account"
    redirect_to user_path(session[:user_id])#"/users/#{session[:user_id]}"
  end


end