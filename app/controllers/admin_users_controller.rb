class AdminUsersController < ApplicationController

  before_action :ensure_admin


  def index
    sort_request = params[:sort]

    if sort_request != nil
      sorter = sort_request + " DESC"
      @users = User.all.order(sorter)
    else
      @users = User.all.order('created_at ASC')
    end
  end

end