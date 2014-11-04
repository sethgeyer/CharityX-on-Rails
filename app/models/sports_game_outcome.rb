class SportsGameOutcome
  attr_accessor :home_score, :visitor_score, :status, :quarter, :clock, :home_id, :vs_id

  def initialize(response)

    @home_id = response["home_team"]["id"]
    @vs_id = response["away_team"]["id"]

    @home_score = response["home_team"]["points"]
    @visitor_score = response["away_team"]["points"]
    @status = response["status"]
    @quarter = response["quarter"]
    @clock = response["clock"]

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


  def self.get_final_score(week_number, vs_id, home_id)
    response = JSON.parse(get("/nfl-t1/2014/REG/#{week_number}/#{vs_id}/#{home_id}/boxscore.json?api_key=#{ENV["SD_NFL_KEY"]}").body)
    SportsGameOutcome.new(response)
  end

end