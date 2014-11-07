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


  def self.get_final_score(week_number, vs_id, home_id, game_uuid)

    existing_game_outcome = SportsGamesOutcome.where(game_uuid:  game_uuid).where(status: "closed").first

    if existing_game_outcome
      return existing_game_outcome

    elsif SportsGame.find_by(uuid: game_uuid).date < DateTime.now.utc
      request = get("/nfl-t1/2014/REG/#{week_number}/#{vs_id}/#{home_id}/boxscore.json?api_key=#{ENV["SD_NFL_KEY"]}")
      if request.body != ""
        response = JSON.parse(request.body)
        game_outcome = SportsGamesOutcome.find_or_create_by!(game_uuid: response["id"])
        game_outcome.home_id = response["home_team"]["id"]
        game_outcome.vs_id = response["away_team"]["id"]
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



end