require 'rails_helper'
require 'capybara/rails'

feature "View and Create a Proposed Wagers" do

  before(:each) do
    visit "/charities/new"
    complete_application("United Way")

  end

  scenario "As a visitor, I should not be able to visit the new proposed wager view directly via the URL " do
    visit "/accounts/1/proposed_wagers/new"
    expect(page).to have_css("#homepage")
  end

  context "Proposed Wagers not in increments of $10" do
    scenario "As a user, I can not create a wager that is NOT in increments of 10" do
      fill_in_registration_form("Alexander")
      fund_my_account_with_a_credit_card(1000)
      click_on "Logout"
      fill_in_registration_form("Stephen")
      fund_my_account_with_a_credit_card(400)
      within(page.find("#wager-funds")) {click_link "+"}
      fill_in "proposed_wager_title", with: "Ping Pong Match between S & A"
      fill_in "proposed_wager_date_of_wager", with: "2014-07-31"
      fill_in "proposed_wager_details", with: "Game to 21, standard rules apply"
      fill_in "proposed_wager_amount", with: 109
      fill_in "With:", with: "alexandery"
      click_on "Submit"
      expect(page).to have_content("All wagers must be in increments of $10.")
    end

  end


  scenario "As a user I can create a proposed wager" do
    register_users_and_create_a_wager("Alexander", "Stephen")
    expect(page).to have_css("#show_users")
    expect(page).to have_content("Your proposed wager has been sent to alexandery.")
    # save_and_open_page
    expect(page.find("#proposed_wagers_table")).to have_content("Ping Pong Match")
    expect(page.find("#proposed_wagers_table")).to have_content(100)
    expect(page.find("#proposed_wagers_table")).not_to have_content(10000)
    expect(page.find("#proposed_wagers_table")).to have_content("Alexandery")
    expect(page.find("#proposed_wagers_table")).to have_content("I bet Alexandery")
    expect(page.find("#proposed_wagers_table")).to have_content("w/wageree")
    expect(page.find("#proposed_wagers_table")).not_to have_link("Shake on it")
    expect(page.find("#proposed_wagers_table")).not_to have_button("I Lost") # _______________________

    expect(page.find("#proposed_wagers_table")).to have_link("Withdraw")
    expect(page.find("#wagers")).to have_content(100)
    expect(page.find("#net_amount")).to have_content(300)
  end


  context "As a wagerer," do
    before(:each) do
      # registers 2 users, funds their account (Alex: 1000, Stephen: 400) and creates a
      # $100 wager between the two of them.  Stephen is left logged in.
      register_users_and_create_a_wager("Alexander", "Stephen")
    end

    scenario "I can not bet more dollars than are currently available in my account" do
      within(page.find("#wager-funds")) {click_link "+"}
      fill_in "proposed_wager_title", with: "Ping Pong Match between S & A"
      fill_in "proposed_wager_date_of_wager", with: "2014-07-31"
      fill_in "proposed_wager_details", with: "Game to 21, standard rules apply"
      fill_in "proposed_wager_amount", with: 500
      fill_in "With:", with: "alexandery"
      click_on "Submit"
      expect(page).to have_css("#new_proposed_wagers")
      expect(page).to have_content("You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $300")
    end


    scenario "I can withdraw a proposed wager that has not yet been accepted" do
      expect(page.find("#wagers")).to have_content("$100")
      expect(page.find("#wagered-chips")).to have_content("Chips:10")
      click_on "Withdraw"
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#wagered-chips")).to have_content("Chips:0")
    end

    scenario "I can not 'withdraw' a proposed wager if it has been accepted" do
      click_on "Logout"
      login_a_registered_user("Alexander")
      click_on "Shake on it"
      click_on "Logout"
      login_a_registered_user("Stephen")
      expect(page).to have_content("Ping Pong Match")
      expect(page).not_to have_link("Withdraw")
      expect(page.find("#wagers")).to have_content(100)
      expect(page.find("#wagered-chips")).to have_content("Chips:10")
    end


  end

  context "As a wageree," do
    before(:each) do
      # registers 2 users, funds their account (Alex: 1000, Stephen: 400) and creates a
      # $100 wager between the two of them.  Stephen is left logged in.
      register_users_and_create_a_wager("Alexander", "Stephen")
      click_on "Logout"
      login_a_registered_user("Alexander")
    end

    scenario "I can see a proposed wager in which I'm the wageree" do
      expect(page.find("#proposed_wagers_table")).to have_content("Ping Pong Match")
      expect(page.find("#proposed_wagers_table")).to have_content(100)
      expect(page.find("#proposed_wagers_table")).not_to have_content(10000)
      expect(page.find("#proposed_wagers_table")).to have_content("Stepheny")
      expect(page.find("#proposed_wagers_table")).to have_content("Stepheny bet me")
      expect(page.find("#proposed_wagers_table")).to have_content("w/wageree")
      expect(page.find("#wagers")).to have_content(0)
    end

    scenario "I can accept a proposed_wager if I have sufficent funds to wager" do
      expect(page.find("#wagers")).to have_content("$0")
      click_on "Shake on it"
      expect(page).to have_css("#show_users")
      expect(page.find("#proposed_wagers_table")).not_to have_link("Shake on it")
      expect(page.find("#proposed_wagers_table")).to have_content("accepted")
      expect(page.find("#wagers")).to have_content(100)
      expect(page.find("#wagered-chips")).to have_content("Chips:10")
      expect(page.find("#net_amount")).to have_content(900)
      expect(page.find("#net_amount")).to have_content(900)
    end

    scenario "I can NOT accept a proposed_wager if I don't have sufficient funds to wager" do
      distribute_funds_from_my_account(950, "United Way")
      click_on "Shake on it"
      expect(page).to have_css("#show_users")
      expect(page).to have_content("You don't have adequate funds to accept this wager.  Please add additional funds to your account.")
      expect(page.find("#net_amount")).to have_content("$50")
    end
  end

  context "A bet was placed by the wagerer and accepted by the wageree" do

    scenario "As a wagerer that won the bet, I collect the money from the wageree" do
      register_users_and_create_a_wager("Alexander", "Stephen")
      click_on "Logout"
      login_a_registered_user("Alexander")
      click_on "Shake on it"
      click_on "I Lost"
      click_on "Logout"
      login_a_registered_user("Stephen")
      expect(page).to have_content("I Won")
      expect(page).not_to have_button("I Lost")
      expect(page).not_to have_button("Shake on it")
      expect(page.find("#winnings")).to have_content(100)
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#wagered-chips")).to have_content("Chips:0")
      # expect(page.find("#winnings")).to have_content("Chips:10")
      expect(page.find("#net_amount")).to have_content(500)
      expect(page.find("#net-chips")).to have_content("Chips:50")
    end

    scenario "As a wagerer that lost the bet, I transfer the money to the wageree" do
      register_users_and_create_a_wager("Alexander", "Stephen")
      click_on "Logout"
      login_a_registered_user("Alexander")
      click_on "Shake on it"
      click_on "Logout"
      login_a_registered_user("Stephen")
      click_on "I Lost"
      expect(page).to have_content("I Lost")
      expect(page).not_to have_button("I Lost")
      expect(page).not_to have_button("Shake on it")
      expect(page.find("#winnings")).to have_content(-100)
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#wagered-chips")).to have_content("Chips:0")
      # expect(page.find("#winnings")).to have_content("Chips:10")
      expect(page.find("#net_amount")).to have_content(300)
      expect(page.find("#net-chips")).to have_content("Chips:30")
    end


    scenario "As a wageree that lost the bet, I transfer the money to the wagerer" do
      register_users_and_create_a_wager("Alexander", "Stephen")
      click_on "Logout"
      login_a_registered_user("Alexander")
      click_on "Shake on it"
      click_on "I Lost"
      expect(page).to have_content("I Lost")
      expect(page).not_to have_button("I Lost")
      expect(page).to have_link("Rematch")
      expect(page).not_to have_button("Shake on it")
      expect(page.find("#winnings")).to have_content(-100)
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#wagered-chips")).to have_content("Chips:0")
      expect(page.find("#net_amount")).to have_content(900)
      expect(page.find("#net-chips")).to have_content("Chips:90")
    end

    scenario "As a wageree that won the bet, I receive the money from the wagerer" do
      register_users_and_create_a_wager("Alexander", "Stephen")
      click_on "Logout"
      login_a_registered_user("Alexander")
      click_on "Shake on it"
      click_on "Logout"
      login_a_registered_user("Stephen")
      click_on "I Lost"
      click_on "Logout"
      login_a_registered_user("Alexander")
      expect(page).to have_content("I Won")
      expect(page).not_to have_link("I Lost")
      expect(page).to have_link("Rematch")
      expect(page).not_to have_button("Shake on it")
      expect(page.find("#winnings")).to have_content(100)
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#dist-chips")).to have_content("Chips:0")
      expect(page.find("#net_amount")).to have_content(1100)
      expect(page.find("#net-chips")).to have_content("Chips:110")
    end
  end


    context "Proposing Rematches" do
      scenario "As a wagerer, I can propose a rematch for a game that I just played" do

        fill_in_registration_form("Aarones")
        fund_my_account_with_a_credit_card(1000)
        click_on "Logout"
        fill_in_registration_form("Zekeees")
        fund_my_account_with_a_credit_card(1000)
        click_on "Logout"

        register_users_and_create_a_wager("Alexander", "Stephen")
        click_on "Logout"
        login_a_registered_user("Alexander")
        click_on "Shake on it"
        click_on "I Lost"
        click_on "Logout"
        login_a_registered_user("Stephen")
        expect(page).to have_link("Rematch")
        click_on "Rematch"
        expect(page).to have_css("#new_proposed_wagers")
        fill_in "proposed_wager_date_of_wager", with: "2017-07-31"
        click_on "Submit"
        expect(page).to have_css("#show_users")
        expect(page).to have_content("Your proposed wager has been sent to alexandery.")

      end

      scenario "As a wageree, I can propose a rematch for a game that I just played" do
        fill_in_registration_form("Aarones")
        fund_my_account_with_a_credit_card(1000)
        click_on "Logout"
        fill_in_registration_form("Zekeees")
        fund_my_account_with_a_credit_card(1000)
        click_on "Logout"

        register_users_and_create_a_wager("Alexander", "Stephen")
        click_on "Logout"
        login_a_registered_user("Alexander")
        click_on "Shake on it"
        click_on "Logout"
        login_a_registered_user("Stephen")
        click_on "I Lost"
        click_on "Logout"
        login_a_registered_user("Alexander")
        click_on "Rematch"
        expect(page).to have_css("#new_proposed_wagers")
        fill_in "proposed_wager_date_of_wager", with: "2017-07-31"
        click_on "Submit"
        expect(page).to have_css("#show_users")
        expect(page).to have_content("Your proposed wager has been sent to stepheny.")
      end

    end


    context "User does not have another registered user to bet with" do
      scenario "As a user I can create a wager w/out a known wageree " do
        create_a_public_wager("Alexander", "Michael", "Stephen")
        expect(page).to have_css("#show_users")
        expect(page).to have_content("No username was provided.  Your wager is listed in the public wagers section")
        expect(page).to have_content("Public Ping Pong")
        click_on "Logout"
        login_a_registered_user("Alexander")
        expect(page.find("#public-wagers")).to have_content("Public Ping Pong")
        click_on "Shake on it"
        expect(page.find("#wagers")).to have_content("$100")
        expect(page.find("#wagers")).not_to have_content("$10000")
        expect(page.find("#wagered-chips")).to have_content("Chips:10")
        expect(page.find("#net_amount")).to have_content(900)
        expect(page.find("#net-chips")).to have_content("Chips:90")
      end

      context "User wants to solicit a non-registered-friend to join the site by proposing a wager to the friend"

      scenario "As a user, I can solicit a non-registered user to bet w/ me" do
        user_creates_a_solicitation_wager("AlexTheUser", "BillTheNonUser")
        expect(page).to have_css("#show_users")
        expect(page).to have_content("A solicitation email has been sent to billthenonuser@gmail.com")
        expect(page).to have_content("Solicit Ping Pong")
      end

      scenario "As a non-registered-friend, I can accept a friend's solicitation to wager" do
        user_creates_a_solicitation_wager("AlexTheUser", "BillTheNonUser")
        click_on "logout"
        #click on emailed link
        #can say, no thanks
        #can say, yes
        #can create a registration
        #can accept the wager

      end



    end

end
