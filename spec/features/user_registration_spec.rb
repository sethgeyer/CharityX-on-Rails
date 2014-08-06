require 'rails_helper'
require 'capybara/rails'


feature "visitor registration" do

  scenario "visitor fills in registration form completely and accurately" do
    fill_in_registration_form("Stephen")
    expect(page).to have_content("Thanks for registering stepheny.  You are now logged in.")
    expect(page).to have_button("Logout")
    expect(page).not_to have_button("Login")
    expect(page).not_to have_link("Sign Up")
    expect(page).to have_link("Edit Profile")
    expect(page).to have_css("#show_users")
  end

  scenario "registered visitor completes login form correctly and routes to show page for the user" do
    fill_in_registration_form("Stephen")
    click_on "Logout"
    login_a_registered_user("Stephen")

    expect(page).to have_content("Welcome stepheny")
    expect(page).to have_button("Logout")
    expect(page).not_to have_button("Login")
    expect(page).not_to have_link("Sign Up")
    expect(page).to have_link("Edit Profile")
    expect(page).to have_link("Charities")
    expect(page).to have_css("#show_users")
  end

  scenario "visitor fills in registration form only partially" do
    name = "Stephen"
    visit "/users/new"
    # fill_in "Username", with: "#{name.downcase}y"
    fill_in "SSN", with: "377993333"
    fill_in "Email", with: name
    fill_in "Password", with: name.downcase
    click_on "Submit"

    expect(page).to have_css("#new_users")
    expect(page).to have_content("Username can't be blank")
  end

  scenario "visitor fills in registration form using a non-unique username" do
    fill_in_registration_form("Stephen")
    click_on "Logout"
    name = "Stephen"
    visit "/users/new"
    fill_in "Username", with: "#{name.downcase}y"
    fill_in "SSN", with: "377993333"
    fill_in "Email", with: name
    fill_in "Password", with: name.downcase
    fill_in "Profile picture", with: "http://google.com"
    click_on "Submit"

    expect(page).to have_css("#new_users")
    expect(page).to have_content("Username is not unique.  Please select another.")
  end

end
