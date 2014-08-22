require 'rails_helper'
require 'capybara/rails'

feature "View Index and Create Distributions" do
  before(:each) do
    visit "/charities/new"
    complete_application("United Way")
    visit "/charities/new"
    complete_application("Red Cross")
  end

  scenario "As a visitor, I should NOT be able to view a history of deposits" do
    visit "/accounts/1/deposits"
    expect(page).to have_css("#homepage")
  end

  scenario "As a visitor, I should not be able to visit the new distributions page directly via typing in a uRL" do
    visit "/accounts/1/distributions/new"
    expect(page).to have_css("#homepage")
  end

  context "After having looged in as a user," do
    before(:each) do
      fill_in_registration_form("Stephen")
      fund_my_account_with_a_credit_card(400)
    end

    scenario "I should be able to view my history of distributions" do
      fund_my_account_with_a_credit_card(500)
      distribute_funds_from_my_account(100, "United Way")
      distribute_funds_from_my_account(200, "Red Cross")
      # #can't test this because 'show distr history is in the navbar nested in a jscript dropdown
      # click_on "Show Distribution History"
      #
      # expect(page).to have_css("#index_distributions")
      # expect(page).to have_content("$100")
      # expect(page).not_to have_content("$10000")
      # expect(page).to have_content("$200")
    end

    context "Distributions not in increments of $10" do
      scenario "I should be able to view my history of distributions" do
        fund_my_account_with_a_credit_card(500)
        distribute_funds_from_my_account(98, "United Way")
        expect(page).to have_content("All distributions must be in increments of $10.")
      end
    end
    scenario "I can distribute funds from my account" do
      distribute_funds_from_my_account(100, "United Way")
      expect(page).to have_css("#show_users")
      expect(page).to have_content("Thank you for distributing $100 from your account to United Way")
      expect(page.find("#deposits")).to have_content("$400")
      expect(page.find("#distributions")).to have_content("$100")
      expect(page.find("#distributions")).not_to have_content("$10000")
      expect(page.find("#net_amount")).to have_content("$300")
      distribute_funds_from_my_account(50, 'Red Cross')
      expect(page).to have_content("Thank you for distributing $50 from your account to Red Cross")
      expect(page.find("#deposits")).to have_content("$400")
      expect(page.find("#distributions")).to have_content("$150")
      expect(page.find("#net_amount")).to have_content("$250")
    end

    scenario "#I can not distribute more dollars than are currently available in my account" do
      distribute_funds_from_my_account(500, "United Way")
      expect(page).to have_css("#new_distributions")
      expect(page).to have_content("You don't have sufficient funds for the size of this distribution.  Unless you fund your account, the maximum you can distribute is $400")
    end

  end

end
