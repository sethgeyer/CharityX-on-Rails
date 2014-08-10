# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
# User.destroy_all
# TaskList.destroy_all



user1 = User.create!(username: "seth", email: "seth@gmail.com", ssn: "223334444", is_admin: true, password: 'password')
account1 = Account.create!(user_id: user1.id)
deposit1 = Deposit.create!(account_id: account1.id, amount: 40000, cc_number: 111, exp_date: "2019-07-15", name_on_card: "Seth Geyer", cc_type: "Visa")

user2 = User.create!(username: "alex", email: "alex@gmail.com", ssn: "112223333", is_admin: false, password: 'password')
account2 = Account.create!(user_id: user2.id)
deposit1 = Deposit.create!(account_id: account2.id, amount: 30000, cc_number: 222, exp_date: "2019-07-15", name_on_card: "Alex McRitchie", cc_type: "Visa")

user3 = User.create!(username: "stan", email: "stan@gmail.com", ssn: "334445555", is_admin: false, password: 'password')
account3 = Account.create!(user_id: user3.id)
deposit1 = Deposit.create!(account_id: account3.id, amount: 30000, cc_number: 333, exp_date: "2019-07-15", name_on_card: "Stan Smith", cc_type: "Visa")

charity1 = Charity.create!(name: "United Way", tax_id: 333, poc: "Ulysess Williams", poc_email: "uw@unitedway.com", status: "registered")
charity2 = Charity.create!(name: "Red Cross", tax_id: 444, poc: "Ray Crumb", poc_email: "rc@redcross.com", status: "registered")

