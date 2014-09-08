require 'rails_helper'
require 'capybara/rails'



feature "editing user profile" do
  before(:each) do
    fill_in_registration_form("Stephen")
  end

  scenario "user updates their user profile" do
    click_on "Edit Profile"
    fill_in "Email", with: "steve@gmail.com"
    fill_in "Password", with: "stephen1"
    click_on "Submit"
    expect(page).to have_content("Your changes have been saved")
    expect(page).to have_css("#show_dashboards")
    click_on "Edit Profile"
    expect(page).to have_selector("input[value='steve@gmail.com']")
  end

  scenario "user leaves email blank when editing" do
    click_on "Edit Profile"
    fill_in "Email", with: ""
    click_on "Submit"
    expect(page).to have_css("#edit_profiles")
    expect(page).to have_content("can't be blank")
  end


  scenario "user leaves password blank when editing" do
    click_on "Edit Profile"
    fill_in "Password", with: "sds"
    click_on "Submit"
    expect(page).to have_css("#edit_profiles")
    expect(page).to have_content("Password must be at least 7 characters")
  end


  # scenario "anyone besides the user can not change the individual's profile via the direct url" do
  #   visit "/users/5000/edit"
  #
  #   expect(page).to have_content("You are not authorized to visit this page")
  #   expect(page).to have_css("#homepage")
  # end

  scenario "user decides to cancel their edits" do
    click_on "Edit Profile"
    click_on "Cancel"
    expect(page).to have_css("#show_dashboards")
  end

end