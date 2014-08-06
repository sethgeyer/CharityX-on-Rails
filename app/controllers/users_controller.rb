class UsersController < ApplicationController
  def new
    @user = User.new
    render :new, layout:false
  end

  def create
    @user = User.new
    @user.username = params[:username]
    @user.ssn = params[:ssn].to_i
    @user.email = params[:email]
    @user.password = params[:password]
    @user.profile_picture = params[:profile_picture]
    if @user.save
      set_the_session(User.find_by(username: params[:username]))
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