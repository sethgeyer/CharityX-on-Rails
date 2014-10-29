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

def create_user_and_make_a_deposit_to_their_account(first_name, amount)
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
  chips = (amount / 10 ).times {user.chips.create!(status: "available")}
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

