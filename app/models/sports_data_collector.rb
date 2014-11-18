class SportsDataCollector

  FULL_TEAM_NAMES = {
    "ARI"=> "Arizona Cardinals",
    "ATL"=> "Atlanta Falcons",
    "BAL"=> "Baltimore Ravens",
    "BUF"=> "Buffalo Bills",
    "CAR"=> "Carolina Panthers",
    "CHI"=> "Chicago Bears",
    "CIN"=> "Cincinnati Bengals",
    "CLE"=> "Cleveland Browns",
    "DAL"=> "Dallas Cowboys",
    "DEN"=> "Denver Broncos",
    "DET"=> "Detroit Lions",
    "GB"=> "Green Bay Packers",
    "HOU"=> "Houston Texans",
    "IND"=>"Indianapolis Colts",
    "JAC"=> "Jacksonville Jaguars",
    "KC"=> "Kansas City Chiefs",
    "MIA"=> "Miami Dolphins",
    "MIN"=> "Minnesota Vikings",
    "NE" => "New England Patriots",
    "NO"=> "New Orleans Saints",
    "NYG"=> "New York Giants",
    "NYJ"=> "New York Jets",
    "OAK"=> "Oakland Raiders",
    "PHI"=> "Philadelphia Eagles",
    "PIT"=> "Pittsburgh Steelers",
    "TB"=> "Tampa Bay Bucaneers",
    "TEN"=> "Tennessee Titans",
    "SD"=> "San Diego Chargers",
    "SF"=> "San Francisco 49ers",
    "SEA"=> "Seattle Seahawks",
    "STL"=> "St. Louis Rams",
    "WAS"=> "Washington Redskins"
  }




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
    SportsGame.destroy_all
    raw_data = JSON.parse(get("/nfl-t1/2014/REG/schedule.json?api_key=#{ENV["SD_NFL_KEY"]}").body)
    raw_data["weeks"].each do |week_hash|
      @games = week_hash["games"].each do |game_hash|

        SportsGame.create!(uuid: game_hash["id"],
                           date: game_hash["scheduled"],
                           week: week_hash["number"],
                           home_id: game_hash["home"],
                           vs_id: game_hash["away"],
                           status: game_hash["status"],
                           venue: game_hash["venue"]["name"],
                           temperature: game_hash["weather"]["temperature"],
                           condition: game_hash["weather"]["condition"],
                           full_home_name: FULL_TEAM_NAMES[game_hash["home"]],
                           full_visitor_name: FULL_TEAM_NAMES[game_hash["away"]]
        )
      end
    end
    SportsGame.all.count



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