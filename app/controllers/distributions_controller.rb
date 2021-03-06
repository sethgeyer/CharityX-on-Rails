class DistributionsController < ApplicationController

  def index
    @distributions = kenny_loggins.distributions
  end

  def new
    minimum_distribution_amount = 10
    if kenny_loggins.insufficient_funds_for(minimum_distribution_amount, "available")
      flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can distribute funds."
      redirect_to user_dashboard_path
    else
      @distribution = Distribution.new
    end
  end

  def create

    Distribution.transaction do

      distribution_amount_in_dollars = amount_stripped_of_dollar_sign_and_commas(params[:distribution][:amount])

      @distribution = kenny_loggins.distributions.new(charity_id: params[:distribution][:charity_id])
      @distribution.amount = amount_converted_to_pennies(distribution_amount_in_dollars)
      @distribution.anonymous = true if params[:distribution][:anonymous] == "1"
      if kenny_loggins.insufficient_funds_for(distribution_amount_in_dollars, "available")
        @distribution.amount = kenny_loggins.maximum_dollars_available
        @distribution.errors.add(:amount, "You don't have sufficient funds for the size of this distribution.  Unless you fund your account, the maximum you can distribute is $#{kenny_loggins.maximum_dollars_available}")
        render :new
      elsif @distribution.save
        Chip.mark_as_distributed_to_charity(@distribution.user.id, @distribution.amount, @distribution.created_at, @distribution.charity.id)
        flash[:notice] = "Thank you for distributing $#{@distribution.amount.to_i / 100} from your account to #{@distribution.charity.name}"
        redirect_to user_dashboard_path
      else
        @distribution.amount = distribution_amount_in_dollars
        render :new
      end

    end
  end

  private


end

