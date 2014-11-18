class UpdateWager
  attr_reader :update_action, :wager_id, :flash, :kenny_loggins

  def initialize(options)
    @update_action = options.fetch(:commit)
    @wager_id      = options.fetch(:id)
    @kenny_loggins = options.fetch(:kenny_loggins)
    @flash         = options.fetch(:flash)
  end

  def save!
    ActiveRecord::Base.transaction do
      lock_down_wager_if_accepted(update_action, wager_id)

      Wager.cancel_wager_if_wager_declined(update_action, wager_id)
      check_outcome_of_game(update_action, wager_id)
      assign_the_win_if_outcome_is_determined(update_action, wager_id)
    end
  end

  private

  def lock_down_wager_if_accepted(action, wager_id)
    if action == "Shake on it!"
      #<<<<< The below line and the if == nil code were added to address the situations where a wagerer has withdrawn a bet, it has been accepted, or expired
      #before the wageree refreshing his view.  This ensures that if the bet is no longer "available", a user that tries to accept it, gets a message stating
      #that it had been withdrawn.
      wager = Wager.where(id: wager_id).where(status: "w/wageree").first

      if wager == nil
        flash[:notice] = "Wager has already been accepted, withdrawn or expired."
      elsif kenny_loggins.insufficient_funds_for(wager.amount / 100, "available")
        flash[outcome_update_symbol(wager_id)] = "You don't have adequate funds to accept this wager.  Please add additional funds to your account."
      else
        wager.wageree_id = kenny_loggins.id if wager.wageree_id == nil
        wager.status = "accepted"
        WagerMailer.send_wager_acceptance_email(wager).deliver
        Chip.set_status_to_wagered(kenny_loggins.id, wager.amount) if wager.save!
        flash[outcome_update_symbol(wager_id)] = "You have accepted this wager."
      end
    end
  end



  def assign_the_win_if_outcome_is_determined(action, wager_id)
    wager = Wager.where(id: wager_id, status: "accepted").first
    if action == "I Won" && wager
      wager.assign_the_win(kenny_loggins, wager)
      wager.save!
    elsif action == "I Lost"  && wager
      wager.assign_the_loss(kenny_loggins, wager)
      Chip.sweep_the_pot(kenny_loggins, wager) if wager.save!
    end
  end

  def check_outcome_of_game(action, wager_id)
    wager = Wager.where(id: wager_id, status: "accepted").first
    if action == "Check Outcome" && wager
      # game_id = wager.id
      selected_winner_id = wager.selected_winner_id

      game_outcome = SportsDataCollector.get_final_score(wager.game_week, wager.vs_id, wager.home_id, wager.game_uuid)
      if game_outcome
        if game_outcome.status == "closed"
          winning_team = if game_outcome.home_score > game_outcome.vs_score
                           game_outcome.home_id
                         else
                           game_outcome.vs_id
                         end
          loser = if winning_team == selected_winner_id
                    User.find(wager.wageree_id)
                  else
                    User.find(wager.user_id)
                  end
          wager.assign_the_loss(loser, wager)
          Chip.sweep_the_pot(loser, wager) if wager.save!
          wager.details = "#{game_outcome.vs_id}: #{game_outcome.vs_score} #{game_outcome.home_id}: #{game_outcome.home_score} QTR:#{game_outcome.quarter}-Time:#{game_outcome.clock} "
        else
          flash[outcome_update_symbol(wager_id)] = "#{game_outcome.vs_id}: #{game_outcome.vs_score} #{game_outcome.home_id}: #{game_outcome.home_score} QTR:#{game_outcome.quarter}-Time:#{game_outcome.clock} If game over, please wait for 3rd Party verification of final score."
        end

      else
        flash[outcome_update_symbol(wager_id)] = "The #{wager.vs_id} / #{wager.home_id} game has not started."
      end
    end
  end

  def outcome_update_symbol(wager_id)
    "update-#{wager_id}".to_sym
  end
end
