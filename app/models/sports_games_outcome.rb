class SportsGamesOutcome < ActiveRecord::Base

    # @home_id = response["home_team"]["id"]
    # @vs_id = response["away_team"]["id"]
    #
    # @home_score = response["home_team"]["points"]
    # @visitor_score = response["away_team"]["points"]
    # @status = response["status"]
    # @quarter = response["quarter"]
    # @clock = response["clock"]

  def self.display_outcome(game_uuid)
    sports_game_outcome = SportsGamesOutcome.where(game_uuid:  game_uuid, status: "closed").first
    if sports_game_outcome
      "#{sports_game_outcome.vs_id}: #{sports_game_outcome.vs_score}  #{sports_game_outcome.home_id}: #{sports_game_outcome.home_score} |"
    else
      nil
    end
  end
end