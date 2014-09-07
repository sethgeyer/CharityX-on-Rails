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
        @charities_for_selection = Charity.all
      end
  end

  def create
    amount = params[:distribution][:amount].gsub("$", "").gsub(",", "").to_i
    @distribution = Distribution.new
    @distribution.user_id = kenny_loggins.id
    @distribution.charity_id = params[:distribution][:charity_id]
    if amount % $ChipValue == 0 && amount >= $ChipValue
      @distribution.amount = amount * 100
      if kenny_loggins.chips.where(status: "available").count < (amount / $ChipValue)
        @distribution.amount = kenny_loggins.chips.where(status: "available").count * $ChipValue
        flash[:amount] = "You don't have sufficient funds for the size of this distribution.  Unless you fund your account, the maximum you can distribute is $#{kenny_loggins.chips.where(status: "available").count * $ChipValue}"
        render :new
      else
        if @distribution.save!
          # newest_distribution = Distribution.where(account_id: params[:account_id].to_i).last
          #UNTESTED ########################################################
          Chip.new.cash_out(@distribution.user.id, @distribution.amount, @distribution.date, @distribution.charity.id)
          #################
          flash[:notice] = "Thank you for distributing $#{@distribution.amount.to_i / 100} from your account to #{@distribution.charity.name}"
          redirect_to user_dashboard_path
        end
      end
    else
      @charities_for_selection = Charity.all
      flash[:amount] = "All distributions must be in increments of $#{$ChipValue}."
      render :new

    end
  end

end

