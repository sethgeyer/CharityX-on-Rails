class DepositsController < ApplicationController

  def index
    if kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
      @account = kenny_loggins.account
      @deposits = @account.deposits
      @distributions = @account.distributions
      render :index
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def new
    if kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
      @account = kenny_loggins.account
      @deposit = Deposit.new
      render :new
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def create
    amount = params[:deposit][:amount].gsub("$", "").gsub(",", "").to_i
    @deposit = Deposit.new
    @deposit.account_id = params[:account_id].to_i
    @deposit.cc_number = params[:deposit][:cc_number].to_i
    @deposit.exp_date =params[:deposit][:exp_date]
    @deposit.name_on_card = params[:deposit][:name_on_card]
    @deposit.cc_type = params[:deposit][:cc_type]
    @deposit.date_created = Time.now
    if amount % $ChipValue == 0 && amount <= 1000 && amount >= $ChipValue
      @deposit.amount = amount * 100
      if @deposit.save!
        #UNTESTED ########################################################
        Chip.new.purchase(kenny_loggins.id, @deposit.account.id, @deposit.amount, @deposit.date_created, "available")
        #################
        flash[:notice] = "Thank you for depositing $#{@deposit.amount / 100} into your account"
        redirect_to dashboard_path
      else
        @account = kenny_loggins.account
        @deposit = @deposit
        render :new
      end
    else
      @account = kenny_loggins.account
      flash[:amount] = "All deposits must be in increments of $#{$ChipValue} and no more than $1,000."
      render :new
    end

  end


end