class DistributionsController < ApplicationController


  def index
    if kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
      @account = kenny_loggins.account
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

      if @account.chips.where(status: "available").count == 0
        flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can distribute funds."
        redirect_to dashboard_path#user_path(kenny_loggins)
      else
        @distribution = Distribution.new
        @charities_for_selection = Charity.all
        render :new
      end
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def create
    amount = params[:distribution][:amount].gsub("$", "").gsub(",", "").to_i
    @account = kenny_loggins.account
    @distribution = Distribution.new
    @distribution.account_id = @account.id
    @distribution.charity_id = params[:distribution][:charity_id]
    if amount % 10 == 0 && amount >=10
      @distribution.amount = amount * 100
      if @account.chips.where(status: "available").count < (amount / 10)
        @distribution.amount = @account.chips.where(status: "available").count * 10
        flash[:amount] = "You don't have sufficient funds for the size of this distribution.  Unless you fund your account, the maximum you can distribute is $#{@account.chips.where(status: "available").count * 10}"
        render :new
      else
        if @distribution.save!
          # newest_distribution = Distribution.where(account_id: params[:account_id].to_i).last
          #UNTESTED ########################################################
          Chip.new.cash_out(@distribution.account.id, @distribution.amount, @distribution.date, @distribution.charity.id)
          #################
          flash[:notice] = "Thank you for distributing $#{@distribution.amount.to_i / 100} from your account to #{@distribution.charity.name}"
          redirect_to dashboard_path # user_path(kenny_loggins)
        end
      end
    else
      @charities_for_selection = Charity.all
      flash[:amount] = "All distributions must be in increments of $10."
      render :new

    end
  end

end

