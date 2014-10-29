class ProfilesController < ApplicationController
  def edit
    @user = kenny_loggins #<--- no test written to test whether a sessioned user can view someone else's view
  end

  def update
    @user = kenny_loggins
    @user.update(allowed_params)
    @user.password = params[:user][:password] if params[:user][:password] != ""
    if @user.save
      flash[:notice] = "Your changes have been saved"
      redirect_to user_dashboard_path
    else
      render :edit
    end
  end

  private

  def allowed_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
    )
  end



end