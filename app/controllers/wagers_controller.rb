class WagersController < ApplicationController

  def new


      if kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
        @account = kenny_loggins.account
        if @account.chips.where(status: "available").count == 0
          flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can wager."
          redirect_to user_path(kenny_loggins)
        else
          @wager = Wager.new
          # @list_of_users = User.where('id != ?', kenny_loggins.id)
          if params[:pwid]
            rematch_wager = Wager.find(params[:pwid])
            if rematch_wager.account == @account  || rematch_wager.wageree_id == kenny_loggins.id
              @wager.title = rematch_wager.title
              @wager.details = rematch_wager.details
              @wageree_username = if rematch_wager.account == @account
                                             User.find(rematch_wager.wageree_id).username
                                           else
                                             rematch_wager.account.user.username
                                           end
              @wager.amount = rematch_wager.amount / 100

            end
          end
          render :new
        end
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    # end
  end

  def create
    amount = params[:wager][:amount].gsub("$", "").gsub(",", "").to_i
    @account = kenny_loggins.account
    @wager = Wager.new
    @wager.account_id = @account.id
    @wager.title = params[:wager][:title]
    @wager.date_of_wager = params[:wager][:date_of_wager]
    @wager.details = params[:wager][:details]

    #The || needs to be tested
    if User.find_by(username: params[:wageree_username]) #|| User.find_by(email: params[:user][:username].downcase)
      @wager.wageree_id = User.find_by(username: params[:wageree_username]).id #|| User.find_by(email: params[:user][:username].downcase).id
    else
      @wager.wageree_id = nil
    end
    @wager.status = "w/wageree"
    if amount % 10 == 0 && amount >=10
      @wager.amount = amount * 100
      if @account.chips.where(status: "available").count < (amount / 10)
        @wager.amount = @account.chips.where(status: "available").count * 10
        # @list_of_users = User.where('id != ?', kenny_loggins.id)
        flash[:amount] = "You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $#{@account.chips.where(status: "available").count * 10}"
        @wageree_username = params[:wageree_username]
        @wager.amount = amount
        render :new
      else
        if @wager.save
          #UNTESTED ########################################################
          Chip.new.change_status_to_wagered(@wager.account.id, @wager.amount)
          ################
          # wageree = User.find(params[:proposed_wager][:wageree_id].to_i)
          if User.find_by(username: params[:wageree_username])
            wageree = User.find_by(username: params[:wageree_username])
            flash[:notice] = "Your proposed wager has been sent to #{wageree.username}."
            WagerMailer.send_registered_user_wager(@wager).deliver
          elsif params[:wageree_username].include?("@")





            new_wager_with_non_registered_user = NonRegisteredUser.new
            new_wager_with_non_registered_user.wager_id = @wager.id
            # new_wager_with_non_registered_user.unique_id = SecureRandom.uuid
            new_wager_with_non_registered_user.email = params[:wageree_username]
            new_wager_with_non_registered_user.save!

            # WagerMailer.set_default_from(kenny_loggins.email)

            WagerMailer.send_non_registered_user_wager(new_wager_with_non_registered_user).deliver




            flash[:notice] = "A solicitation email has been sent to #{params[:wageree_username]}"
          else
            flash[:notice] = "No username was provided.  Your wager is listed in the public wagers section"
          end
          redirect_to user_path(kenny_loggins)
        else
          @wager.amount = amount
          @wageree_username = params[:wageree_username]
          render :new
        end
      end
    else
      @wager.amount = amount
      @wageree_username = params[:wageree_username]
      # @list_of_users = User.where('id != ?', kenny_loggins.id)
      flash[:amount] = "All wagers must be in increments of $10."
      render :new

    end
  end

  def edit

  end

  def update
    @account = kenny_loggins.account

    if params[:commit] == "Shake on it"
      @wager = Wager.find(params[:id])

      if @account.chips.where(status: "available").count < (@wager.amount / 100 / 10)
        flash[:notice] = "You don't have adequate funds to accept this wager.  Please add additional funds to your account."
      else

        #test this _________________________________________________________________________
        @wager.wageree_id = @account.user_id if @wager.wageree_id == nil
        #-------------------------------------
        @wager.status = "accepted"
        Chip.new.change_status_to_wagered(kenny_loggins.account.id, @wager.amount) if @wager.save!
      end
      redirect_to user_path(kenny_loggins)

    elsif params[:commit] == "I Lost"
      @wager = Wager.where(id: params[:id], status:"accepted").first

      #if the current user initiated the wager (aka: current user == wagerer)
      if @account.id == @wager.account.id
        @wager.wagerer_outcome = "I Lost"
        @wager.winner_id = @wager.wageree_id
        @wager.status = "completed"

        if @wager.save!
          winners_chips = Chip.new
          winners_chips.change_status_to_available(Account.find_by(user_id: @wager.wageree_id).id, @wager.amount)
          losers_chips = Chip.new
          losers_chips.reassign_to_winner(kenny_loggins.account.id, Account.find_by(user_id: @wager.wageree_id).id, @wager.amount )
        end
        redirect_to user_path(kenny_loggins)
      end


      #if the current user did not initiate the wager (aka: current user == wageree)
      if @account.id != @wager.account.id
        @wager.wageree_outcome = "I Lost"
        @wager.winner_id = @wager.account.user_id
        @wager.status = "completed"

        if @wager.save!

          #convert these to class methods
          winners_chips = Chip.new
          winners_chips.change_status_to_available(@wager.account.id, @wager.amount)
          losers_chips = Chip.new
          losers_chips.reassign_to_winner(kenny_loggins.account.id, @wager.account.id, @wager.amount )
        end
        redirect_to user_path(kenny_loggins)
      end

    end
  end


  def destroy
    # if wagerer withdraws the bet
    wager = Wager.find(params[:id])
    wager.destroy
    Chip.new.change_status_to_available(kenny_loggins.account.id, wager.amount)
    redirect_to user_path(kenny_loggins)
  end



end