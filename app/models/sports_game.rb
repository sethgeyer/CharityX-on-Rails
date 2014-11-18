class SportsGame < ActiveRecord::Base

  def self.remaining_games
    where('date > ?', DateTime.now.utc)
  end

  def self.find_games_with_wagers
    #find me all the current accepted wagers.... aka: wagers that have not been completed or pending w/ wageree
    accepted_sports_wagers = Wager.where(wager_type: "SportsWager").where(status: "accepted")

    games = accepted_sports_wagers.map do |wager|
      SportsGame.find_by(uuid: wager.game_uuid)
    end

    games.uniq!
  end


end
