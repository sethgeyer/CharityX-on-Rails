class UsersController < ApplicationController

  skip_before_action :ensure_current_user, only: [:new, :create]

  def new
    @user = User.new
    render :new, layout:false
  end

  def create
    @user = User.new
    @user.username = params[:user][:username]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.profile_picture = params[:user][:profile_picture]
    if @user.save
      session[:user_id] = @user.id
      account = Account.new
      account.user_id = session[:user_id]
      account.save!
      flash[:notice] = "Thanks for registering #{@user.username}. You are now logged in."
      redirect_to user_path(kenny_loggins)
    else
      render :new, layout:false
    end
  end


  # @user = User.find_by(username: params[:user][:username])
  # if @user && @user.authenticate(params[:user][:password])
  #   session[:user_id] = @user.id
  #   flash[:notice] = "Welcome #{@user.username}"
  #   redirect_to user_path(kenny_loggins)
  #
  #





  def show
    if kenny_loggins == User.find(params[:id])   #<--- no test written to test whether a sessioned user can view someone else's view
      @account = kenny_loggins.account
      #UNTESTED ######################

      @unallocated_chips = @account.chips.where(status: "available")
      @distributed_chips = @account.chips.where(status: "distributed")
      @wagered_chips = @account.chips.where(status: "wagered")

      ###################
      @deposit_total = @account.deposits.sum(:amount) / 100
      @distribution_total = @account.distributions.sum(:amount) / 100
      @wagered_total = (@account.proposed_wagers.where(wageree_outcome: nil).where(wagerer_outcome: nil).sum(:amount) / 100) + (ProposedWager.where(wageree_id: kenny_loggins.id, status: "accepted").where(wageree_outcome: nil).where(wagerer_outcome: nil).sum(:amount) / 100)

      @winnings_total = (@account.proposed_wagers.where(wageree_outcome: "I Lost").where(status: "completed").sum(:amount) / 100) + (ProposedWager.where(wageree_id: kenny_loggins.id, status: "completed").where(wagerer_outcome: "I Lost").sum(:amount) / 100) - ( (@account.proposed_wagers.where(wagerer_outcome: "I Lost").where(status: "completed").sum(:amount) / 100) + (ProposedWager.where(wageree_id: kenny_loggins.id, status: "completed").where(wageree_outcome: "I Lost").sum(:amount) / 100))

      @net_amount = @deposit_total - @distribution_total - @wagered_total + @winnings_total
      @proposed_wagers = @account.proposed_wagers
      @wageree_wagers = ProposedWager.where(wageree_id: kenny_loggins.id)
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def edit
    if kenny_loggins == User.find(params[:id])
      @user = kenny_loggins  #<--- no test written to test whether a sessioned user can view someone else's view
      render :edit
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end

    end

  def update
    @user = kenny_loggins
    @user.email = params[:user][:email]

    if params[:user][:password] != ""
      @user.password = params[:user][:password]

    end

    @user.profile_picture = params[:user][:profile_picture]
    if @user.save
      flash[:notice] = "Your changes have been saved"
      redirect_to user_path(kenny_loggins)
    else
      render :edit
    end
  end




end