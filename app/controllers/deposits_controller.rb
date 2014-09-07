class DepositsController < ApplicationController

  # before_action :kenny_loggins_can_view_only_his_deposits

  def index
    @deposits = kenny_loggins.deposits
  end

  def new
    @deposit = Deposit.new
  end


  def create
    deposit_amount = amount_stripped_of_non_integers(params[:deposit][:amount])
    @deposit = Deposit.new(deposit_strong_params.merge(user_id: kenny_loggins.id))

    if !the_amount_is_in_the_correct_increment_and_less_than_the_specified_threshold(deposit_amount)
      flash[:amount] = "All deposits must be in increments of $#{$ChipValue} and no more than $1,000."
      render :new
    else
      @deposit.amount = amount_converted_to_pennies(deposit_amount)
      if @deposit.save
        # Chip.new.convert_currency_to_chips(kenny_loggins.id, @deposit.amount, @deposit.date_created, "available")
        Chip.convert_currency_to_chips(kenny_loggins.id, @deposit.amount, @deposit.date_created, "available")

        flash[:notice] = "Thank you for depositing $#{@deposit.amount / 100} into your account"
        redirect_to user_dashboard_path
      else
        render :new
      end
    end
  end

  private

  # def kenny_loggins_can_view_only_his_deposits
  #   unless kenny_loggins.id == params[:user_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
  #     flash[:notice] = "You are not authorized to visit this page"
  #     redirect_to root_path
  #   end
  # end

  def deposit_strong_params
    params.require(:deposit).permit(
      :cc_number,
      :exp_date,
      :name_on_card,
      :cc_type
    )
  end




end