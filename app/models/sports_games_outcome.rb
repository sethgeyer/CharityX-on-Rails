class SportsGamesOutcome < ActiveRecord::Base


  def self.display_outcome(game_uuid)
    sports_game_outcome = SportsGamesOutcome.where(game_uuid:  game_uuid, status: "closed").first
    if sports_game_outcome
      "#{sports_game_outcome.vs_id}: #{sports_game_outcome.vs_score}  #{sports_game_outcome.home_id}: #{sports_game_outcome.home_score} |"
    else
      nil
    end
  end

  def self.remove_incomplete_outcomes
    undecided_outcomes = SportsGamesOutcome.where('status != ?', 'closed')
    undecided_outcomes.destroy_all
  end

  def self.gather_game_outcome_updates(wagered_sports_games)
    new_outcomes =  wagered_sports_games.map do |game|

      if SportsGamesOutcome.find_by(game_uuid: game.uuid)
        # if I can find the game in SportsGameOutcome (after destroying everything that is not already closed, then it must be already closed)
      elsif game.status != "scheduled" && game.status != "created"
        # if I can not find the game, and it is not scheduled, then it must be in process or the game must have just finished
        SportsGamesOutcome.create!(game_uuid: game.uuid,
                                   home_id: game.home_id,
                                   vs_id: game.vs_id,
                                   week: game.week,
        )
      end
    end
    new_outcomes.compact!
    new_outcomes.each do |new_outcome|

      SportsDataCollector.get_final_score(new_outcome.week, new_outcome.vs_id, new_outcome.home_id, new_outcome.game_uuid)

    end


  end




end