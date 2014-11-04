class SportsGame
  attr_accessor :id, :vs_id, :visiting_team, :home_id, :home_team, :date, :winner_id, :week, :venue, :temperature, :condition, :full_home_name, :full_visitor_name

  def initialize(game_hash, week_number)
    full_name = {
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



    @id = game_hash["id"]
    @date = game_hash["scheduled"]
    @home_team = game_hash["home"]
    @home_id = game_hash["home"]
    @visiting_team = game_hash["away"]
    @vs_id = game_hash["away"]
    @status = game_hash["status"]
    @week = week_number
    @winner_id = game_hash["winner_id"]
    @venue = game_hash["venue"]["name"]
    @temperature = game_hash["weather"]["temperature"]
    @condition = game_hash["weather"]["condition"]
    @full_home_name = full_name[game_hash["home"]]
    @full_visitor_name = full_name[game_hash["away"]]



  end


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
    @all_games = []
    response["weeks"].each do |week_hash|
      @games = week_hash["games"].map do |game_hash|
      SportsGame.new(game_hash, week_hash["number"]) if DateTime.strptime(game_hash["scheduled"]) > DateTime.now.utc
      end
      @all_games << @games.compact
    end
    @all_games.flatten
  end


  def self.get_final_score(week_number, vs_id, home_id)
    response = JSON.parse(get("/nfl-t1/2014/REG/#{week_number}/#{vs_id}/#{home_id}/boxscore.json?api_key=#{ENV["SD_NFL_KEY"]}").body)
    home_score = response["home_team"]["points"]
    visitor_score = response["away_team"]["points"]
    status = response["status"]
    quarter = response["quarter"]
    clock = response["clock"]
    if status == "closed"
      if home_score > visitor_score
        response["home_team"]["id"]
      else
        response["away_team"]["id"]
      end
    else
      nil
    end
  end











end