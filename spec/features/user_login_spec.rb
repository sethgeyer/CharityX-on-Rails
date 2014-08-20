require 'rails_helper'
require 'capybara/rails'


feature "visitor login" do
  before(:each) do
    visit "/"
  end

  scenario "non-registered visitor tries to login or visitor logs in w/ incorrect credentials" do
    fill_in "Username", with: "stepheny"
    fill_in "Password", with: "123"
    click_on "Login"
    expect(page).to have_button("Login")
    expect(page).to have_content("The credentials you entered are incorrect.  Please try again.")
    expect(page).not_to have_button("Logout")
    expect(page).to have_link("Sign Up")
    expect(page).not_to have_link("Edit Profile")
  end

  scenario "logged in user wants to see their account details" do
    fill_in_registration_form("Stephen")
    click_on "Account Details"
    expect(page).to have_css("#show_users")
  end

  scenario "registered user logs in" do
    fill_in_registration_form("Stephen")
    click_on "Logout"
    login_a_registered_user("Stephen")
    expect(page).to have_css("#show_users")
  end

end

