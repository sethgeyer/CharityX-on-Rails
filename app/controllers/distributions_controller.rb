class DistributionsController < ApplicationController

  def index
      @distributions = kenny_loggins.distributions
  end

  def new
      minimum_distribution_amount = 10
      if the_user_has_insufficient_funds_for_the_size_of_the_transaction(minimum_distribution_amount, "available")
        flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can distribute funds."
        redirect_to user_dashboard_path
      else
        @distribution = Distribution.new
      end
  end

  def create
    distribution_amount_in_dollars = amount_stripped_of_dollar_sign_and_commas(params[:distribution][:amount])

    @distribution = kenny_loggins.distributions.new(charity_id: params[:distribution][:charity_id])
    @distribution.amount = amount_converted_to_pennies(distribution_amount_in_dollars)

    if the_user_has_insufficient_funds_for_the_size_of_the_transaction(distribution_amount_in_dollars, "available")
      @distribution.amount = calculte_the_maximum_dollars_available
      @distribution.errors.add(:amount, "You don't have sufficient funds for the size of this distribution.  Unless you fund your account, the maximum you can distribute is $#{calculte_the_maximum_dollars_available}")
      render :new
    elsif @distribution.save
      Chip.mark_as_distributed_to_charity(@distribution.user.id, @distribution.amount, @distribution.date, @distribution.charity.id)
      flash[:notice] = "Thank you for distributing $#{@distribution.amount.to_i / 100} from your account to #{@distribution.charity.name}"
      redirect_to user_dashboard_path
    else
      @distribution.amount = distribution_amount_in_dollars
      render :new
    end
  end

  private




end

