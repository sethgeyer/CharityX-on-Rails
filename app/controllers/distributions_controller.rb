class DistributionsController < ApplicationController

  def index
      @distributions = kenny_loggins.distributions
  end

  def new
      if kenny_loggins.chips.where(status: "available").count == 0
        flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can distribute funds."
        redirect_to user_dashboard_path
      else
        @distribution = Distribution.new
      end
  end

  def create
    distribution_amount = amount_stripped_of_dollar_sign_and_commas(params[:distribution][:amount])
    @distribution = Distribution.new
    @distribution.user_id = kenny_loggins.id
    @distribution.charity_id = params[:distribution][:charity_id]
    @distribution.amount = amount_converted_to_pennies(distribution_amount)

    if the_user_has_insufficient_funds_for_the_size_of_the_transaction(distribution_amount, "available")
      @distribution.amount = kenny_loggins.chips.where(status: "available").count * $ChipValue
      @distribution.errors.add(:amount, "You don't have sufficient funds for the size of this distribution.  Unless you fund your account, the maximum you can distribute is $#{kenny_loggins.chips.where(status: "available").count * $ChipValue}")
      render :new
    elsif @distribution.save
      Chip.mark_as_distributed_to_charity(@distribution.user.id, @distribution.amount, @distribution.date, @distribution.charity.id)
      flash[:notice] = "Thank you for distributing $#{@distribution.amount.to_i / 100} from your account to #{@distribution.charity.name}"
      redirect_to user_dashboard_path
    else
      @distribution.amount = distribution_amount
      render :new
    end
  end

  private

  def the_user_has_insufficient_funds_for_the_size_of_the_transaction(dollar_amount, status)
    kenny_loggins.chips.where(status: status).count < (dollar_amount / $ChipValue)
  end


end

