class SportsGamesOutcomesController < ApplicationController

  before_action :ensure_admin


  def index


    #find me all the current accepted wagers.... aka: wagers that have not been completed or pending w/ wageree
    accepted_sports_wagers = Wager.where(wager_type: "SportsWager").where(status: "accepted")


    games = accepted_sports_wagers.map do |wager|
      SportsGame.find_by(uuid: wager.game_uuid)
    end

    games.uniq!

    undecided_outcomes = SportsGamesOutcome.where('status != ?', 'closed')

    undecided_outcomes.destroy_all



    new_outcomes = games.map do |game|

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

      SportsDataCollector.get_final_score(new_outcome.week, new_outcome.vs_id, new_outcome.home_id)

    end

    flash[:notice] = "#{new_outcomes.count} game outcome has been updated"
    redirect_to root_path
  end
end


#you need to be able have the individual wagers be updates when "refresh outcome is run"