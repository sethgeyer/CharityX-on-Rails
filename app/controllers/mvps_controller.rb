class MvpsController < ApplicationController
  def index
    @mvps = Mvp.all
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end

end