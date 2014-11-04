class WagersController < ApplicationController

  def new
    minimum_distribution_amount = 10
    if the_user_has_insufficient_funds_for_the_size_of_the_transaction(minimum_distribution_amount, "available")
      flash[:notice] = "Your account has a $0 balance.  You must fund your account before you can wager."
      redirect_to user_dashboard_path
    else
      @wager = Wager.new
      @wager.create_as_a_duplicate_of_an_original_wager?(params[:pwid], kenny_loggins)
      render :new
    end
  end


  def create
    wager_amount_in_dollars = amount_stripped_of_dollar_sign_and_commas(params[:wager][:amount])
    person_input_by_wagerer = params[:wageree_username]
    wageree = find_the_proposed_wageree(person_input_by_wagerer)

    @wager = kenny_loggins.wagers.new(allowed_params)
    @wager.wageree_id = wageree.id if wageree.is_a?(User)
    @wager.status = "w/wageree"
    @wager.amount = amount_converted_to_pennies(wager_amount_in_dollars)

    @wager.game_id = params[:wager][:game_id] if params[:wager][:game_id] != ""
    @wager.selected_winner_id = params[:wager][:selected_winner_id] if params[:wager][:selected_winner_id] != ""
    @wager.home_id = params[:wager][:home_id] if params[:wager][:home_id] != ""
    @wager.vs_id = params[:wager][:vs_id] if params[:wager][:vs_id] != ""
    @wager.game_week = params[:wager][:game_week] if params[:wager][:game_week] != ""
    @wager.wager_type = if params[:wager][:game_id]
                          "SportsWager"
                        else
                          "CustomWager"
                        end

    if the_user_has_insufficient_funds_for_the_size_of_the_transaction(wager_amount_in_dollars, "available")
      @wager.amount = calculate_the_maximum_dollars_available
      @wager.errors.add(:amount, "You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $#{calculate_the_maximum_dollars_available}")
      render :new

    elsif @wager.save
      Chip.set_status_to_wagered(@wager.user.id, @wager.amount)
      send_the_appropriate_notification_email(wageree, @wager)
      redirect_to user_dashboard_path
    else
      @wager.amount = wager_amount_in_dollars
      render :new
    end
  end

  def update
    the_update_action = params[:commit]
    wager_id = params[:id]

    lock_down_wager_if_accepted(the_update_action, wager_id)
    cancel_wager_if_wager_declined(the_update_action, wager_id)
    check_outcome_of_game(the_update_action, wager_id)
    assign_the_win_if_outcome_is_determined(the_update_action, wager_id)
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
      Chip.set_status_to_available(kenny_loggins.id, wager.amount)
    end

    redirect_to user_dashboard_path
  end

  private

  def allowed_params
    params.require(:wager).permit(
      :title,
      :date_of_wager,
      :details,
      :amount
    )
  end

  def send_the_appropriate_notification_email(wageree, wager)
    if wageree.is_a?(User)
      WagerMailer.send_registered_user_wager(wager).deliver
      flash[:notice] = "Your proposed wager has been sent to #{wageree.username}."
    elsif wageree.is_a?(NonRegisteredWageree)
      non_registered_wageree = NonRegisteredWageree.create!(wager_id: wager.id, email: wageree.email)
      WagerMailer.send_non_registered_user_wager(non_registered_wageree).deliver
      flash[:notice] = "A solicitation email has been sent to #{non_registered_wageree.email}"
    else
      flash[:notice] = "No username was provided.  Your wager is listed in the public wagers section"
    end
  end


  def find_the_proposed_wageree(wageree_username_or_email)
    found_user = User.find_by(username: wageree_username_or_email) || User.find_by(email: wageree_username_or_email)
    if found_user
      found_user
    elsif wageree_username_or_email.include?("@")
      NonRegisteredWageree.new(email: wageree_username_or_email)
    else
      nil
    end
  end

  def lock_down_wager_if_accepted(action, wager_id)
    if action == "Shake on it!"
      #<<<<< The below line and the if == nil code were added to address the situations where a wagerer has withdrawn a bet, it has been accepted, or expired
      #before the wageree refreshing his view.  This ensures that if the bet is no longer "available", a user that tries to accept it, gets a message stating
      #that it had been withdrawn.
      wager = Wager.where(id: wager_id).where(status: "w/wageree").first
      if wager == nil
        flash[:notice] = "Wager has already been accepted, withdrawn or expired."
      elsif the_user_has_insufficient_funds_for_the_size_of_the_transaction(wager.amount / 100, "available")
        flash[:notice] = "You don't have adequate funds to accept this wager.  Please add additional funds to your account."
      else
        wager.wageree_id = kenny_loggins.id if wager.wageree_id == nil
        wager.status = "accepted"
        Chip.set_status_to_wagered(kenny_loggins.id, wager.amount) if wager.save!
      end
    end
  end

  def cancel_wager_if_wager_declined(action, wager_id)
    if action == "No Thx!"
      wager = Wager.where(id: wager_id).where(status: "w/wageree").first
      wager.status = "declined"
      Chip.set_status_to_available(wager.user_id, wager.amount) if wager.save!
    end
  end

  def assign_the_win_if_outcome_is_determined(action, wager_id)
    wager = Wager.where(id: wager_id, status: "accepted").first
    if action == "I Won"
      wager.assign_the_win(kenny_loggins, wager)
      wager.save!
    elsif action == "I Lost"
      wager.assign_the_loss(kenny_loggins, wager)
      Chip.sweep_the_pot(kenny_loggins, wager) if wager.save!
    end
  end

  def check_outcome_of_game(action, wager_id)
    wager = Wager.where(id: wager_id, status: "accepted").first
    if action == "Check Outcome"

      # game_id = wager.id
      selected_winner_id = wager.selected_winner_id
      game_outcome = SportsGameOutcome.get_final_score(wager.game_week, wager.vs_id, wager.home_id)

      if game_outcome
        if game_outcome.status == "closed"
          winning_team = if game_outcome.home_score > game_outcome.visitor_score
                     game_outcome.home_id
                   else
                     game_outcome.vs_id
                   end
          loser =  if winning_team == selected_winner_id
                    User.find(wager.wageree_id)
                  else
                    User.find(wager.user_id)
                  end
          wager.assign_the_loss(loser, wager)
          Chip.sweep_the_pot(loser, wager) if wager.save!
          wager.details = "#{game_outcome.vs_id}: #{game_outcome.visitor_score} #{game_outcome.home_id}: #{game_outcome.home_score} QTR:#{game_outcome.quarter}-Time:#{game_outcome.clock} "
        else
          flash[:notice] = "The Game is not over.  #{game_outcome.vs_id}: #{game_outcome.visitor_score} #{game_outcome.home_id}: #{game_outcome.home_score} QTR:#{game_outcome.quarter}-Time:#{game_outcome.clock} "
        end

      else
        flash[:notice] = "The Game has not started."
      end

    end
  end

end
