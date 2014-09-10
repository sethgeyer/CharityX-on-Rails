class WagersController < ApplicationController

  def new
        if kenny_loggins.chips.where(status: "available").count == 0
          flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can wager."
          redirect_to user_dashboard_path
        else
          @wager = Wager.new
          @wager.create_as_a_duplicate_of_an_original_wager?(params[:pwid], kenny_loggins)
          render :new
        end
  end


  def create
    amount = amount_stripped_of_dollar_sign_and_commas(params[:wager][:amount])
    @wager = Wager.new(allowed_params.merge(user_id: kenny_loggins.id))

    #The || needs to be tested
    @wageree_username_or_email = params[:wageree_username]
    registered_wageree = User.find_by(username: @wageree_username_or_email) || User.find_by(email: @wageree_username_or_email)
    @wager.wageree_id = registered_wageree.id if registered_wageree
    @wager.status = "w/wageree"
    @wager.amount = amount_converted_to_pennies(amount)


    if the_user_has_insufficient_funds_for_the_size_of_the_transaction(amount, "available")
      @wager.amount = kenny_loggins.chips.where(status: "available").count * $ChipValue
      @wager.errors.add(:amount, "You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $#{kenny_loggins.chips.where(status: "available").count * $ChipValue}")
      @wager.amount = kenny_loggins.chips.where(status: "available").count * $ChipValue
      render :new
    elsif @wager.save
      Chip.change_status_to_wagered(@wager.user.id, @wager.amount)
      if registered_wageree
        WagerMailer.send_registered_user_wager(@wager).deliver
        flash[:notice] = "Your proposed wager has been sent to #{registered_wageree.username}."
      elsif @wageree_username_or_email.include?("@")
        non_registered_wageree = NonRegisteredWageree.create_a_new_one(@wager.id, @wageree_username_or_email)
        WagerMailer.send_non_registered_user_wager(non_registered_wageree).deliver
        flash[:notice] = "A solicitation email has been sent to #{@wageree_username_or_email}"
      else
        flash[:notice] = "No username was provided.  Your wager is listed in the public wagers section"
      end
      redirect_to user_dashboard_path
    else
      @wager.amount = amount
      render :new
    end
  end

  def update

    case params[:commit]

      when "Shake on it!"
        #<<<<< The below line and the if == nil code were added to address the situations where a wagerer has withdrawn a bet, it has been accepted, or expired
        #before the wageree refreshing his view.  This ensures that if the bet is no longer "available", a user that tries to accept it, gets a message stating
        #that it had been withdrawn.
        @wager = Wager.where(id: params[:id]).where(status: "w/wageree").first
        if @wager == nil
          flash[:notice] = "Wager has already been accepted, withdrawn or expired."
        elsif the_user_has_insufficient_funds_for_the_size_of_the_transaction(@wager.amount / 100, "available")
          flash[:notice] = "You don't have adequate funds to accept this wager.  Please add additional funds to your account."
        else
          @wager.wageree_id = kenny_loggins.id if @wager.wageree_id == nil
          @wager.status = "accepted"
          Chip.change_status_to_wagered(kenny_loggins.id, @wager.amount) if @wager.save!
        end

      when "I Won"
        @wager = Wager.where(id: params[:id], status:"accepted").first
        @wager.assign_the_win(kenny_loggins, @wager)
        @wager.save!

      when "I Lost"
        @wager = Wager.where(id: params[:id], status:"accepted").first
        @wager.assign_the_loss(kenny_loggins, @wager)
        Chip.sweep_the_pot(kenny_loggins, @wager) if @wager.save!

      when "No Thx!"
        @wager = Wager.where(id: params[:id]).where(status: "w/wageree").first
        @wager.status = "declined"
        Chip.change_status_to_available(@wager.user_id, @wager.amount) if @wager.save!

      else
        puts "This blew up"
    end

    redirect_to user_dashboard_path

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



  def allowed_params
    params.require(:wager).permit(
      :title,
      :date_of_wager,
      :details,
    )
  end





end