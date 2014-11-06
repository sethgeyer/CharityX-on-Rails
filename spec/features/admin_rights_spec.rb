feature "admin rights" do

  scenario "visitor can not see Refresh Games link" do
    visit "/"
    expect(page).not_to have_link("Refresh Games")
    expect(page).not_to have_link("Refresh Outcomes")

  end

  context "Regular User has regsitered" do
    before(:each) do
      create_user("Stephen")
      visit "/"
    end

    scenario "user can not view refresh games" do
      login_user("Stephen")
      click_on "Dashboard"
      expect(page).to have_css("#show_dashboards")
      expect(page).not_to have_link("Refresh Outcomes")
    end
  end

  context "Admin User has regsitered and logged in" do
    before(:each) do
      create_admin("Administrator")
      visit "/"
      login_user("Administrator")
    end

    scenario "admin can see the refresh game button" do
      skip
      click_on "Refresh Games"
      expect(page).to have_content("256 NFL Games have been created")
    end

    scenario "admin can see the refresh outcomes button" do
      expect(page).to have_link("Refresh Outcomes")
    end

    context "admin wants to provide updates to game outcomes" do
      before(:each) do
        @wagerer = create_user_and_make_deposit("Stephen", 100)
        @wageree = create_user_and_make_deposit("Alexander", 100)

        week_16_game = SportsGame.create!(id: 243,
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

        week_9_game = SportsGame.create!(id: 242,
                                         uuid: "9526832f-092b-4e32-ad97-42dfeb5c201c",
                                         date: "2014-10-31T00:25:00+00:00",
                                         week: 9,
                                         home_id: "CAR",
                                         vs_id: "NO",
                                         status: "in_process",
                                         venue: "Bank of America Stadium",
                                         temperature: "57",
                                         condition: "Clear",
                                         full_home_name: "Carolina Panthers",
                                         full_visitor_name: "New Orleans Saints")

        week_1_game = SportsGame.create!(id: 241,
                                         uuid: "3c42f4ea-e4b3-449d-82d5-36850144add9",
                                         date: "2014-09-05T00:30:00+00:00",
                                         week: 1,
                                         home_id: "SEA",
                                         vs_id: "GB",
                                         status: "closed",
                                         venue: "CenturyLink Field",
                                         temperature: "73",
                                         condition: "Sunny",
                                         full_home_name: "Seattle Seahawks",
                                         full_visitor_name: "Green Bay Packers")

        week_1_outcome = SportsGamesOutcome.create!(game_uuid: "3c42f4ea-e4b3-449d-82d5-36850144add9",
                                                    home_id: "SEA",
                                                    home_score: 36,
                                                    vs_id: "GB",
                                                    vs_score: 16,
                                                    status: "closed",
                                                    quarter: 0,
                                                    clock: ":00")

        week_9_outcome = SportsGamesOutcome.create!(game_uuid: "9526832f-092b-4e32-ad97-42dfeb5c201c",
                                                    home_id: "CAR",
                                                    home_score: 10,
                                                    vs_id: "NO",
                                                    vs_score: 28,
                                                    status: "in_process",
                                                    quarter: 1,
                                                    clock: "3:00")



        @week_16_wager = Wager.create!(title: "The Denver Broncos beat the Cincinnati Bengals",
                                       date_of_wager: Date.today + 2.days,
                                       amount: 1000,
                                       wageree_id: @wageree.id,
                                       status: "accepted",
                                       user_id: @wagerer.id,
                                       wager_type: "SportsWager",
                                       game_uuid: "b5306b6f-9dbd-4da3-b412-efb3c13dfe86",
                                       selected_winner_id: "DEN")

        @week_9_wager = Wager.create!(title: "The New Orleans Saints beat the Carolina Panthers",
                                      date_of_wager: Date.today + 2.days,
                                      amount: 1000,
                                      wageree_id: @wageree.id,
                                      status: "accepted",
                                      user_id: @wagerer.id,
                                      wager_type: "SportsWager",
                                      game_uuid: "9526832f-092b-4e32-ad97-42dfeb5c201c",
                                      selected_winner_id: "NO")

        @week_1_wager = Wager.create!(title: "The Green Bay Packers beat the Seattle Seahawks",
                                      date_of_wager: Date.today + 2.days,
                                      amount: 1000,
                                      wageree_id: @wageree.id,
                                      status: "accepted",
                                      user_id: @wagerer.id,
                                      wager_type: "SportsWager",
                                      game_uuid: "3c42f4ea-e4b3-449d-82d5-36850144add9",
                                      selected_winner_id: "GB")


      end

      scenario "admin refreshes outcomes and see the number of outcomes updated" do

        click_on "Refresh Outcomes"
        expect(page).to have_content("1 game outcome has been updated")
      end

    end



  end

end
