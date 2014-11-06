class SportsDataCollector

  def self.connection
    @conn ||= begin
      conn = Faraday.new(:url => "https://api.sportsdatallc.org") do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
      conn
    end
  end

  def self.get(url)
    connection.get(url)
  end


  def self.all
    response = JSON.parse(get("/nfl-t1/2014/REG/schedule.json?api_key=#{ENV["SD_NFL_KEY"]}").body)
  end


  def self.get_final_score(week_number, vs_id, home_id)
    request = get("/nfl-t1/2014/REG/#{week_number}/#{vs_id}/#{home_id}/boxscore.json?api_key=#{ENV["SD_NFL_KEY"]}")
    if request.body != ""
      response = JSON.parse(request.body)
      game_outcome = SportsGamesOutcome.find_by(game_uuid: response["id"])
      game_outcome.home_score = response["home_team"]["points"]
      game_outcome.vs_score = response["away_team"]["points"]
      game_outcome.status = response["status"]
      game_outcome.quarter = response["quarter"]
      game_outcome.clock = response["clock"]
      game_outcome.save!
      return game_outcome
    else
      nil
    end

  end



end