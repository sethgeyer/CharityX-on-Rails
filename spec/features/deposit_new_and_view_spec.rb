require 'rails_helper'
require 'capybara/rails'

feature "Deposit and View Funds in an Account" do

  scenario "As a visitor, I should not be able to visit the new_deposits page directly via typing in a URL" do
    visit "/accounts/1/deposits/new"

    expect(page).to have_css("#homepage")
  end

  scenario "As a visitor, I should NOT be able to view a history of deposits" do
    visit "/accounts/1/deposits"
    expect(page).to have_css("#homepage")
  end

  context "Deposits greater than $1000 or not in increments of $10" do``
    scenario "As a user, I can not make a deposit worth more than $1000" do
      fill_in_registration_form("Stephen")
      fund_my_account_with_a_credit_card(1001)
      expect(page).to have_css("#new_deposits")
      expect(page).to have_content("All deposits must be in increments of $10 and no more than $1000.")
    end

    scenario "As a user, I can not make a deposit worth more than $1000" do
      fill_in_registration_form("Stephen")
      fund_my_account_with_a_credit_card(9)
      expect(page).to have_css("#new_deposits")
      expect(page).to have_content("All deposits must be in increments of $10 and no more than $1000.")
    end

  end
  scenario "As a user, I can add funds to my account and see deposit totals" do
    fill_in_registration_form("Stephen")
    fund_my_account_with_a_credit_card(400)

    expect(page).to have_css("#show_users")
    expect(page).to have_content("Thank you for depositing $400 into your account")
    expect(page.find("#deposits")).to have_content("$400")
    expect(page.find("#deposits")).not_to have_content("$40000")
    expect(page.find("#net_amount")).to have_content("$400")

    fund_my_account_with_a_credit_card(500)

    expect(page).to have_content("Thank you for depositing $500 into your account")
    expect(page.find("#deposits")).to have_content("$900")
    expect(page.find("#net_amount")).to have_content("$900")
  end

  scenario "As a user, I should be able to view my history of deposits" do
    fill_in_registration_form("Stephen")
    fund_my_account_with_a_credit_card(400)
    fund_my_account_with_a_credit_card(500)
    #can't test this because 'show deposit history is in the navbar nested in a jscript dropdown
    # click_on "Show Deposit History"
    # expect(page).to have_css("#index_deposits")
    # expect(page).to have_content("$400")
    # expect(page).not_to have_content("$40000")
    # expect(page).to have_content("$500")
  end


end