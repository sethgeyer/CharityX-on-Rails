require 'rails_helper'
require 'capybara/rails'

feature "viewing and creating charities" do

  scenario "As a charity, I can apply to register my charity" do
    visit "/charities"
    click_on "Register a new charity"
    fill_in "Charity Name", with: "United Way"
    fill_in "Federal Tax ID", with: 123456789
    fill_in "Primary POC", with: "Al Smith"
    fill_in "POC Email", with: "alsmith@gmail.com"
    click_on "Submit"
    expect(page).to have_content("Thanks for applying")
    expect(page).to have_content("United Way")
  end

  scenario "As a visitor, I can see an index of all registered charities" do
    create_charity("Red Cross")
    create_charity("United Way")
    visit "/charities"
    expect(page).to have_css("#index_charities")
    expect(page).to have_content("Red Cross")
    expect(page).to have_content("United Way")
  end

  scenario "As a visitor, I can cancel a charity registration and return to the index page of charities" do
    visit "/charities/new"
    click_on "Cancel"
    expect(page).to have_css("#index_charities")
  end

end