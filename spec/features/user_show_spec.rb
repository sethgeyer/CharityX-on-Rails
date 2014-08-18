require 'rails_helper'
require 'capybara/rails'


feature "User Show Page" do
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
    click_on "Fund My Account"

    expect(page).to have_css("#new_deposits")
  end

  scenario "As a logged_in user with a funded account I can link to the 'create a wager' page to create a wager" do
    fund_my_account_with_a_credit_card(100)
    click_on "Create a Wager"

    expect(page).to have_css("#new_proposed_wagers")
  end

  scenario "As a logged_in user with a non-funded account I can link to the 'create a wager' page to create a wager" do
    click_on "Create a Wager"

    expect(page).to have_css("#show_users")
    expect(page).to have_content("Your account has a $0 balance.  You must fund your account before you can wager.")
  end



  scenario "As a logged_in user with unallocated funds available, I can link to the new distributions page to distribute funds from my account" do
    fund_my_account_with_a_credit_card(100)
    click_on "Distribute Funds"
    expect(page).to have_css("#new_distributions")
  end

  scenario "As a logged_in user without unallocated funds available, I can link to the new distributions page to distribute funds from my account" do
    fund_my_account_with_a_credit_card(100)
    visit "/charities"
    click_on "Register a new charity"
    complete_application("United Way")
    click_on "Account Details"
    distribute_funds_from_my_account(100, "United Way")
    click_on "Distribute Funds"
    expect(page).to have_css("#show_users")
    expect(page).to have_content("Your account has a $0 balance.  You must fund your account before you can distribute funds.")
  end

  # scenario "non-logged in visitor attempts to visit show page" do
  #   visit "/users/1"
  #
  #   expect(page).to have_content("You are not authorized to visit this page")
  #   expect(page).to have_css("#homepage")
  # end



end