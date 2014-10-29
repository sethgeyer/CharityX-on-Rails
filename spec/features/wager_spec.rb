require 'rails_helper'
require 'capybara/rails'

feature "View and Create a Proposed Wagers" do

  before(:each) do
    create_charity("United Way")
    create_user_and_make_a_deposit_to_their_account("Alexander", 100)
    create_user_and_make_a_deposit_to_their_account("Stephen", 40)
  end

  scenario "As a visitor, I should not be able to visit the new proposed wager view directly via the URL " do
    visit "/user/wagers/new"
    expect(page).to have_css("#homepage")
  end

  scenario "As a user, I can not create a wager that is NOT in the proper increments" do
    visit "/"
    login_user("Stephen")
    within(page.find("#wager-funds")) { click_link "+" }
    fill_in "wager_title", with: "Ping Pong Match between S & A"
    fill_in "wager_date_of_wager", with: "2014-07-31"
    fill_in "wager_details", with: "Game to 21, standard rules apply"
    fill_in "wager_amount", with: 9
    fill_in "With:", with: "alexander"
    click_on "Submit"
    expect(page).to have_content("All wagers must be in increments of $#{$ChipValue}.")
  end

  scenario "As a user I can create a proposed wager" do
    visit "/"
    login_user("Stephen")
    within(page.find("#wager-funds")) {click_link "+"}

    fill_in "wager_title", with: "Ping Pong Match between S & A"
    fill_in "wager_date_of_wager", with: Date.today + 1.week
    fill_in "wager_details", with: "Game to 21, standard rules apply"
    fill_in "wager_amount", with: 10
    fill_in "With:", with: "alexander"
    click_on "Submit"
    expect(page.find("#wagers_table")).to have_content("Ping Pong Match")
    expect(page.find("#wagers_table")).to have_content(10)
    expect(page.find("#wagers_table")).not_to have_content(1000)
    expect(page.find("#wagers_table")).to have_content("alexander")
    expect(page.find("#wagers_table")).to have_content("I bet alexander")
    expect(page.find("#wagers_table")).to have_content("w/wageree")
    expect(page.find("#wagers_table")).not_to have_button("Shake on it!")
    expect(page.find("#wagers_table")).not_to have_button("No Thx!")
    expect(page.find("#wagers_table")).not_to have_button("I Lost") # _______________________

    expect(page.find("#wagers_table")).to have_link("Withdraw")
    expect(page.find("#wagers")).to have_content(10)
    expect(page.find("#net_amount")).to have_content(30)
  end

  scenario "As a user I can not create a proposed wager w/out a date" do
    visit "/"
    login_user("Stephen")
    within(page.find("#wager-funds")) {click_link "+"}
    fill_in "wager_title", with: "Ping Pong Match between S & A"
    # fill_in "wager_date_of_wager", with: "2014-07-31"
    fill_in "wager_details", with: "Game to 21, standard rules apply"
    fill_in "wager_amount", with: 10
    fill_in "With:", with: "alexander"
    click_on "Submit"
    expect(page).to have_content("can't be blank or in the past")
  end

  scenario "As a user I can not create a proposed wager w/out a title" do
    visit "/"
    login_user("Stephen")
    within(page.find("#wager-funds")) {click_link "+"}
    # fill_in "wager_title", with: "Ping Pong Match between S & A"
    fill_in "wager_date_of_wager", with: Date.today + 1.week
    fill_in "wager_details", with: "Game to 21, standard rules apply"
    fill_in "wager_amount", with: 10
    fill_in "With:", with: "alexander"
    click_on "Submit"
    expect(page).to have_content("can't be blank")
  end

  context "As a wagerer," do
    before(:each) do
      visit "/"
      login_user("Stephen")
    end

    scenario "I can not bet more dollars than are currently available in my account" do
      create_an_existing_accepted_wager("Alexander", "Stephen", 10)
      within(page.find("#wager-funds")) {click_link "+"}
      fill_in "wager_title", with: "Ping Pong Match between S & A"
      fill_in "wager_date_of_wager", with: "2014-07-31"
      fill_in "wager_details", with: "Game to 21, standard rules apply"
      fill_in "wager_amount", with: 50
      fill_in "With:", with: "alexandery"
      click_on "Submit"
      expect(page).to have_css("#new_proposed_wagers")
      expect(page).to have_content("You don't have sufficient funds for the size of this wager.  Unless you fund your account, the maximum you can wager is $30")
    end


    scenario "I can withdraw a proposed wager that has not yet been accepted" do

      create_a_new_unaccepted_wager("Stephen", "Alexander", 10)
      expect(page.find("#wagers")).to have_content("$10")
      expect(page.find("#wagered-chips")).to have_content("Chips:#{10 / $ChipValue}")
      click_on "Withdraw"
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#wagered-chips")).to have_content("Chips:0")
    end

    scenario "I can not 'withdraw' a proposed wager if it has been accepted" do
      create_a_new_unaccepted_wager("Stephen", "Alexander", 10)
      click_on "Logout"
      login_user("Alexander")
      click_on "Shake on it!"
      click_on "Logout"
      login_user("Stephen")
      expect(page).to have_content("Ping Pong Match")
      expect(page).not_to have_link("Withdraw")
      expect(page.find("#wagers")).to have_content(10)
      expect(page.find("#wagered-chips")).to have_content("Chips:#{10 / $ChipValue}")
    end



  end


  #not sure how to test this with the date validation requiring a forward looking date.
  # scenario "A proposed wager is auto-withdrawn if it has not been accepted by the end of the outcome date" do
  #   fill_in_registration_form("Alexander")
  #   fund_my_account_with_a_credit_card(100)
  #   click_on "Logout"
  #   fill_in_registration_form("Stephen")
  #   fund_my_account_with_a_credit_card(40)
  #   within(page.find("#wager-funds")) {click_link "+"}
  #   fill_in "wager_title", with: "Ping Pong Match between S & A"
  #   fill_in "wager_date_of_wager", with: "2014-07-31"
  #   fill_in "wager_details", with: "Game to 21, standard rules apply"
  #   fill_in "wager_amount", with: 10
  #   fill_in "With:", with: "alexandery"
  #   click_on "Submit"
  #   expect(page).to have_content("Ping Pong Match")
  #   expect(page).not_to have_link("Withdraw")
  #   expect(page.find("#wagers")).to have_content(0)
  #   expect(page.find("#wagered-chips")).to have_content("Chips:#{0 / $ChipValue}")
  #   expect(page.find("#net_amount")).to have_content(40)
  #   expect(page.find("#net-chips")).to have_content("Chips:#{40 / $ChipValue}")
  #   expect(page).not_to have_button("I Lost")
  #   expect(page).to have_content("Wager Expired Before It Was Accepted")
  #   expect(page).to have_link("Reissue?")
  #   expect(page).to have_css("#archive-button")
  #   click_on "Logout"
  #   login_a_registered_user("Alexander")
  #   expect(page).not_to have_button("Shake on it!")
  # end





  context "As a wageree," do
    before(:each) do
      # registers 2 users, funds their account (Alex: 100, Stephen: 40) and creates a
      # $10 wager between the two of them.  Stephen is left logged in.
      visit "/"
      login_user("Stephen")
      create_a_new_unaccepted_wager("Stephen", "Alexander", 10)
      click_on "Logout"
      visit "/"
      login_user("Alexander")
    end

    scenario "I can see a proposed wager in which I'm the wageree" do
      expect(page.find("#wagers_table")).to have_content("Ping Pong Match")
      expect(page.find("#wagers_table")).to have_content(10)
      expect(page.find("#wagers_table")).not_to have_content(1000)
      expect(page.find("#wagers_table")).to have_content("stephen")
      expect(page.find("#wagers_table")).to have_content("stephen bet me")
      expect(page.find("#wagers_table")).to have_content("w/wageree")
      expect(page.find("#wagers")).to have_content(0)
      expect(page.find("#wagers_table")).to have_button("No Thx!")
      expect(page.find("#wagers_table")).to have_button("Shake on it!")
    end


    scenario "I can accept a proposed_wager if I have sufficent funds to wager" do
      expect(page.find("#wagers")).to have_content("$0")
      click_on "Shake on it!"
      expect(page).to have_css("#show_dashboards")
      expect(page.find("#wagers_table")).not_to have_button("Shake on it!")
      expect(page.find("#wagers_table")).to have_content("accepted")
      expect(page.find("#wagers")).to have_content(10)
      expect(page.find("#wagered-chips")).to have_content("Chips:#{10 / $ChipValue}")
      expect(page.find("#net_amount")).to have_content(90)
    end


    scenario "I can decline a proposed_wager if Im not interested" do
      expect(page.find("#wagers")).to have_content("$0")
      click_on "No Thx!"
      expect(page).to have_css("#show_dashboards")
      expect(page.find("#wagers_table")).not_to have_button("Shake on it!")
      expect(page.find("#wagers_table")).not_to have_button("No Thx!")

      expect(page.find("#wagers_table")).to have_content("declined")
      expect(page.find("#wagers")).to have_content(0)
      expect(page.find("#wagered-chips")).to have_content("Chips:#{0 / $ChipValue}")
      expect(page.find("#net_amount")).to have_content(100)
      expect(page).not_to have_button("I Lost")
      click_on "Logout"
      login_user("Stephen")
      expect(page.find("#wagers")).to have_content(0)
      expect(page.find("#wagered-chips")).to have_content("Chips:#{0 / $ChipValue}")
      expect(page.find("#net_amount")).to have_content(40)
      expect(page.find("#net-chips")).to have_content("Chips:#{40 / $ChipValue}")
      expect(page).not_to have_link("Withdraw")
      expect(page).not_to have_button("I Lost")
      expect(page).to have_content("Wager Not Accepted")
      expect(page).to have_link("Revise?")

    end



    scenario "I can NOT accept a proposed_wager if I don't have sufficient funds to wager" do
      distribute_funds_from_my_account(90, "United Way")
      distribute_funds_from_my_account(10, "United Way")
      click_on "Shake on it!"
      expect(page).to have_css("#show_dashboards")
      expect(page).to have_content("You don't have adequate funds to accept this wager.  Please add additional funds to your account.")
      expect(page.find("#net_amount")).to have_content("$0")
    end
  end

  context "A bet was placed by the wagerer and accepted by the wageree" do
    before(:each) do
      create_an_existing_accepted_wager("Stephen", "Alexander", 10)
    end
    scenario "A wagerer, can identify that he won the wager" do
      visit "/"
      login_user("Stephen")
      click_on "I Won"
      expect(page).to have_content("Awaiting Confirmation")
    end

    scenario "A wageree, can identify that he won the wager" do
      visit "/"
      login_user("Alexander")
      click_on "I Won"
      expect(page).to have_content("Awaiting Confirmation")
    end

    #WHAT TO DO WHEN BOTH FOLKS SAY I WON
    # scenario "A wagerer and wageree both identify themselves as winners" do
    #   register_users_and_create_a_wager("Alexander", "Stephen")
    #   click_on "Logout"
    #   login_a_registered_user("Alexander")
    #   click_on "Shake on it!"
    #   click_on "I Won"
    #   click_on "Logout"
    #   login_a_registered_user("Stephen")
    #   click_on "I Won"
    #   expect(page).to have_button("I Won")
    #   expect(page).to have_button("I Lost")
    #
    # end




    scenario "As a wagerer that won the bet, I collect the money from the wageree" do
      visit "/"
      login_user("Alexander")
      click_on "I Lost"
      click_on "Logout"
      login_user("Stephen")
      expect(page).to have_content("I Won")
      expect(page).not_to have_button("I Lost")
      expect(page).not_to have_button("Shake on it!")
      expect(page.find("#winnings")).to have_content(10)
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#wagered-chips")).to have_content("Chips:0")
      # expect(page.find("#winnings")).to have_content("Chips:10")
      expect(page.find("#net_amount")).to have_content(50)
      expect(page.find("#net-chips")).to have_content("Chips:#{50 / $ChipValue}")
    end

    scenario "As a wagerer that lost the bet, I transfer the money to the wageree" do
      visit "/"
      login_user("Stephen")
      click_on "I Lost"
      expect(page).to have_content("I Lost")
      expect(page).not_to have_button("I Lost")
      expect(page).not_to have_button("Shake on it!")
      expect(page.find("#winnings")).to have_content(-10)
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#wagered-chips")).to have_content("Chips:0")
      # expect(page.find("#winnings")).to have_content("Chips:10")
      expect(page.find("#net_amount")).to have_content(30)
      expect(page.find("#net-chips")).to have_content("Chips:#{30 / $ChipValue}")
    end


    scenario "As a wageree that lost the bet, I transfer the money to the wagerer" do
      visit "/"
      login_user("Alexander")
      click_on "I Lost"
      expect(page).to have_content("I Lost")
      expect(page).not_to have_button("I Lost")
      expect(page).to have_link("Rematch")
      expect(page).not_to have_button("Shake on it!")
      expect(page.find("#winnings")).to have_content(-10)
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#wagered-chips")).to have_content("Chips:0")
      expect(page.find("#net_amount")).to have_content(90)
      expect(page.find("#net-chips")).to have_content("Chips:#{90 / $ChipValue}")
    end

    scenario "As a wageree that won the bet, I receive the money from the wagerer" do
      visit "/"
      login_user("Stephen")
      click_on "I Lost"
      click_on "Logout"
      login_user("Alexander")
      expect(page).to have_content("I Won")
      expect(page).not_to have_button("I Lost")
      expect(page).to have_link("Rematch")
      expect(page).not_to have_button("Shake on it!")
      expect(page.find("#winnings")).to have_content(10)
      expect(page.find("#wagers")).to have_content("$0")
      expect(page.find("#dist-chips")).to have_content("Chips:0")
      expect(page.find("#net_amount")).to have_content(110)
      expect(page.find("#net-chips")).to have_content("Chips:#{110 / $ChipValue}")
    end
  end


    context "Proposing Rematches" do
      scenario "As a wagerer, I can propose a rematch for a game that I just played" do
                create_an_existing_accepted_wager("Stephen", "Alexander", 10)
        visit "/"
        login_user("Alexander")
        click_on "I Lost"
        click_on "Logout"
        login_user("Stephen")
        expect(page).to have_link("Rematch")
        click_on "Rematch"
        expect(page).to have_css("#new_proposed_wagers")
        fill_in "wager_date_of_wager", with: "2017-07-31"
        click_on "Submit"
        expect(page).to have_css("#show_dashboards")
        expect(page).to have_content("Your proposed wager has been sent to alexander.")

      end

      scenario "As a wageree, I can propose a rematch for a game that I just played" do

        create_an_existing_accepted_wager("Stephen", "Alexander", 10)
        visit "/"
        login_user("Stephen")
        click_on "I Lost"
        click_on "Logout"
        login_user("Alexander")
        click_on "Rematch"
        expect(page).to have_css("#new_proposed_wagers")
        fill_in "wager_date_of_wager", with: "2017-07-31"
        click_on "Submit"
        expect(page).to have_css("#show_dashboards")
        expect(page).to have_content("Your proposed wager has been sent to stephen.")
      end

    end


    context "User does not have another registered user to bet with" do
      scenario "As a user I can create a wager w/out a known wageree " do
        create_user_and_make_a_deposit_to_their_account("Michael", 100)
        visit "/"
        login_user("Stephen")
        create_a_public_wager("Stephen", "Alexander", "Michael")
        expect(page).to have_css("#show_dashboards")
        expect(page).to have_content("No username was provided.  Your wager is listed in the public wagers section")
        expect(page).to have_content("Public Ping Pong")
        click_on "Logout"
        login_user("Alexander")
        expect(page.find("#public-wagers")).to have_content("Public Ping Pong")
        click_on "Shake on it!"
        expect(page.find("#wagers")).to have_content("$10")
        expect(page.find("#wagers")).not_to have_content("$1000")
        expect(page.find("#wagered-chips")).to have_content("Chips:#{10 / $ChipValue}")
        expect(page.find("#net_amount")).to have_content(90)
        expect(page.find("#net-chips")).to have_content("Chips:#{90 / $ChipValue}")
      end

      context "User wants to solicit a non-registered-friend to join the site by proposing a wager to the friend"

      scenario "As a user, I can solicit a non-registered user to bet w/ me" do
        user_creates_a_solicitation_wager("AlexTheUser", "BillTheNonUser")
        expect(page).to have_css("#show_dashboards")
        expect(page).to have_content("A solicitation email has been sent to billthenonuser@gmail.com")
        expect(page.find("#wagers_table")).to have_content("I bet billthenonuser@gmail.com $10 that: Ping Pong")
      end

      scenario "As a non-registered-friend, I can accept a friend's solicitation to wager" do
        user_creates_a_solicitation_wager("AlexTheUser", "BillTheNonUser")
        click_on "Logout"
        fill_in_registration_form("Michael")
        expect(page).not_to have_content("Ping Pong")
        click_on "Logout"
        fill_in_registration_form("BillTheNonUser")
        expect(page.find("#wagers_table")).to have_content("Ping Pong")
        expect(page).to have_content("alextheuser bet me $10 that: Ping Pong")
      end


    end

end
