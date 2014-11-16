
User.destroy_all
Chip.destroy_all
Deposit.destroy_all
Charity.destroy_all



user1 = User.create!(username: "seth", first_name: "Seth", last_name: "Geyer", email: "seth@gmail.com", is_admin: true, password: 'password', timezone: "Mountain Time (US & Canada)")
deposit1 = Deposit.create!(user_id: user1.id, amount: 40000, cc_number: 111, exp_date: "2019-07-15", name_on_card: "Seth Geyer", cc_type: "Visa", date_created: "2014-08-15")
40.times {
  Chip.create!(user_id: user1.id, owner_id: user1.id, status: "available", charity_id: nil, cashed_in_date: nil)
}


user2 = User.create!(username: "alex", first_name: "Alex", last_name: "McRitch", email: "alex@gmail.com", is_admin: false, password: 'password', timezone: "Mountain Time (US & Canada)")
deposit2 = Deposit.create!(user_id: user2.id, amount: 30000, cc_number: 222, exp_date: "2019-07-15", name_on_card: "Alex McRitchie", cc_type: "Visa", date_created: "2014-08-15")
30.times {
  Chip.create!(user_id: user2.id, owner_id: user2.id, status: "available", charity_id: nil, cashed_in_date: nil)
}

user3 = User.create!(username: "stan", first_name: "Stan", last_name: "Lee", email: "stan@gmail.com", is_admin: false, password: 'password', timezone: "Mountain Time (US & Canada)")
deposit3 = Deposit.create!(user_id: user3.id, amount: 30000, cc_number: 333, exp_date: "2019-07-15", name_on_card: "Stan Smith", cc_type: "Visa", date_created: "2014-08-15")
30.times {
  Chip.create!(user_id: user3.id, owner_id: user3.id, status: "available", charity_id: nil, cashed_in_date: nil)
}

user4 = User.create!(username: "steve", first_name: "Steve", last_name: "Ward", email: "steve@gmail.com", is_admin: false, password: 'password', timezone: "Mountain Time (US & Canada)")
charity1 = Charity.create!(name: "United Way", tax_id: 333, poc: "Ulysess Williams", poc_email: "uw@unitedway.com", status: "registered")
charity2 = Charity.create!(name: "Red Cross", tax_id: 444, poc: "Ray Crumb", poc_email: "rc@redcross.com", status: "registered")

