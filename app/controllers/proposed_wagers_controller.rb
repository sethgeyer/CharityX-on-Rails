class ProposedWagersController < ApplicationController

  def new
      if kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
        @account = kenny_loggins.account
        if @account.chips.where(status: "available").count == 0
          flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can wager."
          redirect_to user_path(kenny_loggins)
        else
        @proposed_wager = ProposedWager.new
        @list_of_users = User.where('id != ?', kenny_loggins.id)
        render :new
        end
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    # end
  end

  def create
    @account = kenny_loggins.account
    @list_of_users = User.where('id != ?', kenny_loggins.id)
    @proposed_wager = ProposedWager.new
    @proposed_wager.account_id = @account.id
    @proposed_wager.title = params[:proposed_wager][:title]
    @proposed_wager.date_of_wager = params[:proposed_wager][:date_of_wager]
    @proposed_wager.details = params[:proposed_wager][:details]
    @proposed_wager.amount = params[:proposed_wager][:amount].to_i * 100
    @proposed_wager.wageree_id = params[:proposed_wager][:wageree_id].to_i
    @proposed_wager.status = "w/wageree"
    if @account.chips.where(status: "available").count < (params[:proposed_wager][:amount].to_i / 10)
      @proposed_wager.amount = @account.chips.where(status: "available").count * 10
      flash[:notice] = "You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $#{@account.chips.where(status: "available").count * 10}"
      render :new
    else
      if @proposed_wager.save!
        # @proposed_wager = ProposedWager.create!(account_id: params[:account_id], title: params[:proposed_wager][:title], date_of_wager: params[:proposed_wager][:date_of_wager], details: params[:proposed_wager][:details], amount: params[:proposed_wager][:amount].to_i * 100, wageree_id: params[:proposed_wager][:wageree_id].to_i, status: "w/wageree")
        #UNTESTED ########################################################
        Chip.new.change_status_to_wager(@proposed_wager.account.id, @proposed_wager.amount)
        ################
        wageree = User.find(params[:proposed_wager][:wageree_id].to_i)
        flash[:notice] = "Your proposed wager has been sent to #{wageree.username}."
        redirect_to user_path(kenny_loggins)
      end
    end
  end

  def edit

  end

  def update
    proposed_wager = ProposedWager.find(params[:id])
    proposed_wager.status = "accepted"
    proposed_wager.save!
    # if shakes on it wout revisions
    #UNTESTED ########################################################
    Chip.new.change_status_to_wager(kenny_loggins.account.id, proposed_wager.amount)
    ###############
    redirect_to user_path(kenny_loggins)
  end

  def destroy
    # if wagerer withdraws the bet
    proposed_wager = ProposedWager.find(params[:id])
    proposed_wager.destroy
    #UNTESTED ########################################################
    Chip.new.change_status_to_available(kenny_loggins.account.id, proposed_wager.amount)
    ###############
    redirect_to user_path(kenny_loggins)
  end



end