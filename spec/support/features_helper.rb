def create_charity(name)
  Charity.create!(name: name, tax_id: 34522323, poc: "Stanley Giver", poc_email: "stanley")
end

def create_admin(first_name)
  attributes = {
    username: first_name.downcase,
    password: 'password',
    first_name: first_name,
    last_name: 'Geyer',
    email: "#{first_name.downcase}@gmail.com",
    is_admin: true
  }
  User.create!(attributes)
end


def create_user(first_name)
  attributes = {
    username: first_name.downcase,
    password: 'password',
    first_name: first_name,
    last_name: 'Geyer',
    email: "#{first_name.downcase}@gmail.com",
    is_admin: false
  }
  User.create!(attributes)
end

def create_user_and_make_deposit(first_name, amount, date = Date.today)
  attributes = {
  username: first_name.downcase,
  password: 'password',
  first_name: first_name,
  last_name: 'Geyer',
  email: "#{first_name.downcase}@gmail.com",
  is_admin: false
  }
  user = User.create!(attributes)
  deposit = user.deposits.create!(amount: (amount * 100))
  chips = (amount / 10 ).times {user.chips.create!(status: "available", owner_id: user.id, created_at: date )}
  return user
end

def create_an_existing_accepted_wager(wagerer_first_name, wageree_first_name, amount)
  wagerer = User.find_by(username: wagerer_first_name.downcase)
  wageree = User.find_by(username: wageree_first_name.downcase)
  wagerer.wagers.create!(title: "Ping Pong Match", date_of_wager: Date.today + 1.week, amount: amount * 100, wageree_id: wageree.id, status: "accepted" )
  (amount / 10).times do | time |
    wagerer_chips = wagerer.chips.where(status: "available").first
    wageree_chips = wageree.chips.where(status: "available").first
    wagerer_chips.status = "wagered"
    wageree_chips.status = "wagered"
    wagerer_chips.save!
    wageree_chips.save!
  end
end

def create_a_distribution(first_name, amount)
  charity_1 = create_charity("United Way")
  charity_2 = create_charity("Red Cross")
  distributer = User.find_by(username: first_name.downcase)
  distribution = distributer.distributions.create!(amount: amount * 100, charity_id: charity_1.id, date: Date.today)
  (amount / 10).times do | time |
    distributed_chips = distributer.chips.where(status: "available").first
    distributed_chips.status = "distributed"
    distributed_chips.save!
  end
  distribution
end

def create_a_winning_sports_wager(wagerer_first_name, wageree_first_name, amount, winning_team, losing_team)
  wagerer = User.find_by(username: wagerer_first_name.downcase)
  wageree = User.find_by(username: wageree_first_name.downcase)
  wagerer.wagers.create!(title: "The #{winning_team} beat the #{losing_team}",
                         date_of_wager: Date.today + 2.days,
                         amount: amount * 100, wageree_id: wageree.id,
                         status: "accepted",
                         wager_type: "SportsWager",
                         game_id: 1,
                         selected_winner_id: winning_team )

  (amount / 10).times do | time |
    wagerer_chips = wagerer.chips.where(status: "available").first
    wageree_chips = wageree.chips.where(status: "available").first
    wagerer_chips.status = "wagered"
    wageree_chips.status = "wagered"
    wagerer_chips.save!
    wageree_chips.save!
  end
end


def create_a_sports_game(options={})
  attributes = {
    uuid: SecureRandom.uuid,
    date: Date.today + 2.days,
    week: 16,
    home_id: "CIN",
    vs_id: "DEN",
    status: "scheduled",
    venue: "Paul Brown Stadium",
    temperature: "69",
    condition: "clear",
    full_home_name: "Cincinnati Bengals",
    full_visitor_name: "Denver Broncos"
  }
  combined_attributes = attributes.merge(options)

  SportsGame.create!(combined_attributes)
end

def create_a_sports_game_outcome(game_uuid, options={})
  attributes = {
    game_uuid: game_uuid,
    home_id: "CIN",
    home_score: 36,
    vs_id: "GB",
    vs_score: 16,
    status: "closed",
    quarter: 0,
    clock: ":00"
  }

  combined_attributes = attributes.merge(options)

  SportsGamesOutcome.create!(combined_attributes)
end


def create_a_sports_wager(game_uuid, wagerer_id, wageree_id, amount, home_id, vs_id)

  Wager.create!(title: "The #{home_id} beat the #{vs_id}",
                 date_of_wager: Date.today + 2.days,
                 amount: amount * 100,
                 user_id: wagerer_id,
                 wageree_id: wageree_id,
                 status: "accepted",
                 wager_type: "SportsWager",
                 game_uuid: game_uuid,
                 home_id: home_id,
                 vs_id: vs_id,
                 selected_winner_id: home_id )
end


