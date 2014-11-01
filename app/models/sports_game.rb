class SportsGame





  def all
    [{game_id: 1, vs_id: 10, visiting_team: "Broncos", home_id: 11, home_team: "Patriots", date: Date.today + 2.day, winner_id: nil },
                     {game_id: 2, vs_id: 20, visiting_team: "Redskins",home_id: 21, home_team: "Vikings",  date: Date.today + 3.days, winner_id: nil },
                     {game_id: 3, vs_id: 30, visiting_team: "Jets", home_id: 31, home_team: "Chargers",  date: Date.today + 4.days, winner_id: nil },
                     {game_id: 4, vs_id: 40, visiting_team: "Colts", home_id: 41, home_team: "Giants",  date: Date.today + 5.days, winner_id: nil }
    ]

  end


  def find(id)
    games = [{game_id: 1, vs_id: 10, visiting_team: "Broncos", home_id: 11, home_team: "Patriots", date: Date.today + 2.day, winner_id: 10 },
             {game_id: 2, vs_id: 20, visiting_team: "Redskins",home_id: 21, home_team: "Vikings",  date: Date.today + 3.days, winner_id: 20 },
             {game_id: 3, vs_id: 30, visiting_team: "Jets", home_id: 31, home_team: "Chargers",  date: Date.today + 4.days, winner_id: 30 },
             {game_id: 4, vs_id: 40, visiting_team: "Colts", home_id: 41, home_team: "Giants",  date: Date.today + 5.days, winner_id: 40 }
    ]
    games.detect do |game|
      game[:game_id] == id
    end
  end











end