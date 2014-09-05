class DepositsController < ApplicationController

  before_action :kenny_loggins_can_view_only_his_deposits

  def index
    @deposits = kenny_loggins.account.deposits
  end

  def new
    @account = kenny_loggins.account
    @deposit = Deposit.new
  end

  def create
    deposit_amount = amount_stripped_of_non_integers(params[:deposit][:amount])
    @deposit = Deposit.new(deposit_strong_params.merge(account_id: kenny_loggins.account.id))


    if deposit_amount % $ChipValue == 0 && deposit_amount <= 1000 && deposit_amount >= $ChipValue
      @deposit.amount = deposit_amount * 100
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

  private

  def kenny_loggins_can_view_only_his_deposits
    unless kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def deposit_strong_params
    params.require(:deposit).permit(
      :cc_number,
      :exp_date,
      :name_on_card,
      :cc_type
    )
  end




end