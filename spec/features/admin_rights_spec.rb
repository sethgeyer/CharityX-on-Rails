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

        @game1 = create_a_sports_game({week: 1, status: "closed"})
        @game2 = create_a_sports_game({week: 9, status: "closed", home_id: "NE", vs_id: "DEN"})
        @game3 = create_a_sports_game({week: 16, status: "scheduled"})

        game1_outcome = create_a_sports_game_outcome(@game1.uuid)
        game2_outcome = create_a_sports_game_outcome(@game2.uuid, {status: "in_process"})


        game3_wager = create_a_sports_wager(@game3.uuid, @wagerer.id, @wageree.id, 10, @game3.home_id, @game3.vs_id)
        game2_wager = create_a_sports_wager(@game2.uuid, @wagerer.id, @wageree.id, 10, @game2.home_id, @game2.vs_id)
        game1_wager = create_a_sports_wager(@game1.uuid, @wagerer.id, @wageree.id, 10, @game1.home_id, @game1.vs_id)

      end

      scenario "admin refreshes outcomes and see the number of outcomes updated" do

        click_on "Refresh Outcomes"
        expect(page).to have_content("1 game outcome has been updated")
      end

    end



  end

end
