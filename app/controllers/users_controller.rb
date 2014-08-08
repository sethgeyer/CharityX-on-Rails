class UsersController < ApplicationController

  skip_before_action :ensure_current_user, only: [:new, :create]

  def new
    @user = User.new
    render :new, layout:false
  end

  def create
    @user = User.new
    @user.username = params[:user][:username]
    @user.ssn = strip_off_dashes(params[:user][:ssn])
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.profile_picture = params[:user][:profile_picture]
    if @user.save
      session[:user_id] = @user.id
      account = Account.new
      account.user_id = session[:user_id]
      account.save!
      flash[:notice] = "Thanks for registering #{@user.username}. You are now logged in."
      redirect_to user_path(session[:user_id])
    else
      render :new, layout:false
    end
  end

  def show
    if current_user == User.find(params[:id])   #<--- no test written to test whether a sessioned user can view someone else's view
      @account = current_user.account
      #UNTESTED ######################
      @unallocated_chips = @account.chips.where(status: "available")
      @distributed_chips = @account.chips.where(status: "distributed")
      @wagered_chips = @account.chips.where(status: "wagered")
      ###################
      @deposit_total = @account.deposits.sum(:amount) / 100
      @distribution_total = @account.distributions.sum(:amount) / 100
      @wagered_total = @account.proposed_wagers.sum(:amount) / 100
      @net_amount = @deposit_total - @distribution_total - @wagered_total
      @proposed_wagers = @account.proposed_wagers
      @wageree_wagers = ProposedWager.where(wageree_id: current_user.id)
      render :show
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def edit
    if current_user == User.find(params[:id])
      @user = current_user  #<--- no test written to test whether a sessioned user can view someone else's view
      render :edit
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end

    end

  def update
    @user = current_user
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.profile_picture = params[:user][:profile_picture]
    if @user.save
      flash[:notice] = "Your changes have been saved"
      redirect_to user_path(session[:user_id])
    else
      render :edit
    end
  end

  def strip_off_dashes(ssn_as_a_string)
    ssn_as_a_string.gsub("-", "").to_i
  end


end