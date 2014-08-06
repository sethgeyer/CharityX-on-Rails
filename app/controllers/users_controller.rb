class UsersController < ApplicationController
  def new
    @user = User.new
    render :new, layout:false
  end

  def create
    @user = User.new
    @user.username = params[:user][:username]
    @user.ssn = params[:user][:ssn].to_i
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.profile_picture = params[:user][:profile_picture]
    if @user.save
      set_the_session(User.find_by(username: params[:user][:username]))
      account = Account.new
      account.user_id = session[:user_id]
      account.save!
      flash[:notice] = "Thanks for registering #{session[:username]}. You are now logged in."
      redirect_to "/users/#{session[:user_id]}"
    else

      render :new, layout:false
    end
  end

  def show
    @user = User.find(params[:id])
    if session[:user_id] == @user.id #params[:id].to_i
      @account = Account.find_by(user_id: session[:user_id])
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
      @wageree_wagers = ProposedWager.where(wageree_id: session[:user_id])
      render :show
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect "/"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if params[:user][:email] == ""
      flash[:notice] = "Email can't be blank"
      @user = User.find(session[:user_id])
      render :edit
    elsif params[:user][:password].length < 7
      flash[:notice] = "Password must be at least 7 characters"
      @user = User.find(session[:user_id])
      render :edit
    else
      @user = User.find(params[:id].to_i)
      @user.email = params[:user][:email]
      @user.password = params[:user][:password]
      @user.profile_picture = params[:user][:profile_picture]
      @user.save!
      flash[:notice] = "Your changes have been saved"
      redirect_to "/users/#{session[:user_id]}"
    end
  end


  def set_the_session(current_user)
    session[:user_id] = current_user.id
    session[:username] = current_user.username
  end


  # def render_page_or_redirect_to_homepage(session_id, name_of_erb_template)
  #   if session_id == nil
  #     flash[:notice] = "You are not authorized to visit this page"
  #     redirect "/"
  #   else
  #     account = Account.find_by(user_id: session_id)
  #     if session_id == account.user_id
  #       deposits = account.deposits
  #       distributions = account.distributions
  #       erb name_of_erb_template.to_sym, locals: {account: account, deposits: deposits, distributions: distributions}
  #     else
  #       flash[:notice] = "You are not authorized to visit this page"
  #       redirect "/"
  #     end
  #   end
  # end



end