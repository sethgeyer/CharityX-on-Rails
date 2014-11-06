class SportsGamesController < ApplicationController



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




  def create
    raw_data = SportsDataCollector.all
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
        ) #if DateTime.strptime(game_hash["scheduled"]) > DateTime.now.utc
      end
    end

    flash[:notice] = "#{SportsGame.all.count} NFL Games have been created"

    redirect_to root_path
  end


  def index

  end

end