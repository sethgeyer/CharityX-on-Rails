class WagersController < ApplicationController



  def new

      # if kenny_loggins.id == params[:user_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
        if kenny_loggins.chips.where(status: "available").count == 0
          flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can wager."
          redirect_to user_dashboard_path
        else
          @wager = Wager.new
          # @list_of_users = User.where('id != ?', kenny_loggins.id)
          if params[:pwid]
            rematch_wager = Wager.find(params[:pwid])
            if rematch_wager.user == kenny_loggins  || rematch_wager.wageree_id == kenny_loggins.id
              @wager.title = rematch_wager.title
              @wager.details = rematch_wager.details
              @wageree_username = if rematch_wager.user == kenny_loggins
                                             User.find(rematch_wager.wageree_id).username
                                           else
                                             rematch_wager.user.username
                                           end
              @wager.amount = rematch_wager.amount / 100

            end
          end
          render :new
        end
      # else
      #   flash[:notice] = "You are not authorized to visit this page"
      #   redirect_to root_path
      # end
  end

  def create
    amount = params[:wager][:amount].gsub("$", "").gsub(",", "").to_i
    @wager = Wager.new
    @wager.user_id = kenny_loggins.id
    @wager.title = params[:wager][:title]
    @wager.date_of_wager = params[:wager][:date_of_wager]
    @wager.details = params[:wager][:details]

    #The || needs to be tested
    registered_user = User.find_by(username: params[:wageree_username]) || User.find_by(email: params[:wageree_username])
    if registered_user
      @wager.wageree_id = registered_user.id
    else
      @wager.wageree_id = nil
    end
    @wager.status = "w/wageree"
    if amount % $ChipValue == 0 && amount >= $ChipValue
      @wager.amount = amount * 100
      if kenny_loggins.chips.where(status: "available").count < (amount / $ChipValue)
        @wager.amount = kenny_loggins.chips.where(status: "available").count * $ChipValue
        # @list_of_users = User.where('id != ?', kenny_loggins.id)
        flash[:amount] = "You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $#{kenny_loggins.chips.where(status: "available").count * $ChipValue}"
        @wageree_username = params[:wageree_username]
        @wager.amount = kenny_loggins.chips.where(status: "available").count * $ChipValue
        render :new
      else
        if @wager.save
          #UNTESTED ########################################################
          Chip.change_status_to_wagered(@wager.user.id, @wager.amount)
          ################
          # wageree = User.find(params[:proposed_wager][:wageree_id].to_i)
          if registered_user
            flash[:notice] = "Your proposed wager has been sent to #{registered_user.username}."
            WagerMailer.send_registered_user_wager(@wager).deliver
          elsif params[:wageree_username].include?("@")





            new_wager_with_non_registered_user = NonRegisteredWageree.new
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
          redirect_to user_dashboard_path
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
      flash[:amount] = "All wagers must be in increments of $#{$ChipValue}."
      render :new

    end
  end

  def edit

  end

  def update

    if params[:commit] == "Shake on it!"
      #<<<<< The below line and the if == nil code were added to address the situations where a wagerer has withdrawn a bet, it has been accepted, or expired
      #before the wageree refreshing his view.  This ensures that if the bet is no longer "available", a user that tries to accept it, gets a message stating
      #that it had been withdrawn.
      @wager = Wager.where(id: params[:id]).where(status: "w/wageree").first
      if @wager == nil
        flash[:notice] = "Wager has already been accepted, withdrawn or expired."
      else

        if kenny_loggins.chips.where(status: "available").count < (@wager.amount / 100 / $ChipValue)
          flash[:notice] = "You don't have adequate funds to accept this wager.  Please add additional funds to your account."
        else

          #test this _________________________________________________________________________
          @wager.wageree_id = kenny_loggins.id if @wager.wageree_id == nil
          #-------------------------------------
          @wager.status = "accepted"
          Chip.change_status_to_wagered(kenny_loggins.id, @wager.amount) if @wager.save!
        end
      end
        redirect_to user_dashboard_path

    elsif params[:commit] == "I Won"
      @wager = Wager.where(id: params[:id], status:"accepted").first
      #if the current user initiated the wager (aka: current user == wagerer)
      if kenny_loggins.id == @wager.user_id
        @wager.wagerer_outcome = "I Won"

        # flash[:notice] = "Awaiting confirmation from the wageree"
      else
        @wager.wageree_outcome = "I Won"
        # flash[:notice] = "Awaiting confirmation from the wagerer"
      end
      @wager.save!
      redirect_to user_dashboard_path


    elsif params[:commit] == "I Lost"
      @wager = Wager.where(id: params[:id], status:"accepted").first

      #if the current user initiated the wager (aka: current user == wagerer)
      if kenny_loggins.id == @wager.user_id
        @wager.wagerer_outcome = "I Lost"
        @wager.winner_id = @wager.wageree_id
        @wager.status = "completed"

        if @wager.save!
          winners_chips = Chip.change_status_to_available(@wager.wageree_id, @wager.amount)
          losers_chips = Chip.reassign_to_winner(kenny_loggins.id, @wager.wageree_id, @wager.amount )
        end
        redirect_to user_dashboard_path
      end


      #if the current user did not initiate the wager (aka: current user == wageree)
      if kenny_loggins.id != @wager.user_id
        @wager.wageree_outcome = "I Lost"
        @wager.winner_id = @wager.user_id
        @wager.status = "completed"

        if @wager.save!

          #convert these to class methods
          winners_chips = Chip.change_status_to_available(@wager.user_id, @wager.amount)
          losers_chips = Chip.reassign_to_winner(kenny_loggins.id, @wager.user_id, @wager.amount )
        end
        redirect_to user_dashboard_path
      end

    elsif params[:commit] == "No Thx!"
      @wager = Wager.where(id: params[:id]).where(status: "w/wageree").first
      @wager.status = "declined"

        if @wager.save!
          Chip.change_status_to_available(@wager.user_id, @wager.amount)
        end
        redirect_to user_dashboard_path

    end
  end


  def destroy
    #<<<<< The below line and the if == nil code were added to address the situations where a wageree has accepted a bet or it expired
    #before the wagerer who wants to withdraw the bet refreshes his view.  This ensures that if the bet is "accepted, a wagerer that tries to witdraw it, gets a message stating
    #that it can't be withdrawn.
    wager = Wager.where(id: params[:id]).where(status: "w/wageree").first
    if wager == nil
      flash[:notice] = "Wager has already been accepted or expired before you could withdraw it."
    else
      wager.destroy
      Chip.change_status_to_available(kenny_loggins.id, wager.amount)
    end

    redirect_to user_dashboard_path
  end



end