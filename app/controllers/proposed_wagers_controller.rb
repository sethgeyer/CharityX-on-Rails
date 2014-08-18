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
      @list_of_users = User.where('id != ?', kenny_loggins.id)
      flash[:notice] = "You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $#{@account.chips.where(status: "available").count * 10}"
      render :new
    else
      if @proposed_wager.save!
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
    @account = kenny_loggins.account
    @proposed_wager = ProposedWager.find(params[:id])

    if params[:commit] == "Shake on it"
      @proposed_wager.status = "accepted"
      if @account.chips.where(status: "available").count < (@proposed_wager.amount / 100 / 10)
        flash[:notice] = "You don't have adequate funds to accept this wager.  Please add additional funds to your account."
      else
        if @proposed_wager.save!
          # if shakes on it wout revisions
          #UNTESTED ########################################################
          Chip.new.change_status_to_wager(kenny_loggins.account.id, @proposed_wager.amount)
          ###############
        end
      end
      redirect_to user_path(kenny_loggins)

    elsif params[:commit] == "Lose"
      @proposed_wager = ProposedWager.where(id: params[:id].to_i, status:"accepted").first
      if @account.id != @proposed_wager.account.id
        @proposed_wager.wageree_outcome = "Lose"
        @proposed_wager.status = "over"
        if @proposed_wager.save!
          # if the player lost his chips
          #UNTESTED ########################################################
          winners_chips = Chip.new
          winners_chips.change_status_to_available(@proposed_wager.account.id, @proposed_wager.amount)
          losers_chips = Chip.new
          losers_chips.change_status_to_over(kenny_loggins.account.id, @proposed_wager.account.id, @proposed_wager.amount )
          ###############

        end





        redirect_to user_path(kenny_loggins)

      end
    end
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