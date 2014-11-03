class SportsGame
  attr_accessor :id, :vs_id, :visiting_team, :home_id, :home_team, :date, :winner_id, :week, :venue, :temperature, :condition

  def initialize(game_hash, week_number)
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


  def self.find(id)

    raw_json = "{\"game_id\":1,\"vs_id\":10,\"visiting_team\":\"Broncos\",\"home_id\":11,\"home_team\":\"Patriots\",\"date\":\"2014-11-05\",\"winner_id\":10}"
    response = JSON.parse(raw_json)
    SportsGame.new(response)
  end











end