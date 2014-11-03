class SportsGame
  attr_accessor :id, :vs_id, :visiting_team, :home_id, :home_team, :date, :winner_id

  def initialize(game_hash)
    @id = game_hash["game_id"]
    @vs_id = game_hash["vs_id"]
    @visiting_team = game_hash["visiting_team"]
    @home_id = game_hash["home_id"]
    @home_team = game_hash["home_team"]
    @date = game_hash["date"]
    @winner_id = game_hash["winner_id"]

  end




  def self.all
    raw_json = "[{\"game_id\":1,\"vs_id\":10,\"visiting_team\":\"Broncos\",\"home_id\":11,\"home_team\":\"Patriots\",\"date\":\"2014-11-05\",\"winner_id\":null},{\"game_id\":2,\"vs_id\":20,\"visiting_team\":\"Redskins\",\"home_id\":21,\"home_team\":\"Vikings\",\"date\":\"2014-11-06\",\"winner_id\":null},{\"game_id\":3,\"vs_id\":30,\"visiting_team\":\"Jets\",\"home_id\":31,\"home_team\":\"Chargers\",\"date\":\"2014-11-07\",\"winner_id\":null},{\"game_id\":4,\"vs_id\":40,\"visiting_team\":\"Colts\",\"home_id\":41,\"home_team\":\"Giants\",\"date\":\"2014-11-08\",\"winner_id\":null}]"
    response = JSON.parse(raw_json)

    response.map do |response_hash|
      SportsGame.new(response_hash)
    end
  end


  def self.find(id)

    raw_json = "{\"game_id\":1,\"vs_id\":10,\"visiting_team\":\"Broncos\",\"home_id\":11,\"home_team\":\"Patriots\",\"date\":\"2014-11-05\",\"winner_id\":10}"
    response = JSON.parse(raw_json)
    SportsGame.new(response)
  end











end