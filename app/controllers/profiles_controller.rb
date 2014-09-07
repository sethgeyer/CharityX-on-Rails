class ProfilesController < ApplicationController
  def edit
    # if kenny_loggins == User.find(params[:id])
      @user = kenny_loggins  #<--- no test written to test whether a sessioned user can view someone else's view
      render :edit
    # else
    #   flash[:notice] = "You are not authorized to visit this page"
    #   redirect_to root_path
    # end

  end

  def update
    @user = kenny_loggins
    @user.email = params[:user][:email].downcase
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]

    if params[:user][:password] != ""
      @user.password = params[:user][:password]

    end

    @user.profile_picture = params[:user][:profile_picture]
    if @user.save
      flash[:notice] = "Your changes have been saved"
      redirect_to user_dashboard_path
    else
      render :edit
    end
  end
end