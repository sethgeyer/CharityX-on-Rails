require 'rails_helper'
require 'capybara/rails'


feature "visitor registration" do

  scenario "visitor fills in registration form completely and accurately" do
    fill_in_registration_form("Stephen")
    expect(page).to have_content("Thanks for registering stephen.  You are now logged in.")
    expect(page).to have_link("Logout")
    expect(page).not_to have_button("Login")
    expect(page).not_to have_link("Sign Up")
    expect(page).to have_link("Edit Profile")
    expect(page).to have_css("#show_dashboards")
  end

  scenario "registered visitor completes login form correctly and routes to show page for the user" do
    create_user("Stephen")
    visit "/"
    login_a_registered_user("Stephen")
    expect(page).to have_content("Welcome stephen")
    expect(page).to have_link("Logout")
    expect(page).not_to have_button("Login")
    expect(page).not_to have_link("Sign Up")
    expect(page).to have_link("Edit Profile")
    expect(page).to have_link("Charities")
    expect(page).to have_css("#show_dashboards")
  end

  scenario "visitor fills in registration form only partially" do
    name = "Stephen"
    visit "/users/new"
    within(page.find(".registration")) { fill_in "Email", with: "#{name}@gmail.com" }
    within(page.find(".registration")) { fill_in "Password", with: name.downcase }
    within(page.find(".registration")) { click_on "Submit" }
    expect(page).to have_css("#new_users")
    expect(page).to have_content("Username can't be blank")
  end


  scenario "visitor fills in registration form using an '@' symbol" do
    name = "Stephen"
    visit "/users/new"
    within(page.find(".registration")) { fill_in "Username", with: "@#{name.downcase}y" }
    within(page.find(".registration")) { fill_in "Email", with: "#{name}@gmail.com" }
    within(page.find(".registration")) { fill_in "Password", with: name.downcase }
    within(page.find(".registration")) { click_on "Submit" }
    expect(page).to have_css("#new_users")
    expect(page).to have_content("can only be letters, underscore, or numbers")
  end

  scenario "visitor fills in registration form using a non-unique username" do
    user = create_user("Stephen")
    name = "Stephen"
    visit "/users/new"
    within(page.find(".registration")) { fill_in "Username", with: user.username }
    within(page.find(".registration")) { fill_in "Email", with: "#{name}@gmail.com" }
    within(page.find(".registration")) { fill_in "Password", with: "password" }
    within(page.find(".registration")) { click_on "Submit" }
    expect(page).to have_css("#new_users")
    expect(page).to have_content("Username is not unique.  Please select another.")
  end

  scenario "visitor fills in registration form using a non-unique email" do
    user = create_user("Stephen")
    name = "Stephen"
    visit "/users/new"
    within(page.find(".registration")) { fill_in "Username", with: "lancey" }
    within(page.find(".registration")) { fill_in "Email", with: user.email }
    within(page.find(".registration")) { fill_in "Password", with: "password" }
    within(page.find(".registration")) { click_on "Submit" }
    expect(page).to have_css("#new_users")
    expect(page).to have_content("already exists")
  end



end
