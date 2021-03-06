if ENV['CI']
  require 'coveralls'
  Coveralls.wear!('rails')
end

def register_a_new_charity(charity_name)

end

def timezone_adjusted_datetime(utc_time, admin)
  "#{utc_time.in_time_zone(admin.timezone).strftime("%a %e-%b-%y %l:%M %p")} (loc)"
end


def make_a_deposit_to_their_account(deposit_amount)
  within(page.find("#fund-my-account")) {click_link "+"}
  fill_in "Amount", with: deposit_amount
  click_on "Submit"
end

def login_user(name)
  fill_in "Username", with: "#{name.downcase}"
  fill_in "Password", with: "password"
  click_on "Login"
end

def fill_in_registration_form(first_name)
  visit "/users/new"
  within(page.find(".registration")) {fill_in "First name", with: first_name}
  within(page.find(".registration")) {fill_in "Last name", with: "Theuser"}
  within(page.find(".registration")) { fill_in "Username", with: "#{first_name.downcase}" }
  within(page.find(".registration")) { fill_in "Email", with: "#{first_name.downcase}@gmail.com" }
  within(page.find(".registration")) { fill_in "Password", with: "password" }
  within(page.find(".registration")) { click_on "Submit" }
end


def distribute_funds_from_my_account(distribution_amount, charity)
  within(page.find("#distribute-funds")) {click_link "+"}
  fill_in "Amount", with: distribution_amount
  select charity, from: "Charity"
  click_on "Submit"
end

def create_a_new_unaccepted_wager(wagerer, wageree, amount)
  within(page.find("#wager-funds")) {click_link "+"}
  fill_in "wager_title", with: "Ping Pong Match between S & A"
  fill_in "wager[date_of_wager]", with: Date.today + 2.days
  fill_in "wager_details", with: "Game to 21, standard rules apply"
  fill_in "wager_amount", with: amount
  fill_in "With:", with: "alexander"
  click_on "Submit"
end

def create_a_public_wager(wagerer, potential_wageree1, potential_wageree2 )
  within(page.find("#wager-funds")) {click_link "+"}
  fill_in "wager_title", with: "Public Ping Pong"
  fill_in "wager[date_of_wager]", with: Date.today + 2.days
  fill_in "wager_details", with: "Game to 21, standard rules apply"
  fill_in "wager_amount", with: 10
  fill_in "With:", with: ""
  click_on "Submit"
end

def user_creates_a_solicitation_wager(wagererTheUser, wagereeTheNonUser)
  fill_in_registration_form(wagererTheUser)
  make_a_deposit_to_their_account(100)
  within(page.find("#wager-funds")) {click_link "+"}
  fill_in "wager_title", with: "Ping Pong"
  fill_in "wager[date_of_wager]", with: Date.today + 2.days
  fill_in "wager_details", with: "Game to 21, standard rules apply"
  fill_in "wager_amount", with: 10
  fill_in "With:", with: "#{wagereeTheNonUser.downcase}@gmail.com"
  click_on "Submit"
end
