class DepositsController < ApplicationController

  def index
    @deposits = kenny_loggins.deposits
  end

  def new
    @deposit = Deposit.new
  end

  def create
    deposit_amount = amount_stripped_of_dollar_sign_and_commas(params[:deposit][:amount])
    @deposit = Deposit.new(allowed_params.merge(user_id: kenny_loggins.id))
    @deposit.amount = amount_converted_to_pennies(deposit_amount)
    if @deposit.save
      Chip.convert_currency_to_chips(kenny_loggins.id, @deposit.amount, @deposit.date_created, "available")
      flash[:notice] = "Thank you for depositing $#{@deposit.amount / 100} into your account"
      redirect_to user_dashboard_path
    else
      render :new
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