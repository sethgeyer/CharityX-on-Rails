class UsersController < ApplicationController

  skip_before_action :ensure_current_user, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new
    @user.username = params[:user][:username]
    @user.email = params[:user][:email].downcase
    @user.password = params[:user][:password]
    @user.profile_picture = params[:user][:profile_picture]
    if @user.save
      session[:user_id] = @user.id
      account = Account.new
      account.user_id = session[:user_id]
      account.save

      if NonRegisteredWager.find_by(non_registered_user: @user.email)
        non_registered_wager = NonRegisteredWager.find_by(non_registered_user: @user.email)
        wager = Wager.find(non_registered_wager.wager.id)
        wager.wageree_id = @user.id
        wager.save
        non_registered_wager.destroy
      end




      flash[:notice] = "Thanks for registering #{@user.username}. You are now logged in."
      UserMailer.welcome_email(@user).deliver
      redirect_to user_path(kenny_loggins)
    else
      render :new
    end
  end


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
      @wagered_total = (@account.wagers.where(winner_id: nil).sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id, status: "accepted").where(winner_id: nil).sum(:amount) / 100)

      # @winnings_total = (@account.proposed_wagers.where(winner_id: kenny_loggins.id).sum(:amount) / 100) + (ProposedWager.where(wageree_id: kenny_loggins.id).where(winner_id: kenny_loggins.id).sum(:amount) / 100) - ( (@account.proposed_wagers.where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100) + (ProposedWager.where(wageree_id: kenny_loggins.id).where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100))
      @winnings_total = (Wager.where(winner_id: kenny_loggins.id).sum(:amount) / 100) - ( (@account.wagers.where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100) + (Wager.where(wageree_id: kenny_loggins.id).where('winner_id != ?', kenny_loggins.id).sum(:amount) / 100))

      @net_amount = @deposit_total - @distribution_total - @wagered_total + @winnings_total
      @proposed_wagers = @account.wagers + Wager.where(wageree_id: kenny_loggins.id)
      @public_wagers = Wager.where(wageree_id: nil).where('account_id != ?', @account.id ).select { |wager| wager.non_registered_wager == nil}
      # @wageree_wagers = ProposedWager.where(wageree_id: kenny_loggins.id)
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
    @user.email = params[:user][:email].downcase

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