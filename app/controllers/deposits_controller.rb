class DepositsController < ApplicationController

  def index
    @deposits = kenny_loggins.deposits
  end

  def new
    @deposit = Deposit.new
  end

  def create

    Deposit.transaction do

      @deposit = kenny_loggins.deposits.new(allowed_params)
      deposit_amount_in_dollars = amount_stripped_of_dollar_sign_and_commas(params[:deposit][:amount])
      @deposit.amount = amount_converted_to_pennies(deposit_amount_in_dollars)
      if @deposit.save
        Chip.convert_currency_to_chips(kenny_loggins.id, @deposit.amount, @deposit.created_at, "available")
        flash[:notice] = "Thank you for depositing $#{@deposit.amount / 100} into your account"
        redirect_to user_dashboard_path
      else
        render :new
      end

    end

  end

  private

  def allowed_params
    params.require(:deposit).permit(
      :cc_number,
      :exp_date,
      :name_on_card,
      :cc_type
    )
  end

end