require 'rails_helper'
require 'capybara/rails'



feature "Create a sport wager" do
  before(:each) do
    @wagerer = create_user_and_make_deposit("Stephen", 100)
    @wageree = create_user_and_make_deposit("Alexander", 100)
    visit "/"
    login_user(@wagerer.first_name)
    game = SportsGame.create(id: 240,
                             uuid: "b5306b6f-9dbd-4da3-b412-efb3c13dfe86",
                             date: "2014-12-23 01:30:00",
                             week: 16,
                             home_id: "CIN",
                             vs_id: "DEN",
                             status: "scheduled",
                             venue: "Paul Brown Stadium",
                             temperature: "69",
                             condition: "balmy",
                             full_home_name: "Cincinnati Bengals",
                             full_visitor_name: "Denver Broncos")
  end


  scenario "As a user, I can create a sport wager", js: true do
    within(page.find("#wager-funds")) { click_link "+" }
    expect(page).to have_button("Find a Game")
    fill_in "wager_amount", with: 50
    fill_in "With:", with: @wageree.username
    click_on "Find a Game"

    click_on "Broncos"

    expect(find('.wager-input').value).to eq("The Denver Broncos beat the Cincinnati Bengals")
    expect(find('.wager-date-input').value).to eq("2014-12-23 01:30:00 UTC")
    expect(find('.wager-details-input').value).to eq("@Paul Brown Stadium / Forecast: 69 and balmy")


    click_on "Submit"
    page.driver.browser.switch_to.alert.accept
    sleep(1)
    expect(page).to have_content("Your proposed wager has been sent to alexander ")
    expect(page).to have_content("I bet alexander $50 that: The Denver Broncos beat the Cincinnati Bengals")
    expect(page).to have_link("Withdraw Unaccepted Wager")
    find(".expand-icon").click
    expect(page).to have_content("2014-12-23")
    expect(page).to have_content("@Paul Brown Stadium / Forecast: 69 and balmy")
    click_on "Logout"
    login_user(@wageree.first_name)
    expect(page).to have_content("stephen bet me $50")
    click_on "Shake on it"
    page.driver.browser.switch_to.alert.accept
    sleep(1)
    expect(page).to have_button("Check Outcome")

  end

  context "As a registered user that has created a sports wager" do
    before(:each) do
      @wager = Wager.create!(title: "The Denver Broncos beat the Cincinnati Bengals",
                             date_of_wager: "2014-12-23",
                             amount: 1000,
                             wageree_id: @wageree.id,
                             status: "accepted",
                             user_id: @wagerer.id,
                             wager_type: "SportsWager",
                             game_uuid: "b5306b6f-9dbd-4da3-b412-efb3c13dfe86",
                             selected_winner_id: "DEN"
      )

      (1000 / 100 / 10).times do | time |
        wagerer_chips = @wagerer.chips.where(status: "available").first
        wageree_chips = @wageree.chips.where(status: "available").first
        wagerer_chips.status = "wagered"
        wageree_chips.status = "wagered"
        wagerer_chips.save!
        wageree_chips.save!
      end

    end

    scenario "The wagerer can see the check game outcome button" do
      visit user_dashboard_path
      expect(page).to have_content("I bet alexander $10 that: The Denver Broncos beat the Cincinnati Bengals")
      expect(page).not_to have_button("I Won")
      expect(page).to have_button("Check Outcome")
    end

    context "The outcome of the sportwager has been determined and the wagerer won" do
      before(:each) do
        game_one = SportsGamesOutcome.new({ "status"=> "closed", "home_team"=> {"id" => "NE", "points"=>50}, "away_team"=> {"id" => "DEN", "points"=>25}})
        allow(SportsGamesOutcome).to receive(:get_final_score).and_return(game_one)
      end
  #
  #     scenario "A winning wagerer sees that they won the wager" do
  #       visit user_dashboard_path
  #
  #       click_on "Check Outcome"
  #       expect(page).to have_content("I Won!")
  #       expect(page).to have_link("Rematch?")
  #
  #     end
  #
  #     scenario "A losing wageree sees that they lost the wager" do
  #       click_on "Logout"
  #       login_user ("Alexander")
  #       visit user_dashboard_path
  #       click_on "Check Outcome"
  #       expect(page).to have_content("I Lost!")
  #       expect(page).to have_link("Rematch?")
  #
  #     end
  #
    end
  #
  #   context "The outcome of the sportwager has been determined and the wagerer lost" do
  #     before(:each) do
  #       game_one = SportsGamesOutcome.new({ "status"=> "closed", "home_team"=> {"id" => "NE", "points"=>25}, "away_team"=> {"id" => "DEN", "points"=>5}})
  #       allow(SportsGamesOutcome).to receive(:get_final_score).and_return(game_one)
  #     end
  #
  #
  #     scenario "A losing wagerer sees that they lost the wager" do
  #       visit user_dashboard_path
  #
  #       click_on "Check Outcome"
  #       expect(page).to have_content("I Lost!")
  #       expect(page).to have_link("Rematch")
  #
  #     end
  #
  #     scenario "A winning wageree sees that they won the wager" do
  #       click_on "Logout"
  #       login_user ("Alexander")
  #       visit user_dashboard_path
  #       click_on "Check Outcome"
  #       expect(page).to have_content("I Won!")
  #       expect(page).to have_link("Rematch?")
  #
  #     end
  #
  #
  #   end
  #
  #
  end


end