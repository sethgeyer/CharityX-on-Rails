require 'rails_helper'
require 'capybara/rails'



feature "Create a sport wager" do
  before(:each) do
    create_user_and_make_deposit("Stephen", 100)
    create_user_and_make_deposit("Alexander", 100)
    visit "/"
    login_user("Stephen")
  end


  # scenario "As a user, I can create a sport wager", js: true do
  #   within(page.find("#wager-funds")) { click_link "+" }
  #   expect(page).to have_button("Find a Game")
  #   fill_in "wager_amount", with: 50
  #   fill_in "With:", with: "alexander"
  #   click_on "Find a Game"
  #   sleep(3)
  #   click_on "Broncos"
  #   sleep(4)
  #   click_on "Submit"
  #
  #
  # end

  context "As a registered user that has created a sports wager" do
    before(:each) do
      @games = [{game_id: 1, vs_id: 10, visiting_team: "Broncos", home_id: 11, home_team: "Patriots", date: Date.today + 2.day},
                {game_id: 2, vs_id: 20, visiting_team: "Redskins", home_id: 21, home_team: "Vikings", date: Date.today + 3.days},
                {game_id: 3, vs_id: 30, visiting_team: "Jets", home_id: 31, home_team: "Chargers", date: Date.today + 4.days},
                {game_id: 4, vs_id: 40, visiting_team: "Colts", home_id: 41, home_team: "Giants", date: Date.today + 5.days},
      ]
      # selected_game = {game_id: 1, vs_id: 10, visiting_team: "Broncos", home_id: 11, home_team: "Patriots", date: Date.today + 2.day, winner_id: nil}
      create_a_broncos_patriots_wager("Stephen", "Alexander", 10)
    end

    scenario "The wagerer can see the check game outcome button" do
      visit user_dashboard_path
      expect(page).to have_content("The Patriots beat the Broncos")
      expect(page).not_to have_button("I Won")
      expect(page).to have_button("Check Outcome")
    end

    scenario "The wageree can see the check game outcome button" do
      click_on "Logout"
      login_user("Alexander")
      visit user_dashboard_path
      expect(page).to have_content("The Patriots beat the Broncos")
      expect(page).not_to have_button("I Won")
      expect(page).to have_button("Check Outcome")
    end

    context "The outcome of the sportwager has been determined and the wagerer won" do
      before(:each) do
        game_one = SportsGameOutcome.new({ "status"=> "closed", "home_team"=> {"id" => "NE", "points"=>50}, "away_team"=> {"id" => "DEN", "points"=>25}})
        allow(SportsGameOutcome).to receive(:get_final_score).and_return(game_one)
      end

      scenario "A winning wagerer sees that they won the wager" do
        visit user_dashboard_path

        click_on "Check Outcome"
        expect(page).to have_content("I Won!")
        expect(page).to have_link("Rematch?")

      end

      scenario "A losing wageree sees that they lost the wager" do
        click_on "Logout"
        login_user ("Alexander")
        visit user_dashboard_path
        click_on "Check Outcome"
        expect(page).to have_content("I Lost!")
        expect(page).to have_link("Rematch?")

      end

    end

    context "The outcome of the sportwager has been determined and the wagerer lost" do
      before(:each) do
        game_one = SportsGameOutcome.new({ "status"=> "closed", "home_team"=> {"id" => "NE", "points"=>25}, "away_team"=> {"id" => "DEN", "points"=>5}})
        allow(SportsGameOutcome).to receive(:get_final_score).and_return(game_one)
      end


      scenario "A losing wagerer sees that they lost the wager" do
        visit user_dashboard_path

        click_on "Check Outcome"
        expect(page).to have_content("I Lost!")
        expect(page).to have_link("Rematch")

      end

      scenario "A winning wageree sees that they won the wager" do
        click_on "Logout"
        login_user ("Alexander")
        visit user_dashboard_path
        click_on "Check Outcome"
        expect(page).to have_content("I Won!")
        expect(page).to have_link("Rematch?")

      end


    end


  end


end