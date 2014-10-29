require 'rails_helper'
require 'capybara/rails'



feature "dollar locator view" do

  before(:each) do
    @person1 = create_user_and_make_a_deposit_to_their_account("Alexander", 300)
    @person2 = create_user_and_make_a_deposit_to_their_account("Stephen", 300)


    @wager = create_an_existing_accepted_wager(@person1.first_name, @person2.first_name, 10)
    visit "/"
    login_user("Stephen")

  end

  scenario "As a user, I can view the 'Where are my dollars' table" do
    visit user_dollar_locator_path
    expect(page).to have_content("$300")
  end

  scenario "As a user, I can see my dollars actively wagered" do
    visit user_dollar_locator_path
    expect(page).to have_content("$300")
  end


end