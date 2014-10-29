require 'rails_helper'
require 'capybara/rails'


feature "User Dashboard Page" do

  context "A visitor logs in" do
  before(:each) do
    fill_in_registration_form("Stephen")
  end

  scenario "As a logged in user I can view my account details page" do
    expect(page).to have_css("#deposits")
    expect(page).to have_css("#distributions")
    expect(page).to have_css("#net_amount")
    expect(page).to have_css("#winnings")
  end

  scenario "As a logged_in user I can link to the new deposits page to fund my account" do
    within(page.find("#fund-my-account")) {click_on "+"}
    expect(page).to have_css("#new_deposits")
  end

  scenario "As a logged_in user with a funded account I can link to the 'create a wager' page to create a wager" do
    fund_my_account_with_a_credit_card(100)
    within(page.find("#wager-funds")) {click_link "+"}
    expect(page).to have_css("#new_proposed_wagers")
  end

  scenario "As a logged_in user with a non-funded account I can link to the 'create a wager' page to create a wager" do
    within(page.find("#wager-funds")) {click_link "+"}
    expect(page).to have_css("#show_dashboards")
    expect(page).to have_content("Your account has a $0 balance.  You must fund your account before you can wager.")
  end

  scenario "As a logged_in user with unallocated funds available, I can link to the new distributions page to distribute funds from my account" do
    fund_my_account_with_a_credit_card(100)
    within(page.find("#distribute-funds")) {click_link "+"}
    expect(page).to have_css("#new_distributions")
  end

  scenario "As a logged_in user without unallocated funds available, I can link to the new distributions page to distribute funds from my account" do
    fund_my_account_with_a_credit_card(100)
    create_charity("United Way")
    click_on "Dashboard"
    distribute_funds_from_my_account(100, "United Way")
    within(page.find("#distribute-funds")) {click_link "+"}
    expect(page).to have_css("#show_dashboards")
    expect(page).to have_content("Your account has a $0 balance.  You must fund your account before you can distribute funds.")
  end

  # scenario "non-logged in visitor attempts to visit show page" do
  #   visit "/users/1"
  #
  #   expect(page).to have_content("You are not authorized to visit this page")
  #   expect(page).to have_css("#homepage")
  # end

  end

  context "A logged in user has created a wager" do
    before(:each) do
      create_user_and_fund_their_account("Stephen", 100)
      create_user_and_fund_their_account("Alexander", 100)
      create_an_existing_accepted_wager("Stephen", "Alexander", 10)

    end
    scenario "A user can NOT hide a wager in which the outcome has not been determined" do
      visit "/"
      login_a_registered_user("Stephen")
      expect(page).to have_css("#show_dashboards")
      expect(page).not_to have_css("#archive-button")
    end

    #THIS IS NOT WORKING BECAUSE I"M TRYING TO TEST BOTH USING SELENIUM AND CAPYBARA CONFIRM"
    # scenario "A user can hide a completed wager", js: true do
    #   click_on "Logout"
    #   login_a_registered_user("Alexander")
    #   click_on "Shake on it!"
    #   click_on "Logout"
    #
    #   login_a_registered_user("Stephen")
    #   click_on "I Lost"
    #   expect(page).to have_css("#show_dashboards")
    #   expect(page).to have_css("#archive-button")
    #   find("#archive-button").click
    #   click_on "Dashboard"
    #   expect(page).not_to have_content("Ping Pong Match")
    # end

    #THIS IS NOT WORKING BECAUSE I"M TRYING TO TEST BOTH USING SELENIUM AND CAPYBARA CONFIRM"
    # scenario "A user can hide a declined wager", js: true do
    #   click_on "Logout"
    #   login_a_registered_user("Alexander")
    #   click_on "No Thx!"
    #   click_on "Logout"
    #
    #   login_a_registered_user("Stephen")
    #   expect(page).to have_css("#show_dashboards")
    #   expect(page).to have_css("#archive-button")
    #   find("#archive-button").click
    #   click_on "Dashboard"
    #   expect(page).not_to have_content("Ping Pong Match")
    # end


  end
    context "A logged in user has created a public wager" do
      before(:each) do
        create_a_public_wager("Alexander", "William", "Stephen")

      end
      #THIS IS NOT WORKING BECAUSE I"M TRYING TO TEST BOTH USING SELENIUM AND CAPYBARA CONFIRM"
      # scenario "A user can archive any public wagers", js: true do
      #   click_on "Logout"
      #   login_a_registered_user("Alexander")
      #   expect(page).to have_css("#show_dashboards")
      #   expect(page).to have_content("Public Ping Pong")
      #   find("#archive-button").click
      #   click_on "Dashboard"
      #   expect(page).not_to have_content("Public Ping Pong")
      # end

    end







end