class SportsGame < ActiveRecord::Base

  def self.remaining_games
    where('date > ?', DateTime.now.utc)
  end

end
