require 'rails_helper'
require 'capybara/rails'

feature "password reset" do
  before(:each) do
    fill_in_registration_form("Stephen")
    click_on "Logout"
    expect(page).to have_content("Forgot Password")
    click_on "Forgot Password"
  end

  scenario "registrered user that completes the password reset INcompletely receives a reset email" do
    expect(page).to have_css("#new-password-resets")
    fill_in "Email", with: ""
    click_on "Submit"
    expect(page).to have_css("#new-password-resets")
    expect(page).to have_content("Your request can not be completed.")
  end

  scenario "registrered user that completes the password reset INcompletely receives a reset email" do
    expect(page).to have_css("#new-password-resets")
    fill_in "Email", with: "stephen@gmail.com"
    click_on "Submit"
    expect(page).to have_css("#homepage")
    expect(page).to have_content("Password reset instructions have been sent to stephen@gmail.com")
  end

  context "registered user receives the reset password email" do
    before(:each) do
      PasswordReset.create(email: "stephen@gmail.com", unique_identifier: "9999", expiration_date: Time.now + 1.day)
    end


    scenario "registered user can submit a new valid password" do
      visit "/password_resets/9999/edit"
      fill_in "New Password", with: "password"
      click_on "Submit"
      expect(page).to have_css("#homepage")
      expect(page).to have_content("Your password has been updated")
      fill_in "Username", with: "stepheny"
      fill_in "Password", with: "password"
      click_on "Login"
      expect(page).to have_content("Welcome stepheny")
    end


    scenario "registered user can NOT submit a new INvalid password" do
      visit "/password_resets/9999/edit"
      fill_in "New Password", with: "abc"
      click_on "Submit"
      expect(page).to have_css("#edit_password_resets")
      expect(page).to have_content("Your password must be at least 7 characters")
    end
  end


  context "registered user receives two reset password email" do
    before(:each) do
      first_notice = PasswordReset.create(email: "stephen@gmail.com", unique_identifier: "9998", expiration_date: Time.now + 1.day)
      second_notice = PasswordReset.create(email: "stephen@gmail.com", unique_identifier: "9999", expiration_date: Time.now + 1.day)
    end


    scenario "registered user can only ever use the most recent link" do
      visit "/password_resets/9998/edit"
      fill_in "New Password", with: "password"
      click_on "Submit"
      expect(page).to have_css("#homepage")
      expect(page).to have_content("This link is no longer valid")
    end

    scenario "registered user can only ever use the most recent link" do
      visit "/password_resets/9999/edit"
      fill_in "New Password", with: "password"
      click_on "Submit"
      expect(page).to have_css("#homepage")
      expect(page).to have_content("Your password has been updated")
    end
  end

  context "PasswordReset Token has passed its expiration date" do
    before(:each) do
      expired_notice = PasswordReset.create(email: "stephen@gmail.com", unique_identifier: "9999", expiration_date: Time.now - 1.day)
    end

    scenario "Registered user can not reset their password" do
      visit "/password_resets/9999/edit"
      fill_in "New Password", with: "password"
      click_on "Submit"
      expect(page).to have_css("#homepage")
      expect(page).to have_content("Your password reset request has expired.")

    end

  end
end





