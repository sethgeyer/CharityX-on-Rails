class SportsGame < ActiveRecord::Base





  # def self.get_final_score(week_number, vs_id, home_id)
  #   response = JSON.parse(get("/nfl-t1/2014/REG/#{week_number}/#{vs_id}/#{home_id}/boxscore.json?api_key=#{ENV["SD_NFL_KEY"]}").body)
  #   home_score = response["home_team"]["points"]
  #   visitor_score = response["away_team"]["points"]
  #   status = response["status"]
  #   quarter = response["quarter"]
  #   clock = response["clock"]
  #   if status == "closed"
  #     if home_score > visitor_score
  #       response["home_team"]["id"]
  #     else
  #       response["away_team"]["id"]
  #     end
  #   else
  #     nil
  #   end
  #end











end