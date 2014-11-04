def create_charity(name)
  Charity.create!(name: name)
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
  distributer.distributions.create!(amount: amount * 100, charity_id: charity_1.id, date: Date.today)
  (amount / 10).times do | time |
    distributed_chips = distributer.chips.where(status: "available").first
    distributed_chips.status = "distributed"
    distributed_chips.save!
  end
end

def create_a_broncos_patriots_wager(wagerer_first_name, wageree_first_name, amount)
  wagerer = User.find_by(username: wagerer_first_name.downcase)
  wageree = User.find_by(username: wageree_first_name.downcase)
  wagerer.wagers.create!(title: "The Patriots beat the Broncos",
                         date_of_wager: Date.today + 2.days,
                         amount: amount * 100, wageree_id: wageree.id,
                         status: "accepted",
                         wager_type: "SportsWager",
                         game_id: 1,
                         selected_winner_id: "NE")

  (amount / 10).times do | time |
    wagerer_chips = wagerer.chips.where(status: "available").first
    wageree_chips = wageree.chips.where(status: "available").first
    wagerer_chips.status = "wagered"
    wageree_chips.status = "wagered"
    wagerer_chips.save!
    wageree_chips.save!
  end
end



