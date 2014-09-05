require 'rails_helper'
require 'capybara/rails'


feature "viewing and creating charities" do
  before(:each) do
    visit "/charities"
  end

  scenario "As a charity, I can apply to register my charity with charity exchange" do
    click_on "Register a new charity"
    register_a_new_charity("United Way")
    expect(page).to have_content("Thanks for applying")
    expect(page).to have_content("United Way")
  end

  scenario "As an visitor, I can see an index of all charities" do
    visit "/charities/new"
    register_a_new_charity("Red Cross")
    visit "/charities/new"
    register_a_new_charity("United Way")
    expect(page).to have_css("#index_charities")
    expect(page).to have_content("Red Cross")
    expect(page).to have_content("United Way")
  end

  scenario "As a charity, I can cancel a registration and return to the index page" do
    visit "/charities/new"
    click_on "Cancel"
    expect(page).to have_css("#index_charities")
  end

end