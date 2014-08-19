require 'rails_helper'
require 'capybara/rails'


feature "viewing and creating charities" do
  before(:each) do
    visit "/charities"
  end

  scenario "As a charity, I can apply to register my charity with charity exchange" do
    click_on "Register a new charity"
    complete_application("United Way")

    expect(page).to have_content("Thanks for applying")
    expect(page).to have_content("United Way")
  end

  scenario "As a user, I can see the index view of all charity applications" do
    visit "/charities/new"
    complete_application("Red Cross")
    visit "/charities/new"
    complete_application("United Way")

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